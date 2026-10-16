#!/usr/bin/env node
'use strict';
/*
 * verify.js - run the Zig source through `zig test` AND the generated C through
 * a C compiler, then run both. If both pass, the translation is trustworthy.
 *
 * usage: node tools/verify.js <problem> [<problem> ...]
 *        node tools/verify.js --all
 *        node tools/verify.js --all -j 4      # limit workers
 *        node tools/verify.js --all --force   # ignore the incremental cache
 *
 * Performance notes (measured):
 *
 *  - `zig test` is ~3.4s when it has to build a root file for the first time
 *    and ~0.1s once cached, so cache *reuse* dominates everything. Problems are
 *    therefore pinned to a stable worker slot (by index in the full problem
 *    list), so a problem's cached artifacts are always found again.
 *  - Concurrent zig invocations sharing one cache serialize on a lock, so each
 *    worker (and each of its two concurrent zig calls) gets its own cache dir.
 *  - `zig test` and `zig cc` are independent, so they run concurrently.
 *  - Translation runs in-process (no `node zig2c.js` subprocess per problem).
 *  - Unchanged problems are skipped entirely via a content hash.
 */
const fs = require('fs');
const os = require('os');
const path = require('path');
const crypto = require('crypto');
const { spawn } = require('child_process');

const ROOT = path.resolve(__dirname, '..');
const CACHE_FILE = path.join(ROOT, '.tools', 'verify-cache.json');
const CACHE_VERSION = 'v6';
const PROVIDED = ['ListNode', 'TreeNode', 'Node'];

function findZig() {
  if (process.env.ZIG && fs.existsSync(process.env.ZIG)) return process.env.ZIG;
  const tools = path.join(ROOT, '.tools');
  if (fs.existsSync(tools)) {
    for (const d of fs.readdirSync(tools)) {
      const p = path.join(tools, d, 'zig.exe');
      if (fs.existsSync(p)) return p;
      const p2 = path.join(tools, d, 'zig');
      if (fs.existsSync(p2)) return p2;
    }
  }
  return 'zig';
}

const ZIG = findZig();
const EXE = process.platform === 'win32' ? 'test.exe' : 'test';
const z2c = require(path.join(ROOT, 'zig2c', 'zig2c.js'));

function run(cmd, args, cwd, env) {
  return new Promise((resolve) => {
    const p = spawn(cmd, args, { cwd, env: env || process.env });
    let out = '';
    p.stdout.on('data', (d) => { out += d; });
    p.stderr.on('data', (d) => { out += d; });
    p.on('error', (e) => resolve({ code: 1, out: String((e && e.message) || e) }));
    p.on('close', (code) => resolve({ code: code === null ? 1 : code, out }));
  });
}

// Windows occasionally fails a link/exec because another worker still holds the
// output file. Retry those specific transient errors a couple of times.
async function runRetry(cmd, args, cwd, env) {
  let r = await run(cmd, args, cwd, env);
  for (let i = 0; i < 3 && r.code !== 0; i++) {
    if (!/Permission denied|Access is denied|failed to write output|cannot open/i.test(r.out)) break;
    await new Promise((res) => setTimeout(res, 150 * (i + 1)));
    r = await run(cmd, args, cwd, env);
  }
  return r;
}

const green = (s) => `\x1b[32m${s}\x1b[0m`;
const red = (s) => `\x1b[31m${s}\x1b[0m`;
const cyan = (s) => `\x1b[36m${s}\x1b[0m`;
const dim = (s) => `\x1b[2m${s}\x1b[0m`;

const indent = (s) => s.trimEnd().split('\n').map((l) => '        ' + l).join('\n');
const sha1 = (parts) => { const h = crypto.createHash('sha1'); for (const p of parts) h.update(p); return h.digest('hex'); };
const readFileOr = (f, dflt) => { try { return fs.readFileSync(f); } catch { return Buffer.from(dflt); } };
const base = (slot, kind) => path.join(os.tmpdir(), 'zig2c-cache', `w${slot}-${kind}`);const envFor = (slot, kind) => ({
  ...process.env,
  ZIG_GLOBAL_CACHE_DIR: base(slot, kind),
  ZIG_LOCAL_CACHE_DIR: base(slot, kind) + '-l',
});

function translate(dir) {
  const src = fs.readFileSync(path.join(dir, 'solution.zig'), 'utf8');
  const items = new z2c.Parser(z2c.lex(src), 'solution.zig').parseProgram();
  const c = new z2c.Emitter(items, { provided: PROVIDED }).emit();
  fs.writeFileSync(path.join(dir, 'leetcode.c'), c);
}

function sweep(dir) {
  for (const f of ['test.exe.tmp0', 'test.pdb']) {
    try { fs.rmSync(path.join(dir, f), { force: true }); } catch { /* ignore */ }
  }
}

