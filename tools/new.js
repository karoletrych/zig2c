#!/usr/bin/env node
'use strict';
/*
 * new.js - scaffold a new problem so adding #214 is one command.
 *
 * usage:
 *   node tools/new.js <dir>
 *   node tools/new.js two_sum --fn twoSum \
 *        --params "nums: [*]i32, target: i32, returnSize: *i32" --ret "?[*]i32"
 *
 * Creates problems/<dir>/solution.zig and driver.c, prints the C prototype
 * zig2c emits for the signature, and runs the verifier so you start from green.
 *
 * Options:
 *   --fn <name>      Zig function name            (default: camelCase of dir)
 *   --params <list>  comma-separated `name: Type` (default: none)
 *   --ret <Type>     return type                  (default: void)
 *   --no-verify      do not run the verifier
 */
const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..');

const argv = process.argv.slice(2);
let dir = null, fn = null, params = '', ret = 'void', verify = true;
for (let i = 0; i < argv.length; i++) {
  const a = argv[i];
  if (a === '--fn') fn = argv[++i];
  else if (a === '--params') params = argv[++i] || '';
  else if (a === '--ret') ret = argv[++i] || 'void';
  else if (a === '--no-verify') verify = false;
  else if (!a.startsWith('-')) dir = a;
  else { console.error(`unknown option ${a}`); process.exit(2); }
}
if (!dir) { console.error('usage: node tools/new.js <dir> [--fn name] [--params "a: T, b: T"] [--ret T] [--no-verify]'); process.exit(2); }

const camel = dir.replace(/[-_]+(\w)/g, (_, c) => c.toUpperCase()).replace(/^\w/, (c) => c.toLowerCase());
fn = fn || camel;

const dirPath = path.join(ROOT, 'problems', dir);
if (fs.existsSync(path.join(dirPath, 'solution.zig'))) {
  console.error(`problems/${dir}/solution.zig already exists - not overwriting`);
  process.exit(1);
}
fs.mkdirSync(dirPath, { recursive: true });

const paramList = params.split(',').map((s) => s.trim()).filter(Boolean);
const paramNames = paramList.map((p) => p.split(':')[0].trim());
const paramSig = paramList.join(', ');

// a body that compiles for common return types
let body;
if (ret === 'void') body = '    // TODO: implement';
else if (ret === 'bool') body = '    return false; // TODO';
else if (/^[?*]/.test(ret)) body = '    unreachable; // TODO: return a value';
else if (/^(f32|f64|i\d+|u\d+|usize|isize|c_int|c_uint)$/.test(ret)) body = '    return 0; // TODO';
else body = '    unreachable; // TODO: return a value';
const unused = paramNames.map((n) => `    _ = ${n};`).join('\n');

const sol = `// LeetCode ${dir}
// Keep the pub fn signature matched to the LeetCode C signature (see docs/AUTHORING.md).
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn ${fn}(${paramSig}) ${ret} {
${unused ? unused + '\n' : ''}${body}
}

test "${fn}" {
    // TODO: replace with a real assertion, e.g.
    // try std.testing.expectEqual(@as(i32, 0), ${fn}(${paramNames.map(() => 'TODO').join(', ')}));
}
`;

const drv = `#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    // TODO: call ${fn} and CHECK the results
    printf("${dir}: OK\\n");
    return 0;
}
`;

fs.writeFileSync(path.join(dirPath, 'solution.zig'), sol);
fs.writeFileSync(path.join(dirPath, 'driver.c'), drv);
console.log(`created problems/${dir}/solution.zig and driver.c  (fn: ${fn})`);

// show the C prototype zig2c will emit, so it can be compared with LeetCode's
const tr = spawnSync(process.execPath, [path.join(ROOT, 'zig2c', 'zig2c.js'), 'solution.zig'], { cwd: dirPath, encoding: 'utf8' });
if (tr.status === 0) {
  const proto = tr.stdout.split('\n').find((l) => l.includes(`${fn}(`) && l.trim().endsWith(';'));
  if (proto) console.log(`zig2c emits:\n  ${proto.trim()}`);
} else {
  console.error('zig2c could not translate the skeleton:');
  console.error((tr.stderr || tr.stdout || '').trim());
}

if (verify) {
  console.log('');
  const v = spawnSync(process.execPath, [path.join(ROOT, 'tools', 'verify.js'), dir], { stdio: 'inherit' });
  process.exit(v.status === null ? 1 : v.status);
}