async function verifyProblem(name, slot) {
  const dir = path.join(ROOT, 'problems', name);
  const lines = [];
  const log = (s) => lines.push(s);
  if (!fs.existsSync(dir)) { log(red(`  no such problem: ${name}`)); return { ok: false, lines }; }
  let ok = true;
  log(cyan(`=== ${name} ===`));

  // 1 + 2 + 3: the Zig test and the C build are independent, so overlap them.
  const testP = runRetry(ZIG, ['test', 'solution.zig', '-lc'], dir, envFor(slot, 'test'));

  let ccP = null;
  try {
    translate(dir);
    log(green('  [2/3] zig2c ok'));
    const driver = fs.existsSync(path.join(dir, 'driver.c')) ? 'driver.c' : null;
    if (!driver) {
      ccP = run(ZIG, ['cc', '-std=c11', '-fsyntax-only', 'leetcode.c'], dir, envFor(slot, 'cc'));
    } else {
      ccP = runRetry(ZIG, ['cc', '-O2', '-Wall', '-Wextra', '-std=c11', '-DZIG2C_LOCAL=1', '-o', EXE, driver], dir, envFor(slot, 'cc'));
    }
  } catch (err) {
    await testP;
    log(red('  [2/3] zig2c FAILED'));
    log(indent(String((err && err.message) || err)));
    return { ok: false, lines };
  }

  const [zt, cc] = await Promise.all([testP, ccP]);
  if (zt.code !== 0) { ok = false; log(red('  [1/3] zig test FAILED')); log(indent(zt.out)); }
  else log(green('  [1/3] zig test passed'));

  const hasDriver = fs.existsSync(path.join(dir, 'driver.c'));
  if (!hasDriver) {
    if (cc.code !== 0) { ok = false; log(red('  [3/3] C syntax check FAILED')); log(indent(cc.out)); }
    else log(green('  [3/3] C syntax ok (no driver.c)'));
    return { ok, lines };
  }
  if (cc.code !== 0) { ok = false; log(red('  [3/3] C compile FAILED')); log(indent(cc.out)); sweep(dir); return { ok, lines }; }
  const warns = cc.out.trim();
  const rr = await runRetry(path.join(dir, EXE), [], dir, envFor(slot, 'cc'));
  if (rr.code !== 0) { ok = false; log(red('  [3/3] C run FAILED')); log(indent(rr.out)); }
  else log(green(`  [3/3] C run passed${warns ? ' (with warnings)' : ''}`));
  if (warns) log(indent(warns));
  sweep(dir);
  return { ok, lines };
}

async function main() {
  const argv = process.argv.slice(2);
  let jobs = Math.min(os.cpus().length || 4, 8);
  let force = false;
  const names = [];
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '-j' || a === '--jobs') { jobs = parseInt(argv[++i], 10) || jobs; continue; }
    if (/^-j\d+$/.test(a)) { jobs = parseInt(a.slice(2), 10) || jobs; continue; }
    if (a === '-f' || a === '--force') { force = true; continue; }
    if (a === '--') continue;
    names.push(a);
  }
  const allNames = fs.readdirSync(path.join(ROOT, 'problems'))
    .filter((d) => fs.existsSync(path.join(ROOT, 'problems', d, 'solution.zig')))
    .sort();
  let list = names.filter((n) => n !== '--all');
  if (names.includes('--all') || list.length === 0) list = allNames;

  const zig2cHash = sha1([readFileOr(path.join(ROOT, 'zig2c', 'zig2c.js'), '')]);
  const verifierHash = sha1([readFileOr(__filename, ''), CACHE_VERSION]);
  let cache = {};
  try { cache = JSON.parse(fs.readFileSync(CACHE_FILE, 'utf8')).problems || {}; } catch { /* none */ }
  const keyOf = (name) => sha1([
    zig2cHash, verifierHash,
    readFileOr(path.join(ROOT, 'problems', name, 'solution.zig'), ''),
    readFileOr(path.join(ROOT, 'problems', name, 'driver.c'), ''),
  ]);

  const toRun = [];
  const cached = [];
  for (const name of list) {
    const k = keyOf(name);
    if (!force && cache[name] && cache[name].ok && cache[name].hash === k) cached.push(name);
    else toRun.push(name);
  }

  console.log(`using zig: ${ZIG}`);
  console.log(`verifying ${list.length} problem(s): ${toRun.length} to run, ${cached.length} cached, ${jobs} worker(s)\n`);

  // Pin each problem to a stable slot (by index in the FULL list) so its cached
  // zig artifacts are always found again, and partition work by slot.
  const idx = new Map(allNames.map((n, i) => [n, i]));
  const n = Math.max(1, Math.min(jobs, Math.max(1, toRun.length)));
  const queues = Array.from({ length: n }, () => []);
  for (const name of toRun) queues[((idx.get(name) || 0) % n)].push(name);

  const results = new Map();
  let done = 0;
  const t0 = Date.now();
  await Promise.all(queues.map(async (q, slot) => {
    for (const name of q) {
      results.set(name, await verifyProblem(name, slot));
      done++;
      process.stderr.write(`\r  progress ${done}/${toRun.length}   `);
    }
  }));
  const secs = ((Date.now() - t0) / 1000).toFixed(1);
  process.stderr.write('\r' + ' '.repeat(40) + '\r');

  let allOk = true;
  for (const name of cached) console.log(dim(`=== ${name} === (unchanged, cached)`));
  if (cached.length && toRun.length) console.log('');
  toRun.forEach((name, i) => {
    const r = results.get(name);
    if (r) {
      for (const l of r.lines) console.log(l);
      if (r.ok) cache[name] = { ok: true, hash: keyOf(name) };
      else { allOk = false; delete cache[name]; }
    }
    if (i !== toRun.length - 1) console.log('');
  });

  try {
    fs.mkdirSync(path.dirname(CACHE_FILE), { recursive: true });
    fs.writeFileSync(CACHE_FILE, JSON.stringify({ problems: cache }, null, 0));
  } catch { /* non-fatal */ }

  console.log('');
  console.log(allOk ? green('ALL PROBLEMS PASS (Zig and C agree)') : red('SOME PROBLEMS FAILED'));
  console.log(`(${list.length} problems: ${toRun.length} verified, ${cached.length} cached, in ${secs}s with ${n} workers)`);
  process.exit(allOk ? 0 : 1);
}

main();
