#!/usr/bin/env node
'use strict';
/*
 * zig2c - a deterministic Zig -> C translator for LeetCode-C submissions.
 *
 * Design goals:
 *   - Deterministic: same input always produces the same output. No network, no LLM.
 *   - Readable output: variable names preserved, no temporaries, no gotos.
 *   - Single-file output: the generated .c is self-contained for LeetCode.
 *   - Verifiable: the Zig source is real Zig and can be run with `zig test`.
 *
 * Usage: node zig2c.js solution.zig [-o out.c]
 */
const fs = require('fs');

/* ============================== LEXER ============================== */

const PUNCTS = [
  '<<=', '>>=', '...', '..<', '..', '=>', '->', '==', '!=', '<=', '>=',
  '+=', '-=', '*=', '/=', '%=', '|=', '&=', '^=', '<<', '>>', '.*', '.?',
  '{', '}', '(', ')', '[', ']', ',', ';', ':', '.', '=', '<', '>',
  '+', '-', '*', '/', '%', '&', '|', '^', '!', '~', '?', '@',
];

const isIdStart = (c) => /[A-Za-z_]/.test(c);
const isIdChar = (c) => /[A-Za-z0-9_]/.test(c);
const isDigit = (c) => c >= '0' && c <= '9';

function lex(src) {
  const toks = [];
  let i = 0, line = 1;
  let pendingComments = [];
  const n = src.length;

  while (i < n) {
    const c = src[i];
    if (c === '\n') { line++; i++; continue; }
    if (c === ' ' || c === '\t' || c === '\r') { i++; continue; }

    // comments (Zig has only // style)
    if (c === '/' && src[i + 1] === '/') {
      let j = i; while (j < n && src[j] !== '\n') j++;
      pendingComments.push(src.slice(i, j).trimEnd());
      i = j; continue;
    }

    const startPos = i;

    // string literal
    if (c === '"') {
      let j = i + 1, out = '"';
      while (j < n && src[j] !== '"') {
        if (src[j] === '\\') { out += src[j] + src[j + 1]; j += 2; continue; }
        if (src[j] === '\n') throw new Error(`line ${line}: unterminated string`);
        out += src[j]; j++;
      }
      if (j >= n) throw new Error(`line ${line}: unterminated string`);
      out += '"';
      toks.push({ t: 'str', v: out, pos: startPos, line, comments: pendingComments }); pendingComments = [];
      i = j + 1; continue;
    }

    // char literal
    if (c === "'") {
      let j = i + 1, body = '';
      while (j < n && src[j] !== "'") {
        if (src[j] === '\\') { body += src[j] + src[j + 1]; j += 2; continue; }
        body += src[j]; j++;
      }
      if (j >= n) throw new Error(`line ${line}: unterminated char literal`);
      toks.push({ t: 'char', v: body, pos: startPos, line, comments: pendingComments }); pendingComments = [];
      i = j + 1; continue;
    }

    // number
    if (isDigit(c)) {
      let j = i;
      if (c === '0' && /[xXbBoO]/.test(src[j + 1] || '')) {
        j += 2;
        while (j < n && /[0-9a-fA-F_]/.test(src[j])) j++;
        const raw = src.slice(i, j).replace(/_/g, '');
        toks.push({ t: 'int', v: raw, pos: startPos, line, comments: pendingComments }); pendingComments = [];
        i = j; continue;
      }
      let isFloat = false;
      while (j < n && /[0-9_]/.test(src[j])) j++;
      if (src[j] === '.' && isDigit(src[j + 1] || '')) {
        isFloat = true; j++;
        while (j < n && /[0-9_]/.test(src[j])) j++;
      }
      if ((src[j] === 'e' || src[j] === 'E') && /[0-9+\-]/.test(src[j + 1] || '')) {
        isFloat = true; j++;
        if (src[j] === '+' || src[j] === '-') j++;
        while (j < n && /[0-9_]/.test(src[j])) j++;
      }
      const raw = src.slice(i, j).replace(/_/g, '');
      toks.push({ t: isFloat ? 'float' : 'int', v: raw, pos: startPos, line, comments: pendingComments }); pendingComments = [];
      i = j; continue;
    }

    // builtin identifier  @name
    if (c === '@') {
      let j = i + 1;
      while (j < n && isIdChar(src[j])) j++;
      if (j === i + 1) throw new Error(`line ${line}: stray '@'`);
      toks.push({ t: 'id', v: src.slice(i, j), pos: startPos, line, comments: pendingComments }); pendingComments = [];
      i = j; continue;
    }

    // identifier / keyword
    if (isIdStart(c)) {
      let j = i;
      while (j < n && isIdChar(src[j])) j++;
      toks.push({ t: 'id', v: src.slice(i, j), pos: startPos, line, comments: pendingComments }); pendingComments = [];
      i = j; continue;
    }

    // punctuation (longest match)
    let matched = null;
    for (const p of PUNCTS) {
      if (src.startsWith(p, i)) { matched = p; break; }
    }
    if (!matched) throw new Error(`line ${line}: unexpected character ${JSON.stringify(c)}`);
    toks.push({ t: 'punc', v: matched, pos: startPos, line, comments: pendingComments }); pendingComments = [];
    i += matched.length;
  }
  toks.push({ t: 'eof', v: '', pos: n, line, comments: pendingComments });
  return toks;
}

/* ============================== TYPE MODEL ============================== */

const PRIM_CTYPE = {
  void: 'void', bool: 'bool', char: 'char',
  i8: 'int8_t', i16: 'int16_t', i32: 'int', i64: 'long long',
  u8: 'char', u16: 'uint16_t', u32: 'uint32_t', u64: 'unsigned long long',
  usize: 'size_t', isize: 'ptrdiff_t',
  f32: 'float', f64: 'double',
  c_int: 'int', c_uint: 'unsigned int', c_char: 'char',
};

function prim(name) { return { k: 'prim', name }; }
function ptr(child, opts = {}) { return { k: 'ptr', child, isConst: !!opts.isConst, ptrKind: opts.ptrKind || 'many' }; }
function slice(child, opts = {}) { return { k: 'slice', child, isConst: !!opts.isConst }; }
function optional(child) { return { k: 'optional', child }; }
function array(child, len) { return { k: 'array', child, len }; }
function named(name, args) { return { k: 'named', name, args: args || null }; }
function fnTy(params, ret) { return { k: 'fn', params, ret }; }

function tyEq(a, b) {
  if (!a || !b) return false;
  if (a.k !== b.k) return false;
  switch (a.k) {
    case 'prim': return a.name === b.name;
    case 'named': return a.name === b.name;
    case 'ptr': return a.isConst === b.isConst && a.ptrKind === b.ptrKind && tyEq(a.child, b.child);
    case 'slice': return a.isConst === b.isConst && tyEq(a.child, b.child);
    case 'optional': return tyEq(a.child, b.child);
    case 'array': return tyEq(a.child, b.child);
    case 'fn': return true;
    default: return false;
  }
}

/* ============================== PARSER ============================== */

const ASSIGN_OPS = new Set(['=', '+=', '-=', '*=', '/=', '%=', '|=', '&=', '^=', '<<=', '>>=']);
const PRIM_NAMES = new Set(Object.keys(PRIM_CTYPE));
const STMT_KEYWORDS = new Set(['return', 'break', 'continue', 'defer', 'errdefer', 'var', 'const', 'if', 'while', 'for', 'switch', 'unreachable', 'nosuspend', 'comptime', 'inline']);

const BIN_PREC = {
  '..': 1, '..<': 1,
  'orelse': 2, 'catch': 2,
  'or': 3,
  'and': 4,
  '==': 5, '!=': 5, '<': 5, '>': 5, '<=': 5, '>=': 5,
  '|': 6, '^': 7, '&': 8,
  '<<': 9, '>>': 9,
  '+': 10, '-': 10,
  '*': 11, '/': 11, '%': 11,
};

class Parser {
  constructor(toks, file) {
    this.toks = toks; this.i = 0; this.file = file;
    this.typeNames = new Set(PRIM_NAMES);
  }

  peek(o = 0) { return this.toks[this.i + o]; }
  next() { return this.toks[this.i++]; }
  at(v) { const t = this.peek(); return t.t === 'punc' && t.v === v; }
  atId(v) { const t = this.peek(); return t.t === 'id' && t.v === v; }
  eat(v) { if (this.at(v)) { this.next(); return true; } return false; }
  eatId(v) { if (this.atId(v)) { this.next(); return true; } return false; }
  expect(v) { if (!this.eat(v)) this.err(`expected '${v}' but found '${this.peek().v}'`); }
  err(msg) { throw new Error(`${this.file}: line ${this.peek().line}: ${msg}`); }

  /* ---- top level ---- */
  parseProgram() {
    const items = [];
    while (this.peek().t !== 'eof') {
      const item = this.parseTopItem();
      if (item) items.push(item);
    }
    return items;
  }

  parseTopItem() {
    const comments = this.peek().comments || [];
    let isPub = false;
    while (this.atId('pub') || this.atId('export') || this.atId('inline') || this.atId('noinline') || this.atId('extern')) {
      const kw = this.next().v;
      if (kw === 'pub' || kw === 'export') isPub = true;
    }
    if (this.atId('test')) {
      this.next();
      if (this.peek().t === 'str') this.next();
      this.skipBalanced();
      return { k: 'test', comments };
    }
    if (this.atId('const') || this.atId('var')) {
      const isConst = this.next().v === 'const';
      const nameTok = this.next();
      if (nameTok.t !== 'id') this.err('expected name');
      const name = nameTok.v;
      let typeAnn = null;
      if (this.eat(':')) typeAnn = this.parseType();
      if (!this.eat('=')) this.err(`expected '=' after top-level ${isConst ? 'const' : 'var'} ${name}`);
      // struct / enum / union declaration?
      if (this.peek().t === 'id' && ['struct', 'enum', 'union', 'opaque'].includes(this.peek().v)) {
        const kind = this.next().v;
        if (kind === 'struct') {
          const fields = this.parseStructBody();
          this.expect(';');
          this.typeNames.add(name);
          return { k: 'struct', name, fields, comments };
        }
        this.typeNames.add(name);
        // skip enum/union bodies for now (treated as unknown named type)
        this.skipBalanced();
        this.expect(';');
        return { k: 'opaque', name, comments };
      }
      const init = this.parseExpr();
      this.expect(';');
      return { k: 'toplevel_const', name, isConst, typeAnn, init, comments, isPub };
    }
    if (this.atId('fn')) {
      return this.parseFn(isPub, comments);
    }
    if (this.atId('usingnamespace')) { this.next(); this.parseExpr(); this.expect(';'); return null; }
    this.err(`unexpected top-level token '${this.peek().v}'`);
  }

  parseStructBody() {
    this.expect('{');
    const fields = [];
    while (!this.at('}')) {
      const cs = this.peek().comments || [];
      while (this.peek().t === 'id' && this.atId('comptime')) this.next();
      const nameTok = this.next();
      if (nameTok.t !== 'id') this.err('expected field name');
      let ty;
      if (this.eat(':')) {
        ty = this.parseType();
      } else {
        // no type: struct field without type (e.g. comptime) -> skip
        ty = null;
      }
      if (this.eat('=')) { this.parseExpr(); }
      this.expect(',');
      if (ty) fields.push({ name: nameTok.v, ty, comments: cs });
    }
    this.expect('}');
    return fields;
  }

  parseFn(isPub, comments) {
    this.next(); // 'fn'
    const nameTok = this.next();
    if (nameTok.t !== 'id') this.err('expected function name');
    const name = nameTok.v;
    this.expect('(');
    const params = [];
    while (!this.at(')')) {
      if (this.eatId('comptime')) { /* ignore */ }
      const pname = this.next();
      if (pname.t !== 'id') this.err('expected parameter name');
      this.expect(':');
      const pty = this.parseType();
      params.push({ name: pname.v, ty: pty });
      if (!this.eat(',')) break;
    }
    this.expect(')');
    let ret = prim('void');
    if (!this.at('{')) ret = this.parseType();
    let body = null;
    if (this.at('{')) body = this.parseBlock();
    else if (this.eat(';')) body = null;
    return { k: 'fn', name, params, ret, body, comments, isPub };
  }

  /* ---- types ---- */
  parseType() {
    // error unions: `!T` / `Error!T` -> just the payload type (errors are ignored)
    if (this.at('!')) { this.next(); return this.parseType(); }
    if (this.eat('?')) {
      const inner = this.parseType();
      return optional(inner);
    }
    if (this.eat('*')) {
      const isConst = this.eatId('const');
      if (this.eat('[')) {
        let ptrKind = 'many';
        if (this.atId('c')) { this.next(); ptrKind = 'c'; }
        this.expect(']');
        const c2 = this.eatId('const');
        return ptr(this.parseType(), { isConst: isConst || c2, ptrKind });
      }
      // *align(n) T
      if (this.atId('align')) { this.next(); this.expect('('); this.parseExpr(); this.expect(')'); }
      return ptr(this.parseType(), { isConst, ptrKind: 'single' });
    }
    if (this.eat('[')) {
      if (this.eat(']')) {
        const isConst = this.eatId('const');
        return slice(this.parseType(), { isConst });
      }
      if (this.eat('*')) {
        let ptrKind = 'many';
        if (this.atId('c')) { this.next(); ptrKind = 'c'; }
        this.expect(']');
        const isConst = this.eatId('const');
        return ptr(this.parseType(), { isConst, ptrKind });
      }
      const len = this.parseExpr();
      this.expect(']');
      const isConst = this.eatId('const');
      const child = this.parseType();
      const t = array(child, len);
      if (isConst) t.childConst = true;
      return t;
    }
    if (this.atId('fn')) {
      this.next();
      this.expect('(');
      const ps = [];
      while (!this.at(')')) { this.next(); if (!this.eat(',')) break; }
      this.expect(')');
      let ret = prim('void');
      if (!this.at('{') && !this.at(';') && !this.at(',')) ret = this.parseType();
      return fnTy(ps, ret);
    }
    const tok = this.next();
    if (tok.t !== 'id') this.err(`expected a type but found '${tok.v}'`);
    let name = tok.v;
    while (this.eat('.')) {
      const nx = this.next();
      if (nx.t !== 'id') this.err("expected a name after '.' in a type");
      name += '.' + nx.v;
    }
    if (this.at('!')) { this.next(); return this.parseType(); }
    if (this.at('(')) {
      this.next();
      const args = [];
      while (!this.at(')')) {
        args.push(this.parseType());
        if (!this.eat(',')) break;
      }
      this.expect(')');
      return named(name, args);
    }
    return named(name);
  }

  skipBalanced() {
    this.expect('{');
    let depth = 1;
    while (depth > 0 && this.peek().t !== 'eof') {
      const t = this.next();
      if (t.t === 'punc' && t.v === '{') depth++;
      else if (t.t === 'punc' && t.v === '}') depth--;
    }
  }

  /* ---- statements ---- */
  parseBlock() {
    this.expect('{');
    const stmts = [];
    while (!this.at('}')) {
      if (this.peek().t === 'eof') this.err('unexpected EOF, missing }');
      stmts.push(this.parseStmt());
    }
    this.expect('}');
    return { k: 'block', stmts };
  }

  parseStmt() {
    const comments = this.peek().comments || [];
    if (this.at(';')) { this.next(); return { k: 'expr', expr: { k: 'ident', name: '_' }, comments }; }
    // label:  name: while(...)
    if (this.peek().t === 'id' && this.peek(1).t === 'punc' && this.peek(1).v === ':' && !ASSIGN_OPS.has(':')) {
      const label = this.next().v; this.next();
      const inner = this.parseStmt();
      inner.label = label;
      return inner;
    }
    if (this.atId('var') || this.atId('const')) {
      const isConst = this.next().v === 'const';
      const decls = [];
      // possible tuple:  const a, b = ...
      const names = [];
      names.push(this.next().v);
      while (this.eat(',')) {
        if (this.atId('var') || this.atId('const')) { /* const a, var b */ this.next(); }
        names.push(this.next().v);
      }
      let typeAnn = null;
      if (this.eat(':')) typeAnn = this.parseType();
      this.expect('=');
      const inits = [this.parseExpr()];
      while (this.eat(',')) inits.push(this.parseExpr());
      this.expect(';');
      return { k: 'var', isConst, names, typeAnn, inits, comments };
    }
    if (this.atId('if')) return this.parseIfStmt(comments);
    if (this.atId('while')) return this.parseWhile(comments);
    if (this.atId('for')) return this.parseFor(comments);
    if (this.atId('return')) {
      this.next();
      let value = null;
      if (!this.at(';')) value = this.parseExpr();
      this.expect(';');
      return { k: 'return', value, comments };
    }
    if (this.atId('break')) { this.next(); this.expect(';'); return { k: 'break', comments }; }
    if (this.atId('continue')) { this.next(); this.expect(';'); return { k: 'continue', comments }; }
    if (this.atId('defer')) { this.next(); const e = this.parseExpr(); this.expect(';'); return { k: 'defer', expr: e, comments }; }
    if (this.atId('errdefer')) { this.next(); const e = this.parseExpr(); this.expect(';'); return { k: 'expr', expr: e, comments }; }
    if (this.atId('comptime')) { this.next(); return this.parseStmt(); }
    if (this.atId('unreachable')) { this.next(); this.expect(';'); return { k: 'expr', expr: { k: 'abort' }, comments }; }
    if (this.at('{')) { const b = this.parseBlock(); return b; }
    if (this.atId('switch')) return this.parseSwitch(comments);
    if (this.atId('nosuspend')) { this.next(); return this.parseStmt(); }

    // discard:  _ = expr;
    // expression / assignment
    const startExpr = this.parseExpr();
    if (startExpr.k === 'exprseq') return { k: 'expr', expr: startExpr, comments };
    if (this.peek().t === 'punc' && ASSIGN_OPS.has(this.peek().v)) {
      const op = this.next().v;
      const lhs = [startExpr];
      while (this.eat(',')) lhs.push(this.parseExpr());
      const rhs = [this.parseExpr()];
      while (this.eat(',')) rhs.push(this.parseExpr());
      this.expect(';');
      return { k: 'assign', op, lhs, rhs, comments };
    }
    this.expect(';');
    return { k: 'expr', expr: startExpr, comments };
  }

  parseBlockOrSingle() {
    // Parses an if/while/for body. Handles:
    //   { ... }             block
    //   return x;           statement body (consumes its own ';')
    //   x += 1              expression body (no ';' here; caller may eat one)
    if (this.at('{')) return this.parseBlock();
    const kw = this.peek();
    if (kw.t === 'id' && STMT_KEYWORDS.has(kw.v)) {
      return { k: 'block', stmts: [this.parseStmt()] };
    }
    const e = this.parseAssignExpr();
    this.eat(';');
    return { k: 'block', stmts: [{ k: 'expr', expr: e }] };
  }

  parseIfStmt(comments) {
    this.next(); // if
    this.expect('(');
    const cond = this.parseExpr();
    this.expect(')');
    let capture = null;
    if (this.eat('|')) { capture = this.next().v; this.expect('|'); }
    const then = this.parseBlockOrSingle();
    let els = null;
    if (this.eatId('else')) {
      if (this.atId('if')) els = this.parseIfStmt([]);
      else els = this.parseBlockOrSingle();
    }
    return { k: 'if', cond, capture, then, else: els, comments };
  }

  parseWhile(comments) {
    this.next(); // while
    this.expect('(');
    const cond = this.parseExpr();
    this.expect(')');
    let capture = null;
    if (this.eat('|')) { capture = this.next().v; this.expect('|'); }
    let cont = null;
    if (this.eat(':')) {
      this.expect('(');
      if (!this.eat(')')) { cont = this.parseAssignExpr(); this.expect(')'); }
    }
    if (this.eatId('else')) this.parseBlockOrSingle();
    const body = this.parseBlockOrSingle();
    return { k: 'while', cond, capture, cont, body, comments, label: null };
  }

  parseFor(comments) {
    this.next(); // for
    this.expect('(');
    const items = [this.parseExpr()];
    while (this.eat(',')) items.push(this.parseExpr());
    this.expect(')');
    const captures = [];
    if (this.eat('|')) {
      captures.push(this.next().v);
      while (this.eat(',')) captures.push(this.next().v);
      this.expect('|');
    }
    if (this.eatId('else')) this.parseBlockOrSingle();
    const body = this.parseBlockOrSingle();
    return { k: 'for', items, captures, body, comments, label: null };
  }

  parseSwitch(comments) {
    this.next(); // switch
    this.expect('(');
    const subject = this.parseExpr();
    this.expect(')');
    this.expect('{');
    const arms = [];
    while (!this.at('}')) {
      const vals = [this.parseExpr()];
      while (this.eat(',')) vals.push(this.parseExpr());
      this.expect('=>');
      let body;
      if (this.at('{')) body = this.parseBlock();
      else { const e = this.parseExpr(); body = { k: 'block', stmts: [{ k: 'return', value: e }] }; }
      if (this.at(',')) this.next();
      arms.push({ vals, body });
    }
    this.expect('}');
    return { k: 'switch', subject, arms, comments };
  }

  parseAssignExpr() {
    const lhs = this.parseExpr();
    if (this.peek().t === 'punc' && ASSIGN_OPS.has(this.peek().v)) {
      const op = this.next().v;
      const rhs = this.parseExpr();
      return { k: 'assignexpr', op, lhs, rhs };
    }
    return lhs;
  }

  /* ---- expressions (Pratt) ---- */
  parseExpr(minPrec = 0) {
    let left = this.parsePrefix();
    for (;;) {
      const t = this.peek();
      // postfix
      if (t.t === 'punc' && t.v === '(') { left = this.parseCall(left); continue; }
      if (t.t === 'punc' && t.v === '[') { left = this.parseIndexOrSlice(left); continue; }
      if (t.t === 'punc' && t.v === '.') {
        this.next();
        if (this.eat('?')) { left = { k: 'unwrap', obj: left }; continue; }
        if (this.eat('*')) { left = { k: 'deref', obj: left }; continue; }
        const f = this.next();
        if (f.t !== 'id') this.err("expected field name after '.'");
        left = { k: 'field', obj: left, name: f.v };
        continue;
      }
      if (t.t === 'punc' && t.v === '.*') { this.next(); left = { k: 'deref', obj: left }; continue; }
      if (t.t === 'punc' && t.v === '.?') { this.next(); left = { k: 'unwrap', obj: left }; continue; }

      let op = null;
      if (t.t === 'punc' && BIN_PREC[t.v] !== undefined) op = t.v;
      else if (t.t === 'id' && (t.v === 'and' || t.v === 'or' || t.v === 'orelse' || t.v === 'catch')) op = t.v;
      if (op === null) break;
      const prec = BIN_PREC[op];
      if (prec < minPrec) break;
      this.next();
      if (op === 'catch' && (this.atId('return') || this.atId('break') || this.atId('continue'))) {
        // `x catch return y;` / `x catch continue;` -- the handler is a statement.
        const kw = this.next().v;
        if (kw === 'return' && !this.at(';')) this.parseExpr();
        this.expect(';');
        return { k: 'exprseq', lhs: left };
      }
      if (op === '..' || op === '..<') {
        if (this.at(')') || this.at(',') || this.at('|') || this.at(';')) {
          left = { k: 'binop', op, l: left, r: null };
          continue;
        }
      }
      const right = this.parseExpr(prec + 1);
      left = { k: 'binop', op, l: left, r: right };
    }
    return left;
  }

  parsePrefix() {
    const t = this.peek();
    if (t.t === 'int') { this.next(); return { k: 'int', v: t.v }; }
    if (t.t === 'float') { this.next(); return { k: 'float', v: t.v }; }
    if (t.t === 'str') { this.next(); return { k: 'str', v: t.v }; }
    if (t.t === 'char') { this.next(); return { k: 'char', v: t.v }; }
    if (t.t === 'punc' && (t.v === '-' || t.v === '!' || t.v === '~' || t.v === '&' || t.v === '?')) {
      this.next();
      const e = this.parseExpr(12);
      if (t.v === '&') return { k: 'addr', obj: e };
      if (t.v === '?') return { k: 'optprefix', obj: e };
      return { k: 'unop', op: t.v, e };
    }
    if (t.t === 'punc' && t.v === '*') {
      // deref of an expression (rare as prefix)
      this.next();
      const e = this.parseExpr(12);
      return { k: 'deref', obj: e };
    }
    if (t.t === 'punc' && t.v === '.') {
      // .{ ... }  anonymous struct/list literal
      this.next();
      if (this.at('{')) return this.parseBracedInit(null);
      const id = this.next();
      if (id.t === 'id') return { k: 'enumlit', name: id.v };
      this.err("expected '{' or identifier after '.'");
    }
    if (t.t === 'punc' && t.v === '(') {
      this.next();
      const e = this.parseExpr();
      this.expect(')');
      return e;
    }
    if (t.t === 'punc' && t.v === '{') {
      // braced init without explicit type:  { .a = 1 }  (only valid in some contexts)
      return this.parseBracedInit(null);
    }
    if (t.t === 'punc' && t.v === '[') {
      // array literal:  [_]T{...}  or  [N]T{...}
      const ty = this.parseType();
      if (this.at('{')) return this.parseBracedInit(ty);
      this.err('expected an array literal after a [N]T type');
    }
    if (t.t === 'id') {
      // literal-like keywords
      if (t.v === 'true' || t.v === 'false') { this.next(); return { k: 'bool', v: t.v }; }
      if (t.v === 'null') { this.next(); return { k: 'null' }; }
      if (t.v === 'undefined') { this.next(); return { k: 'undefined' }; }
      if (t.v === 'try') { this.next(); return this.parseExpr(12); }
      if (t.v === 'if') return this.parseIfExpr();
      // type application:  T{ ... }   or  T{ }  or Ident
      if (this.peek(1).t === 'punc' && this.peek(1).v === '{') {
        const name = this.next().v;
        return this.parseBracedInit({ k: 'named', name });
      }
      // generic instantiation:  Foo(i32)  handled as call
      this.next();
      if (t.v.startsWith('@')) return { k: 'builtin', name: t.v, args: null };
      return { k: 'ident', name: t.v };
    }
    this.err(`unexpected token '${t.v}' in expression`);
  }

  parseIfExpr() {
    this.next(); // if
    this.expect('(');
    const cond = this.parseExpr();
    this.expect(')');
    let capture = null;
    if (this.eat('|')) { capture = this.next().v; this.expect('|'); }
    const then = this.parseBlockOrExpr();
    let els = null;
    if (this.eatId('else')) els = this.parseIfExprOrExpr();
    return { k: 'ifexpr', cond, capture, then, else: els };
  }

  parseIfExprOrExpr() {
    if (this.atId('if')) return this.parseIfExpr();
    return this.parseBlockOrExpr();
  }

  parseBlockOrExpr() {
    if (this.at('{')) {
      // could be a block; parse as block
      const b = this.parseBlock();
      return b;
    }
    return this.parseExpr();
  }

  parseBracedInit(ty) {
    // .{ .a = 1, 2, 3 }  or  T{ .a = 1 }  or  T{1,2,3}
    this.expect('{');
    const fields = [];
    const elems = [];
    while (!this.at('}')) {
      if (this.at('.') && this.peek(1).t === 'id' && this.peek(2).t === 'punc' && this.peek(2).v === '=') {
        this.next();
        const fn = this.next().v;
        this.next(); // =
        const v = this.parseExpr();
        fields.push({ name: fn, value: v });
      } else {
        elems.push(this.parseExpr());
      }
      if (!this.eat(',')) break;
    }
    this.expect('}');
    if (fields.length) return { k: 'structinit', ty, fields };
    return { k: 'arrayinit', ty, elems };
  }

  looksLikeTypeStart() {
    const t = this.peek();
    if (t.t === 'punc' && (t.v === '[' || t.v === '?')) return true;
    if (t.t === 'punc' && t.v === '*') return true;
    if (t.t === 'id' && this.typeNames.has(t.v)) return true;
    return false;
  }

  // An argument that may be a type (Zig passes types as values, e.g. alloc(i32, 2)).
  parseArg() {
    if (this.looksLikeTypeStart()) {
      const save = this.i;
      try {
        const ty = this.parseType();
        const nxt = this.peek();
        if (nxt.t === 'punc' && (nxt.v === ',' || nxt.v === ')')) {
          return { k: 'type', ty };
        }
      } catch (e) { /* fall through */ }
      this.i = save;
    }
    return this.parseExpr();
  }

  parseCall(callee) {
    this.expect('(');
    const args = [];
    while (!this.at(')')) {
      args.push(this.parseArg());
      if (!this.eat(',')) break;
    }
    this.expect(')');
    if (callee.k === 'builtin' && callee.args === null) {
      return { k: 'builtin', name: callee.name, args };
    }
    return { k: 'call', callee, args };
  }

  parseIndexOrSlice(obj) {
    this.expect('[');
    // parse the start with precedence above `..` so `a..b` is not swallowed as a range
    let start = null;
    if (!this.at('..') && !this.at('..<')) start = this.parseExpr(2);
    if (this.at('..') || this.at('..<')) {
      this.next();
      let end = null;
      if (!this.at(']')) end = this.parseExpr(2);
      this.expect(']');
      return { k: 'slicex', obj, start, end };
    }
    this.expect(']');
    return { k: 'index', obj, index: start };
  }
}

/* ============================== EMITTER ============================== */

const CMP_OP = { '==': '==', '!=': '!=', '<': '<', '>': '>', '<=': '<=', '>=': '>=' };
const ARITH_OP = { '+': '+', '-': '-', '*': '*', '/': '/', '%': '%', '<<': '<<', '>>': '>>', '&': '&', '|': '|', '^': '^' };

class Emitter {
  constructor(items, opts) {
    this.items = items;
    this.opts = opts || {};
    this.structs = new Map();   // name -> fields
    this.functions = new Map(); // name -> {params, ret}
    this.sliceTypes = new Map(); // name -> {child, isConst}
    this.helpers = new Set();
    this.cmpWrappers = [];
    this.cmpCount = 0;
    this.tmpCount = 0;
    this.scopes = [];
    this.loops = [];
    this.body = [];        // emitted C body lines
    this.constLines = [];
    this.topConsts = new Map();
    this.enumConsts = [];
    // Structs that LeetCode's C harness already defines. We must not redefine
    // them in the submitted file; for local testing they are emitted behind
    // the ZIG2C_LOCAL macro.
    this.providedStructs = new Set(this.opts.provided || ['ListNode', 'TreeNode', 'Node']);
    this.listTypes = new Map();  // name -> { elemTy }
    this.mapTypes = new Map();   // name -> { keyTy, valTy, keyKind }
    this.iterTypes = new Map();  // name -> { kind, mapName, elemTy }
    this.optTypes = new Map();   // name -> { childTy }
    this.auxStructs = new Map(); // name -> fields (for lookup only; e.g. getOrPut results)
  }

  isCharLike(ty) {
    return !!ty && (ty.k === 'prim' || ty.k === 'named') &&
      (ty.name === 'u8' || ty.name === 'c_char' || ty.name === 'char');
  }

  isPointerish(ty) {
    if (!ty) return false;
    if (ty.k === 'ptr' || ty.k === 'slice') return true;
    if (ty.k === 'optional') return this.isPointerish(ty.child);
    return false;
  }

  isList(ty) { return ty && ty.k === 'named' && (this.listTypes.has(ty.name) || ty.name === 'std.ArrayList' || ty.name === 'std.ArrayListUnmanaged'); }
  isMap(ty) { return ty && ty.k === 'named' && (this.mapTypes.has(ty.name) || ty.name === 'std.AutoHashMap' || ty.name === 'std.AutoHashMapUnmanaged' || ty.name === 'std.StringHashMap' || ty.name === 'std.StringHashMapUnmanaged'); }

  optName(childTy) {
    const name = `zig_opt_${this.mangle(childTy)}`;
    if (!this.optTypes.has(name)) this.optTypes.set(name, { childTy });
    return name;
  }

  listName(elemTy) {
    const name = `zig_ArrayList_${this.mangle(elemTy)}`;
    if (!this.listTypes.has(name)) {
      this.listTypes.set(name, { elemTy });
      this.cType(slice(elemTy, {}));
    }
    return name;
  }

  mapName(keyTy, valTy, keyKind) {
    keyKind = keyKind || 'int';
    const base = keyKind === 'str' ? 'zig_SMap' : 'zig_Map';
    const name = `${base}_${this.mangle(keyTy)}_${this.mangle(valTy)}`;
    if (!this.mapTypes.has(name)) {
      this.mapTypes.set(name, { keyTy, valTy, keyKind });
      if (valTy.k !== 'ptr') this.optName(valTy);
      this.auxStructs.set(`${name}_GOP`, [
        { name: 'found_existing', ty: prim('bool') },
        { name: 'key_ptr', ty: ptr(keyTy, { ptrKind: 'single' }) },
        { name: 'value_ptr', ty: ptr(valTy, { ptrKind: 'single' }) },
      ]);
      this.auxStructs.set(`${name}_EntryRef`, [
        { name: 'key_ptr', ty: ptr(keyTy, { ptrKind: 'single' }) },
        { name: 'value_ptr', ty: ptr(valTy, { ptrKind: 'single' }) },
      ]);
    }
    return name;
  }

  // `std.StringHashMap(V)` / `std.StringHashMapUnmanaged(V)`: slice keys.
  strMapName(valTy) {
    return this.mapName(slice(prim('u8'), { isConst: true }), valTy, 'str');
  }

  iterName(mi, kind) {
    const suffix = kind === 'entry' ? 'Iter' : kind === 'key' ? 'KeyIter' : 'ValIter';
    const name = `${mi.name}_${suffix}`;
    if (!this.iterTypes.has(name)) {
      const elemTy = kind === 'entry' ? named(`${mi.name}_EntryRef`) : kind === 'key' ? mi.keyTy : mi.valTy;
      this.iterTypes.set(name, { kind, mapName: mi.name, elemTy });
    }
    return name;
  }

  /* ---------- setup ---------- */
  prescan() {
    for (const it of this.items) {
      if (it.k === 'struct') this.structs.set(it.name, it.fields);
      if (it.k === 'fn') this.functions.set(it.name, { params: it.params, ret: it.ret });
      if (it.k === 'toplevel_const' && it.isConst) this.topConsts.set(it.name, it);
    }
  }

  /* ---------- type -> C ---------- */
  cType(ty) {
    if (!ty) return 'void';
    switch (ty.k) {
      case 'prim': {
        if (PRIM_CTYPE[ty.name]) return PRIM_CTYPE[ty.name];
        if (this.structs.has(ty.name)) return ty.name;
        throw new Error(`unknown type '${ty.name}'`);
      }
      case 'named': {
        if (ty.name === 'std.ArrayList' || ty.name === 'std.ArrayListUnmanaged') {
          if (!ty.args || !ty.args[0]) throw new Error('std.ArrayList needs an element type, e.g. std.ArrayList(i32)');
          return this.listName(ty.args[0]);
        }
        if (ty.name === 'std.AutoHashMap' || ty.name === 'std.AutoHashMapUnmanaged') {
          if (!ty.args || !ty.args[1]) throw new Error('std.AutoHashMap needs key and value types, e.g. std.AutoHashMap(i32, i32)');
          return this.mapName(ty.args[0], ty.args[1]);
        }
        if (ty.name === 'std.StringHashMap' || ty.name === 'std.StringHashMapUnmanaged') {
          if (!ty.args || !ty.args[0]) throw new Error('std.StringHashMap needs a value type, e.g. std.StringHashMap(i32)');
          return this.strMapName(ty.args[0]);
        }
        if (PRIM_CTYPE[ty.name]) return PRIM_CTYPE[ty.name];
        return ty.name;
      }
      case 'array': {
        return this.cType(ty.child); // arrays handled specially in declarations
      }
      case 'ptr': {
        const inner = this.cType(ty.child);
        const cst = ty.isConst ? 'const ' : '';
        return `${cst}${inner}*`;
      }
      case 'optional': {
        // A pointer or slice payload is represented by a nullable pointer.
        // Anything else gets a tagged { value; has; } struct.
        if (ty.child.k === 'ptr') return this.cType(ty.child);
        if (ty.child.k === 'slice') return this.cType(ty.child);
        return this.optName(ty.child);
      }
      case 'slice': return this.sliceName(ty);
      case 'fn': return 'void*';
      default: throw new Error('unsupported type ' + ty.k);
    }
  }

  sliceName(ty) {
    const base = this.mangle(ty.child);
    const name = `zig_slice_${ty.isConst ? 'c_' : ''}${base}`;
    if (!this.sliceTypes.has(name)) this.sliceTypes.set(name, { child: ty.child, isConst: ty.isConst });
    return name;
  }

  mangle(ty) {
    switch (ty.k) {
      case 'prim': return ty.name;
      case 'named': return ty.name.replace(/[^A-Za-z0-9_]/g, '_');
      case 'ptr': return (ty.isConst ? 'c_' : '') + 'p_' + this.mangle(ty.child);
      case 'slice': return (ty.isConst ? 'c_' : '') + 's_' + this.mangle(ty.child);
      case 'optional': return 'o_' + this.mangle(ty.child);
      case 'array': return 'a_' + this.mangle(ty.child);
      default: return 'x';
    }
  }

  /* ---------- symbol table ---------- */
  pushScope() { this.scopes.push(new Map()); }
  popScope() { this.scopes.pop(); }
  declare(name, ty) { this.scopes[this.scopes.length - 1].set(name, ty); }
  lookup(name) {
    for (let i = this.scopes.length - 1; i >= 0; i--) {
      if (this.scopes[i].has(name)) return this.scopes[i].get(name);
    }
    if (this.topConsts.has(name)) {
      const c = this.topConsts.get(name);
      return this.normalizeArrayLen(c.typeAnn || this.exprType(c.init), c.init);
    }
    return null;
  }

  /* ---------- type inference ---------- */
  exprType(e) {
    if (!e) return null;
    switch (e.k) {
      case 'int': return prim('i32');
      case 'float': return prim('f64');
      case 'bool': return prim('bool');
      case 'char': return prim('u8');
      case 'str': return slice(prim('u8'), { isConst: true });
      case 'null': return optional(ptr(prim('void'), { ptrKind: 'single' }));
      case 'ident': return this.lookup(e.name);
      case 'addr': { const t = this.exprType(e.obj); return t ? ptr(t, { ptrKind: 'single' }) : null; }
      case 'deref': { const t = this.exprType(e.obj); if (!t) return null; if (t.k === 'ptr') return t.child; if (t.k === 'optional' && t.child.k === 'ptr') return t.child.child; return null; }
      case 'unwrap': { const t = this.exprType(e.obj); if (!t) return null; if (t.k === 'optional') return t.child; return t; }
      case 'index': { const t = this.exprType(e.obj); if (!t) return null; if (t.k === 'slice') return t.child; if (t.k === 'ptr') return t.child; if (t.k === 'array') return t.child; return null; }
      case 'slicex': { const t = this.exprType(e.obj); if (!t) return null; if (t.k === 'slice') return slice(t.child, { isConst: t.isConst }); if (t.k === 'ptr') return slice(t.child, { isConst: t.isConst }); if (t.k === 'array') return slice(t.child, { isConst: !!t.childConst }); return null; }
      case 'field': {
        const t = this.exprType(e.obj);
        if (!t) return null;
        const li = this.listInfo(t);
        if (li && e.name === 'items') return slice(li.elemTy, {});
        const mi = this.mapInfo(t);
        if (mi && e.name === 'count') return prim('usize');
        if (e.name === 'empty') { const ctc = this.containerTypeOfTypeCall(e.obj); if (ctc) return ctc; }
        if (e.name === 'len') {
          if (t.k === 'slice' || t.k === 'array' || t.k === 'ptr') return prim('usize');
          return null;
        }
        let st = t;
        if (st.k === 'ptr') st = st.child;
        if (st.k === 'optional') st = st.child.k === 'ptr' ? st.child.child : st.child;
        if (st.k === 'named') {
          const fs = this.structFields(st.name);
          if (fs) { const f = fs.find((x) => x.name === e.name); if (f) return f.ty; }
        }
        return null;
      }
      case 'call': {
        const ctc = this.containerTypeOfTypeCall(e);
        if (ctc) return ctc;
        if (e.callee.k === 'ident' && this.functions.has(e.callee.name)) return this.functions.get(e.callee.name).ret;
        if (e.callee.k === 'builtin') return this.builtinType(e);
        if (e.callee.k === 'field') {
          const mt = this.methodType(this.exprType(e.callee.obj), e.callee.name, e.args);
          if (mt !== undefined) return mt;
        }
        const path = this.dottedPath(e.callee);
        if (path) { const st = this.stdCallType(path, e.args); if (st) return st; }
        if (e.callee.k === 'field') {
          const m = e.callee.name;
          if ((m === 'alloc' || m === 'allocSentinel') && e.args[0] && e.args[0].ty) return slice(e.args[0].ty, {});
          if (m === 'dupe' && e.args[0] && e.args[0].ty) return slice(e.args[0].ty, {});
          if (m === 'create' && e.args[0] && e.args[0].ty) return ptr(e.args[0].ty, { ptrKind: 'single' });
        }
        return null;
      }
      case 'builtin': return this.builtinType(e);
      case 'structinit': return e.ty;
      case 'arrayinit': return e.ty;
      case 'ifexpr': return this.exprType(e.then.k === 'block' ? e.then.stmts[e.then.stmts.length - 1].value : e.then) || this.exprType(e.else);
      case 'binop': {
        if (e.op === '..' || e.op === '..<') return null;
        if (e.op === 'orelse' || e.op === 'catch') { const t = this.exprType(e.l); if (t && t.k === 'optional') return t.child; return t; }
        const lt = this.exprType(e.l), rt = this.exprType(e.r);
        return lt || rt;
      }
      case 'unop': return this.exprType(e.e);
      case 'assignexpr': return this.exprType(e.lhs);
      case 'exprseq': return this.exprType(e.lhs);
      case 'type': throw new Error('a type was used where a value is required');
      case 'enumlit': return null;
      case 'optprefix': return optional(this.exprType(e.obj) || prim('i32'));
      default: return null;
    }
  }

  methodType(rt, m, args) {
    if (rt && rt.k === 'named' && this.iterTypes.has(rt.name)) {
      const it = this.iterTypes.get(rt.name);
      if (m === 'next') return optional(ptr(it.elemTy, { ptrKind: 'single' }));
      return undefined;
    }
    const li = this.listInfo(rt);
    if (li) {
      switch (m) {
        case 'items': case 'toOwnedSlice': return slice(li.elemTy, {});
        case 'getLast': return li.elemTy;
        case 'pop': return optional(li.elemTy);
        case 'len': return prim('usize');
        case 'append': case 'appendSlice': case 'deinit': case 'clearRetainingCapacity':
        case 'clearAndFree': case 'ensureTotalCapacity': case 'orderedRemove':
        case 'swapRemove': case 'insert': return prim('void');
        default: return undefined;
      }
    }
    const mi = this.mapInfo(rt);
    if (mi) {
      switch (m) {
        case 'init': return rt;
        case 'get': return optional(mi.valTy);
        case 'getOrPut': return named(`${mi.name}_GOP`);
        case 'put': case 'deinit': return prim('void');
        case 'contains': case 'remove': case 'containsAdapted': return prim('bool');
        case 'count': case 'size': return prim('usize');
        case 'iterator': return named(this.iterName(mi, 'entry'));
        case 'keyIterator': return named(this.iterName(mi, 'key'));
        case 'valueIterator': return named(this.iterName(mi, 'value'));
        default: return undefined;
      }
    }
    return undefined;
  }

  dottedPath(e) {
    // returns "std.sort.pdq" for a chained field access rooted at an identifier, else null
    const parts = [];
    let cur = e;
    while (cur && cur.k === 'field') { parts.unshift(cur.name); cur = cur.obj; }
    if (!cur || cur.k !== 'ident') return null;
    parts.unshift(cur.name);
    return parts.join('.');
  }

  stdCallType(path, args) {
    if (path === 'std.mem.eql' || path === 'std.mem.startsWith' || path === 'std.mem.endsWith'
      || path === 'std.mem.containsAtLeast' || path === 'std.ascii.isAlphanumeric'
      || path === 'std.ascii.isAlphabetic' || path === 'std.ascii.isDigit'
      || path === 'std.ascii.isUpper' || path === 'std.ascii.isLower'
      || path === 'std.ascii.isWhitespace') return prim('bool');
    if (path === 'std.mem.indexOf' || path === 'std.mem.indexOfScalar'
      || path === 'std.mem.lastIndexOf' || path === 'std.mem.lastIndexOfScalar') return prim('usize');
    if (path === 'std.mem.sliceTo' || path === 'std.mem.span') {
      const t = args && args[0] ? this.exprType(args[0]) : null;
      const elem = t && t.k === 'ptr' ? t.child : prim('u8');
      const isC = t && t.k === 'ptr' ? t.isConst : true;
      return slice(elem, { isConst: isC });
    }
    if (path === 'std.mem.len') return prim('usize');
    if (path === 'std.ascii.toLower' || path === 'std.ascii.toUpper') return prim('u8');
    if (path === 'std.math.absInt' || path === 'std.math.max' || path === 'std.math.min') return args && args[0] ? this.exprType(args[0]) : prim('i32');
    if (path.startsWith('std.sort.') || path === 'std.mem.sort' || path === 'std.mem.reverse' || path === 'std.mem.copyForwards' || path === 'std.mem.copyBackwards' || path === 'std.mem.swap') return prim('void');
    if (path === 'std.debug.print') return prim('void');
    return null;
  }

  builtinType(e) {
    const n = e.name;
    if (n === '@as') return this.tyFromTypeExpr(e.args[0]);
    if (n === '@intCast') return null;
    if (n === '@intFromEnum' || n === '@enumFromInt') return prim('i32');
    if (n === '@sizeOf' || n === '@bitSizeOf' || n === '@intFromPtr') return prim('usize');
    if (n === '@min' || n === '@max') return this.exprType(e.args[0]);
    if (n === '@abs') return this.exprType(e.args[0]);
    if (n === '@sqrt') return prim('f64');
    return null;
  }

  tyFromTypeExpr(e) { return e.ty || null; }

  collectCallees(node, out) {
    // Collects every identifier mentioned in the body. Intersecting this with
    // the set of known function names gives a safe over-approximation of the
    // call graph (it also catches functions passed as values, e.g. comparators).
    out = out || new Set();
    if (!node || typeof node !== 'object') return out;
    if (Array.isArray(node)) { for (const x of node) this.collectCallees(x, out); return out; }
    if (node.k === 'ident') out.add(node.name);
    for (const key of Object.keys(node)) {
      if (key === 'ty') continue;
      this.collectCallees(node[key], out);
    }
    return out;
  }

  /* ---------- entry ---------- */
  emit() {
    this.prescan();
    // Only translate what LeetCode can actually reach: the pub/export entry
    // points and everything they call. Test-only helpers are not emitted.
    const roots = new Set();
    for (const it of this.items) if (it.k === 'fn' && it.body && it.isPub) roots.add(it.name);
    if (roots.size === 0) for (const it of this.items) if (it.k === 'fn' && it.body) roots.add(it.name);
    this.reachable = new Set();
    const queue = [...roots];
    while (queue.length) {
      const n = queue.shift();
      if (this.reachable.has(n)) continue;
      this.reachable.add(n);
      const fnItem = this.items.find((it) => it.k === 'fn' && it.name === n);
      if (!fnItem || !fnItem.body) continue;
      for (const c of this.collectCallees(fnItem.body)) {
        if (this.functions.has(c) && !this.reachable.has(c)) queue.push(c);
      }
    }

    for (const it of this.items) {
      if (it.k === 'toplevel_const') this.emitTopConst(it);
    }
    for (const it of this.items) {
      if (it.k === 'fn' && this.reachable.has(it.name)) this.emitFunction(it);
    }
    return this.assemble();
  }

  referencesStd(e) {
    if (!e) return false;
    if (e.k === 'ident') return e.name === 'std';
    if (e.k === 'field') return this.referencesStd(e.obj);
    if (e.k === 'call') return this.referencesStd(e.callee) || (e.args || []).some((a) => this.referencesStd(a));
    if (e.k === 'builtin') return (e.args || []).some((a) => this.referencesStd(a));
    return false;
  }

  emitTopConst(it) {
    // skip imports / type aliases / std aliases
    if (it.init.k === 'builtin' && it.init.name === '@import') return;
    if (this.referencesStd(it.init)) return;
    if (it.init.k === 'ident' && this.structs.has(it.init.name)) return;
    if (it.init.k === 'ident' && PRIM_CTYPE[it.init.name]) return;
    let t = it.typeAnn || this.exprType(it.init) || prim('i32');
    t = this.normalizeArrayLen(t, it.init);
    this.pushScope();
    const intPrimNames = ['i8', 'i16', 'i32', 'i64', 'u8', 'u16', 'u32', 'u64', 'usize', 'isize', 'c_int', 'c_uint'];
    const intPrim = t.k === 'prim' && intPrimNames.includes(t.name);
    const litVal = it.init.k === 'int' ? it.init.v : (it.init.k === 'unop' && it.init.op === '-' && it.init.e.k === 'int' ? `-${it.init.e.v}` : null);
    if (it.isConst && intPrim && litVal !== null && Math.abs(parseInt(litVal, 10)) <= 2147483647) {
      // enum constant: usable as a C array bound (a `static const int` is not)
      this.enumConsts.push(`enum { ${it.name} = ${litVal} };`);
      this.popScope();
      return;
    }
    if (it.init.k === 'arrayinit') {
      const cty = this.cType(t.k === 'array' ? t.child : t);
      const n = it.init.elems.length;
      this.constLines.push(`static const ${cty} ${it.name}[${n}] = {${it.init.elems.map((x) => this.expr(x, t.k === 'array' ? t.child : t)).join(', ')}};`);
    } else if (it.isConst) {
      this.constLines.push(`static const ${this.cType(t)} ${it.name} = ${this.expr(it.init, t)};`);
    } else {
      this.constLines.push(`static ${this.cType(t)} ${it.name} = ${this.expr(it.init, t)};`);
    }
    this.popScope();
  }

  emitFunction(fn) {
    this.pushScope();
    const params = [];
    for (const p of fn.params) {
      // Drop `_: void` style context parameters (used by std.sort comparators);
      // they have no C equivalent.
      if (p.ty && (p.ty.k === 'prim' || p.ty.k === 'named') && p.ty.name === 'void') continue;
      const ct = this.cType(p.ty);
      params.push(`${ct} ${p.name}`);
      this.declare(p.name, p.ty);
    }
    let retC = this.cType(fn.ret);
    if (fn.ret.k === 'array') retC = this.cType(fn.ret.child);
    const sig = `${retC} ${fn.name}(${params.join(', ')})`;
    this.funcDefs = this.funcDefs || [];
    if (!fn.body) {
      // extern declaration (e.g. a judge-provided function): prototype only
      this.funcDefs.push({ sig, body: null, comments: fn.comments || [] });
      return;
    }
    const savedBody = this.body;
    this.body = [];
    this.scopes = [this.scopes[0]]; // reset to function scope
    this.currentFn = fn;
    const lines = [];
    this.emitBlockInto(lines, fn.body, 1);
    const bodyText = lines.join('\n');
    this.body = savedBody;
    this.popScope();
    this.funcDefs.push({ sig, body: bodyText, comments: fn.comments || [] });
  }

  /* ---------- prelude / assembly ---------- */
  helper(name) { this.helpers.add(name); }

  assemble() {
    const out = [];
    out.push('/* ------------------------------------------------------------------');
    out.push(' * Generated by zig2c from Zig source. Do not edit by hand.');
    out.push(' * Deterministic translation: re-run zig2c to regenerate.');
    out.push(' * ------------------------------------------------------------------ */');
    out.push('');
    out.push('#include <stdio.h>');
    out.push('#include <stdlib.h>');
    out.push('#include <string.h>');
    out.push('#include <stdbool.h>');
    out.push('#include <stdint.h>');
    out.push('#include <limits.h>');
    out.push('');

    if (this.enumConsts.length) { out.push(...this.enumConsts); out.push(''); }

    const helperText = this.renderHelpers();
    if (helperText) out.push(helperText);

    // struct forward declarations
    for (const name of this.structs.keys()) out.push(`typedef struct ${name} ${name};`);
    if (this.structs.size) out.push('');

    // Make sure every container's component types (slices, optionals) are
    // registered before the typedefs are printed.
    for (let pass = 0; pass < 3; pass++) {
      for (const [, i] of this.listTypes) { this.cType(i.elemTy); this.cType(slice(i.elemTy, {})); this.optName(i.elemTy); }
      for (const [, i] of this.mapTypes) { this.cType(i.keyTy); this.cType(i.valTy); if (i.valTy.k !== 'ptr') this.optName(i.valTy); }
      for (const [, i] of this.optTypes) this.cType(i.childTy);
    }

    // slice typedefs
    for (const [name, info] of this.sliceTypes) {
      const cst = info.isConst ? 'const ' : '';
      out.push(`typedef struct { ${cst}${this.cType(info.child)} *ptr; size_t len; } ${name};`);
    }
    if (this.sliceTypes.size) out.push('');

    // optional-value typedefs (for ?T where T is not a pointer)
    for (const [name, info] of this.optTypes) out.push(`typedef struct { ${this.cType(info.childTy)} value; bool has; } ${name};`);
    if (this.optTypes.size) out.push('');

    // ArrayList typedefs (only a forward struct decl is needed for `data`)
    for (const [name, info] of this.listTypes) {
      out.push(`typedef struct { ${this.cType(info.elemTy)} *data; size_t len; size_t cap; } ${name};`);
    }
    if (this.listTypes.size) out.push('');

    // HashMap typedefs (before struct bodies so a struct may hold a map field;
    // key/value must be scalar or pointer types, not structs-by-value)
    for (const [name, info] of this.mapTypes) {
      const kt = this.cType(info.keyTy), vt = this.cType(info.valTy);
      out.push(`typedef struct { bool used; ${kt} key; ${vt} value; } ${name}_Entry;`);
      out.push(`typedef struct { ${name}_Entry *entries; size_t cap; size_t count; } ${name};`);
      out.push(`typedef struct { bool found_existing; ${kt} *key_ptr; ${vt} *value_ptr; } ${name}_GOP;`);
      out.push(`typedef struct { ${kt} *key_ptr; ${vt} *value_ptr; } ${name}_EntryRef;`);
      out.push(`typedef struct { ${name} *m; size_t i; ${name}_EntryRef ref; } ${name}_Iter;`);
      out.push(`typedef struct { ${name} *m; size_t i; } ${name}_KeyIter;`);
      out.push(`typedef struct { ${name} *m; size_t i; } ${name}_ValIter;`);
    }
    if (this.mapTypes.size) out.push('');

    // struct bodies
    for (const [name, fields] of this.structs) {
      const fl = fields.map((f) => {
        if (f.ty.k === 'array') {
          const lenStr = f.ty.len && f.ty.len.k === 'int' ? f.ty.len.v : (f.ty.len ? this.expr(f.ty.len, prim('usize')) : '0');
          return `${this.cType(f.ty.child)} ${f.name}[${lenStr}];`;
        }
        const ct = this.cType(f.ty);
        if (f.ty.k === 'optional' && f.ty.child.k === 'named' && this.structs.has(f.ty.child.name)) {
          return `struct ${f.ty.child.name}* ${f.name};`;
        }
        return `${ct} ${f.name};`;
      });
      const isProvided = this.providedStructs.has(name);
      if (isProvided) {
        out.push(`/* struct ${name} is defined by the LeetCode harness; local builds use ZIG2C_LOCAL */`);
        out.push('#ifdef ZIG2C_LOCAL');
      }
      out.push(`struct ${name} {`);
      for (const l of fl) out.push('    ' + l);
      out.push('};');
      if (isProvided) out.push('#endif');
    }
    if (this.structs.size) out.push('');

    // HashMap typedefs moved above struct bodies

    // container helper implementations
    const cf = this.renderContainerFuncs();
    if (cf) out.push(cf);

    if (this.constLines.length) { out.push(...this.constLines); out.push(''); }

    // function prototypes
    for (const f of this.funcDefs) {
      const proto = f.sig.replace(/\s*$/, '') + ';';
      out.push(proto);
    }
    if (this.funcDefs.length) out.push('');

    // comparator wrappers (reference comparator functions, so come after prototypes)
    for (const w of this.cmpWrappers) out.push(w);
    if (this.cmpWrappers.length) out.push('');

    for (const f of this.funcDefs) {
      if (f.body === null) continue;
      for (const c of f.comments) out.push(c);
      out.push(f.sig + ' {');
      out.push(f.body);
      out.push('}');
      out.push('');
    }
    return out.join('\n');
  }

  renderContainerFuncs() {
    const out = [];
    for (const [n, info] of this.listTypes) {
      const ct = this.cType(info.elemTy);
      const sn = this.cType(slice(info.elemTy, {}));
      const on = this.optName(info.elemTy);
      out.push(`static inline void ${n}_reserve(${n} *l, size_t need) { if (l->cap >= need) return; size_t nc = l->cap ? l->cap * 2 : 8; if (nc < need) nc = need; l->data = (${ct}*)realloc(l->data, nc * sizeof(${ct})); l->cap = nc; }`);
      out.push(`static inline void ${n}_append(${n} *l, ${ct} item) { ${n}_reserve(l, l->len + 1); l->data[l->len++] = item; }`);
      out.push(`static inline void ${n}_appendSlice(${n} *l, const ${ct} *items, size_t n) { ${n}_reserve(l, l->len + n); if (n) memcpy(l->data + l->len, items, n * sizeof(${ct})); l->len += n; }`);
      out.push(`static inline void ${n}_insert(${n} *l, size_t i, ${ct} item) { ${n}_reserve(l, l->len + 1); if (l->len > i) memmove(l->data + i + 1, l->data + i, (l->len - i) * sizeof(${ct})); l->data[i] = item; l->len++; }`);
      out.push(`static inline void ${n}_orderedRemove(${n} *l, size_t i) { if (l->len > i + 1) memmove(l->data + i, l->data + i + 1, (l->len - i - 1) * sizeof(${ct})); l->len--; }`);
      out.push(`static inline void ${n}_swapRemove(${n} *l, size_t i) { l->data[i] = l->data[--l->len]; }`);
      out.push(`static inline void ${n}_clear(${n} *l) { l->len = 0; }`);
      out.push(`static inline void ${n}_deinit(${n} *l) { free(l->data); l->data = NULL; l->len = 0; l->cap = 0; }`);
      out.push(`static inline ${sn} ${n}_toOwnedSlice(${n} *l) { ${sn} s; s.ptr = l->data; s.len = l->len; l->data = NULL; l->len = 0; l->cap = 0; return s; }`);
      out.push(`static inline ${on} ${n}_pop(${n} *l) { ${on} r; r.has = l->len > 0; memset(&r.value, 0, sizeof(${ct})); if (r.has) r.value = l->data[--l->len]; return r; }`);
      out.push(`static inline ${on} ${n}_getLast(${n} *l) { ${on} r; r.has = l->len > 0; memset(&r.value, 0, sizeof(${ct})); if (r.has) r.value = l->data[l->len - 1]; return r; }`);
    }
    for (const [n, info] of this.mapTypes) {
      const kt = this.cType(info.keyTy), vt = this.cType(info.valTy);
      const valIsPtr = info.valTy.k === 'ptr';
      const ov = valIsPtr ? null : this.optName(info.valTy);
      const isStr = info.keyKind === 'str';
      if (isStr) {
        out.push(`static inline size_t ${n}_hash(${kt} key) { size_t h = 1469598103934665603ull; for (size_t i = 0; i < key.len; i++) { h ^= (unsigned char)key.ptr[i]; h *= 1099511628211ull; } return h; }`);
        out.push(`static inline bool ${n}_keq(${kt} a, ${kt} b) { return a.len == b.len && (a.len == 0 || memcmp(a.ptr, b.ptr, a.len) == 0); }`);
      } else {
        out.push(`static inline size_t ${n}_hash(${kt} key) { return (size_t)key * (size_t)2654435761u; }`);
      }
      const eqExpr = isStr ? `${n}_keq(m->entries[i].key, key)` : `m->entries[i].key == key`;
      out.push(`static inline size_t ${n}_slot(${n} *m, ${kt} key, bool *found) { if (m->cap == 0) { *found = false; return 0; } size_t mask = m->cap - 1; size_t i = ${n}_hash(key) & mask; for (;;) { if (!m->entries[i].used) { *found = false; return i; } if (${eqExpr}) { *found = true; return i; } i = (i + 1) & mask; } }`);
      out.push(`static inline ${n} ${n}_init(void) { ${n} m; memset(&m, 0, sizeof(m)); return m; }`);
      out.push(`static inline void ${n}_grow(${n} *m) { size_t nc = m->cap ? m->cap * 2 : 8; ${n}_Entry *e = (${n}_Entry*)calloc(nc, sizeof(${n}_Entry)); ${n}_Entry *old = m->entries; size_t oc = m->cap; m->entries = e; m->cap = nc; m->count = 0; for (size_t i = 0; i < oc; i++) if (old[i].used) { bool f; size_t s = ${n}_slot(m, old[i].key, &f); m->entries[s] = old[i]; m->count++; } free(old); }`);
      out.push(`static inline void ${n}_put(${n} *m, ${kt} key, ${vt} value) { bool f; size_t s = ${n}_slot(m, key, &f); if (!f && (m->count + 1) * 4 >= m->cap * 3 + 4) { ${n}_grow(m); s = ${n}_slot(m, key, &f); } if (!f) { m->entries[s].used = true; m->entries[s].key = key; m->count++; } m->entries[s].value = value; }`);
      out.push(`static inline ${n}_GOP ${n}_getOrPut(${n} *m, ${kt} key) { bool f; size_t s = ${n}_slot(m, key, &f); if (!f) { if ((m->count + 1) * 4 >= m->cap * 3 + 4) { ${n}_grow(m); s = ${n}_slot(m, key, &f); } m->entries[s].used = true; m->entries[s].key = key; memset(&m->entries[s].value, 0, sizeof(${vt})); m->count++; } ${n}_GOP g; g.found_existing = f; g.key_ptr = &m->entries[s].key; g.value_ptr = &m->entries[s].value; return g; }`);
      out.push(valIsPtr
        ? `static inline ${vt} ${n}_get(${n} *m, ${kt} key) { bool f; size_t s = ${n}_slot(m, key, &f); return f ? m->entries[s].value : NULL; }`
        : `static inline ${ov} ${n}_get(${n} *m, ${kt} key) { bool f; size_t s = ${n}_slot(m, key, &f); ${ov} r; r.has = f; memset(&r.value, 0, sizeof(${vt})); if (f) r.value = m->entries[s].value; return r; }`);
      out.push(`static inline bool ${n}_contains(${n} *m, ${kt} key) { bool f; ${n}_slot(m, key, &f); return f; }`);
      out.push(`static inline size_t ${n}_count(const ${n} *m) { return m->count; }`);
      out.push(`static inline void ${n}_deinit(${n} *m) { free(m->entries); m->entries = NULL; m->cap = 0; m->count = 0; }`);
      out.push(`static inline bool ${n}_remove(${n} *m, ${kt} key) { bool f; size_t s = ${n}_slot(m, key, &f); if (!f) return false; m->entries[s].used = false; m->count--; size_t mask = m->cap - 1; size_t i = (s + 1) & mask; while (m->entries[i].used) { ${n}_Entry e = m->entries[i]; m->entries[i].used = false; m->count--; ${n}_put(m, e.key, e.value); i = (i + 1) & mask; } return true; }`);
      out.push(`static inline ${n}_Iter ${n}_iter(${n} *m) { ${n}_Iter it; it.m = m; it.i = 0; return it; }`);
      out.push(`static inline ${n}_EntryRef *${n}_iter_next(${n}_Iter *it) { while (it->i < it->m->cap) { size_t j = it->i++; if (it->m->entries[j].used) { it->ref.key_ptr = &it->m->entries[j].key; it->ref.value_ptr = &it->m->entries[j].value; return &it->ref; } } return NULL; }`);
      out.push(`static inline ${n}_KeyIter ${n}_key_iter(${n} *m) { ${n}_KeyIter it; it.m = m; it.i = 0; return it; }`);
      out.push(`static inline ${kt} *${n}_key_next(${n}_KeyIter *it) { while (it->i < it->m->cap) { size_t j = it->i++; if (it->m->entries[j].used) return &it->m->entries[j].key; } return NULL; }`);
      out.push(`static inline ${n}_ValIter ${n}_val_iter(${n} *m) { ${n}_ValIter it; it.m = m; it.i = 0; return it; }`);
      out.push(`static inline ${vt} *${n}_val_next(${n}_ValIter *it) { while (it->i < it->m->cap) { size_t j = it->i++; if (it->m->entries[j].used) return &it->m->entries[j].value; } return NULL; }`);
    }
    if (!out.length) return '';
    return out.join('\n') + '\n';
  }

  renderHelpers() {
    const h = [];
    if (this.helpers.has('min')) h.push('#define zig_min(a, b) ((a) < (b) ? (a) : (b))');
    if (this.helpers.has('max')) h.push('#define zig_max(a, b) ((a) > (b) ? (a) : (b))');
    if (this.helpers.has('abs')) h.push('#define zig_abs(a) ((a) < 0 ? -(a) : (a))');
    if (this.helpers.has('memeql')) h.push('static inline bool zig_mem_eql(const void *a, size_t alen, const void *b, size_t blen) { return alen == blen && (alen == 0 || memcmp(a, b, alen) == 0); }');
    if (this.helpers.has('isalpha')) h.push('static inline bool zig_is_alpha(int c) { return (c >= \'a\' && c <= \'z\') || (c >= \'A\' && c <= \'Z\') || c == \'_\'; }');
    if (this.helpers.has('isdigit')) h.push('static inline bool zig_is_digit(int c) { return c >= \'0\' && c <= \'9\'; }');
    if (this.helpers.has('isalnum')) h.push('static inline bool zig_is_alnum(int c) { return zig_is_alpha(c) || zig_is_digit(c); }');
    if (this.helpers.has('isspace')) h.push('static inline bool zig_is_space(int c) { return c == \' \' || c == \'\\t\' || c == \'\\n\' || c == \'\\r\' || c == \'\\v\' || c == \'\\f\'; }');
    if (this.helpers.has('tolower')) h.push('static inline int zig_to_lower(int c) { return (c >= \'A\' && c <= \'Z\') ? c + 32 : c; }');
    if (this.helpers.has('toupper')) h.push('static inline int zig_to_upper(int c) { return (c >= \'a\' && c <= \'z\') ? c - 32 : c; }');
    if (this.helpers.has('swap')) h.push('#define zig_swap(T, a, b) do { T zig__tmp = (a); (a) = (b); (b) = zig__tmp; } while (0)');
    if (this.helpers.has('reverse')) h.push('#define zig_reverse(T, ptr, len) do { for (size_t zig__i = 0; zig__i < (len) / 2; zig__i++) { T zig__t = (ptr)[zig__i]; (ptr)[zig__i] = (ptr)[(len) - 1 - zig__i]; (ptr)[(len) - 1 - zig__i] = zig__t; } } while (0)');
    if (this.helpers.has('divfloor')) h.push('static inline long long zig_div_floor(long long a, long long b) { long long q = a / b; if ((a % b != 0) && ((a < 0) != (b < 0))) q--; return q; }');
    if (this.helpers.has('mod')) h.push('static inline long long zig_mod(long long a, long long b) { long long r = a % b; if (r != 0 && ((r < 0) != (b < 0))) r += b; return r; }');
    if (this.helpers.has('memset')) h.push('/* memset from <string.h> */');
    return h.length ? h.join('\n') + '\n' : '';
  }

  /* ---------- statements ---------- */
  ind(n) { return '    '.repeat(n); }

  emitBlockInto(lines, block, indent) {
    this.pushScope();
    for (const s of block.stmts) this.emitStmtInto(lines, s, indent);
    if (!this.blockEndsTerminated(block)) this.popScopeEmitting(lines, indent);
    else this.popScope();
  }

  blockEndsTerminated(block) {
    if (!block || !block.stmts || !block.stmts.length) return false;
    const last = block.stmts[block.stmts.length - 1];
    return last.k === 'return' || last.k === 'break' || last.k === 'continue';
  }

  popScopeEmitting(lines, indent) {
    const sc = this.scopes[this.scopes.length - 1];
    const d = sc && sc.__defers;
    if (d) for (let j = d.length - 1; j >= 0; j--) lines.push(`${this.ind(indent)}${d[j]}`);
    this.popScope();
  }

  emitStmtInto(lines, s, indent) {
    const pad = this.ind(indent);
    switch (s.k) {
      case 'var': return this.emitVarInto(lines, s, indent);
      case 'assign': return this.emitAssignInto(lines, s, indent);
      case 'expr': {
        if (s.expr.k === 'ident' && s.expr.name === '_') return;
        lines.push(`${pad}${this.expr(s.expr, null)};`);
        return;
      }
      case 'if': return this.emitIfInto(lines, s, indent);
      case 'while': return this.emitWhileInto(lines, s, indent);
      case 'for': return this.emitForInto(lines, s, indent);
      case 'switch': return this.emitSwitchInto(lines, s, indent);
      case 'return': {
        const f = this.currentFn;
        const defers = this.defersForReturn();
        const rt = f ? f.ret : null;
        if (!s.value) {
          for (const sc of defers) lines.push(`${this.ind(indent)}${sc}`);
          lines.push(`${pad}return;`);
          return;
        }
        if (defers.length === 0) {
          lines.push(`${pad}return ${this.expr(s.value, rt)};`);
          return;
        }
        // Zig evaluates the return expression, then runs defers. Materialise the
        // result first so a `defer free(buf)` cannot free it out from under us.
        const tmp = `zig__ret${this.tmpCount++}`;
        const cty = rt ? this.cType(rt) : 'int';
        lines.push(`${pad}${cty} ${tmp} = ${this.expr(s.value, rt)};`);
        for (const sc of defers) lines.push(`${this.ind(indent)}${sc}`);
        lines.push(`${pad}return ${tmp};`);
        return;
      }
      case 'break': lines.push(`${pad}break;`); return;
      case 'continue': {
        for (const sc of this.defersForContinue()) lines.push(`${this.ind(indent)}${sc}`);
        const loop = this.loops[this.loops.length - 1];
        if (loop && loop.cont) lines.push(`${pad}${loop.cont};`);
        lines.push(`${pad}continue;`);
        return;
      }
      case 'defer': {
        this.scopes[this.scopes.length - 1].__defers = this.scopes[this.scopes.length - 1].__defers || [];
        this.scopes[this.scopes.length - 1].__defers.push(this.exprStatementText(s.expr));
        return;
      }
      case 'block': {
        // nested bare block
        this.pushScope();
        for (const st of s.stmts) this.emitStmtInto(lines, st, indent);
        if (!this.blockEndsTerminated(s)) this.popScopeEmitting(lines, indent);
        else this.popScope();
        return;
      }
      case 'test': return;
      default: throw new Error('unsupported statement ' + s.k);
    }
  }

  exprStatementText(e) {
    if (e.k === 'call' || e.k === 'builtin') return this.expr(e, null) + ';';
    if (e.k === 'binop' && e.op === 'catch') return this.expr(e.l, null) + ';';
    return this.expr(e, null) + ';';
  }

  defersForReturn() {
    const out = [];
    for (let i = this.scopes.length - 1; i >= 1; i--) {
      const d = this.scopes[i].__defers;
      if (d) for (let j = d.length - 1; j >= 0; j--) out.push(d[j]);
    }
    return out;
  }

  defersForContinue() {
    const out = [];
    const loop = this.loops[this.loops.length - 1];
    if (!loop) return out;
    for (let i = this.scopes.length - 1; i >= loop.markerScope; i--) {
      const d = this.scopes[i] && this.scopes[i].__defers;
      if (d) for (let j = d.length - 1; j >= 0; j--) out.push(d[j]);
    }
    return out;
  }

  emitVarInto(lines, s, indent) {
    const pad = this.ind(indent);
    if (s.names.length > 1) {
      // tuple destructuring: emit temporaries then assign
      const tmps = s.inits.map(() => `zig_tmp_${this.tmpCount++}`);
      const tys = s.inits.map((init, i) => this.resolveDeclType(s.typeAnn, init));
      s.inits.forEach((init, i) => {
        lines.push(`${pad}${this.cType(tys[i])} ${tmps[i]} = ${this.expr(init, tys[i])};`);
      });
      s.names.forEach((nm, i) => {
        const t = tys[i];
        this.pushScope();
        this.declare(nm, t);
        this.popScope();
        lines.push(`${pad}${this.cType(t)} ${nm} = ${tmps[i]};`);
        this.declare(nm, t);
      });
      return;
    }
    const name = s.names[0];
    const init = s.inits[0];
    const ty = this.resolveDeclType(s.typeAnn, init);
    this.declare(name, ty);
    if ((this.listInfo(ty) || this.mapInfo(ty)) && (init.k === 'undefined' || this.isEmptyInit(init))) {
      lines.push(`${pad}${this.cType(ty)} ${name} = {0};`);
      return;
    }
    if (init.k === 'arrayinit') {
      const elemT = ty.k === 'array' ? ty.child : this.exprType(init)?.child || prim('i32');
      const cty = this.cType(elemT);
      const n = init.elems.length;
      const items = init.elems.map((x) => this.expr(x, elemT)).join(', ');
      lines.push(`${pad}${cty} ${name}[${n}] = {${items}};`);
      return;
    }
    if (init.k === 'undefined') {
      if (ty.k === 'array') {
        const len = ty.len ? this.expr(ty.len, prim('usize')) : '0';
        lines.push(`${pad}${this.cType(ty.child)} ${name}[${len}];`);
      } else {
        lines.push(`${pad}${this.cType(ty)} ${name};`);
      }
      return;
    }
    lines.push(`${pad}${this.cType(ty)} ${name} = ${this.expr(init, ty)};`);
  }

  normalizeArrayLen(t, init) {
    if (t && t.k === 'array' && init && init.k === 'arrayinit' && !(t.len && t.len.k === 'int')) {
      return array(t.child, { k: 'int', v: String(init.elems.length) });
    }
    return t;
  }

  resolveDeclType(typeAnn, init) {
    let t = typeAnn || this.exprType(init);
    if (!t) t = prim('i32');
    t = this.normalizeArrayLen(t, init);
    if (t.k === 'prim' && t.name === 'comptime_int') return prim('i32');
    return t;
  }

  emitAssignInto(lines, s, indent) {
    const pad = this.ind(indent);
    if (s.lhs.length === 1 && s.lhs[0].k === 'ident' && s.lhs[0].name === '_') {
      lines.push(`${pad}(void)(${this.expr(s.rhs[0], null)});`);
      return;
    }
    if (s.lhs.length === 1 && s.rhs.length === 1) {
      const targetTy = this.lvalueType(s.lhs[0]);
      lines.push(`${pad}${this.lvalue(s.lhs[0])} ${s.op} ${this.expr(s.rhs[0], targetTy)};`);
      return;
    }
    // multi-assignment (e.g. swap): evaluate via temporaries
    const tmps = s.rhs.map(() => `zig_tmp_${this.tmpCount++}`);
    s.rhs.forEach((r, i) => {
      const t = this.exprType(r) || prim('i32');
      lines.push(`${pad}${this.cType(t)} ${tmps[i]} = ${this.expr(r, t)};`);
    });
    s.lhs.forEach((l, i) => { lines.push(`${pad}${this.lvalue(l)} = ${tmps[i]};`); });
  }

  lvalueType(e) {
    if (e.k === 'field' && e.name === 'len') return null;
    if (e.k === 'deref') { const t = this.exprType(e.obj); if (t && t.k === 'optional') return t.child.k === 'ptr' ? t.child.child : null; if (t && t.k === 'ptr') return t.child; }
    return this.exprType(e);
  }

  emitIfInto(lines, s, indent) {
    const pad = this.ind(indent);
    let condC, capDecl = null, capTy = null;
    if (s.capture) {
      const ct = this.exprType(s.cond);
      const isValOpt = ct && ct.k === 'optional' && !this.isPointerish(ct.child);
      const tmp = `zig__c${this.tmpCount++}`;
      if (isValOpt) {
        capTy = ct.child;
        lines.push(`${pad}${this.cType(ct)} ${tmp} = ${this.expr(s.cond, ct)};`);
        condC = `(${tmp}).has`;
        capDecl = `${this.cType(capTy)} ${s.capture} = (${tmp}).value;`;
      } else {
        capTy = this.stripOptional(ct);
        lines.push(`${pad}${this.cType(capTy)} ${tmp} = ${this.expr(s.cond, capTy)};`);
        condC = `${tmp} != NULL`;
        capDecl = `${this.cType(capTy)} ${s.capture} = ${tmp};`;
      }
    } else {
      condC = this.stripOuterParens(this.condText(s.cond, null));
    }
    lines.push(`${pad}if (${condC}) {`);
    this.pushScope();
    if (capDecl) {
      this.declare(s.capture, capTy);
      lines.push(`${this.ind(indent + 1)}${capDecl}`);
    }
    for (const st of s.then.stmts) this.emitStmtInto(lines, st, indent + 1);
    if (!this.blockEndsTerminated(s.then)) this.popScopeEmitting(lines, indent + 1);
    else this.popScope();

    if (!s.else) { lines.push(`${pad}}`); return; }
    if (s.else.k === 'if' && !s.else.capture) {
      const inner = [];
      this.emitIfInto(inner, s.else, indent + 1);
      lines.push(`${pad}} else ${inner[0].trim()}`);
      for (let i = 1; i < inner.length; i++) lines.push(inner[i]);
    } else {
      lines.push(`${pad}} else {`);
      this.pushScope();
      if (s.else.k === 'if') {
        this.emitStmtInto(lines, s.else, indent + 1);
      } else {
        for (const st of s.else.stmts) this.emitStmtInto(lines, st, indent + 1);
      }
      if (s.else.k !== 'if' && !this.blockEndsTerminated(s.else)) this.popScopeEmitting(lines, indent + 1);
      else this.popScope();
      lines.push(`${pad}}`);
    }
  }

  emitWhileInto(lines, s, indent) {
    const pad = this.ind(indent);

    if (s.capture) {
      // Materialise the optional once per iteration:
      //   for (;;) { opt t = cond; if (!t.has) break; T v = t.value; ... }
      const ct = this.exprType(s.cond);
      const isValOpt = ct && ct.k === 'optional' && !this.isPointerish(ct.child);
      const inner = isValOpt ? ct.child : this.stripOptional(ct);
      const tmp = `zig__w${this.tmpCount++}`;
      const contC = s.cont ? this.expr(s.cont, null) : null;
      lines.push(`${pad}for (;;) {`);
      this.pushScope();
      const marker = this.scopes.length - 1;
      this.loops.push({ markerScope: marker, cont: contC });
      this.declare(s.capture, inner);
      lines.push(`${this.ind(indent + 1)}${this.cType(ct)} ${tmp} = ${this.expr(s.cond, ct)};`);
      lines.push(`${this.ind(indent + 1)}if (${isValOpt ? `!(${tmp}).has` : `${tmp} == NULL`}) break;`);
      lines.push(`${this.ind(indent + 1)}${this.cType(inner)} ${s.capture} = ${isValOpt ? `(${tmp}).value` : tmp};`);
      for (const st of s.body.stmts) this.emitStmtInto(lines, st, indent + 1);
      if (!this.blockEndsTerminated(s.body)) this.popScopeEmitting(lines, indent + 1);
      else this.popScope();
      if (contC) lines.push(`${this.ind(indent + 1)}${contC};`);
      this.loops.pop();
      lines.push(`${pad}}`);
      return;
    }

    const condC = this.stripOuterParens(this.expr(s.cond, null));
    const contC2 = s.cont ? this.expr(s.cont, null) : null;
    lines.push(`${pad}while (${condC}) {`);
    this.pushScope();
    const marker = this.scopes.length - 1;
    this.loops.push({ markerScope: marker, cont: contC2 });
    for (const st of s.body.stmts) this.emitStmtInto(lines, st, indent + 1);
    if (!this.blockEndsTerminated(s.body)) this.popScopeEmitting(lines, indent + 1);
    else this.popScope();
    if (contC2) lines.push(`${this.ind(indent + 1)}${contC2};`);
    this.loops.pop();
    lines.push(`${pad}}`);
  }

  emitForInto(lines, s, indent) {
    const pad = this.ind(indent);
    const items = s.items;
    // range loop:  for (a..b) |i|
    if (items.length === 1 && items[0].k === 'binop' && (items[0].op === '..' || items[0].op === '..<')) {
      const r = items[0];
      const iName = s.captures[0] || `zig_i${this.tmpCount++}`;
      const startC = r.l ? this.expr(r.l, prim('usize')) : '0';
      const endC = r.r ? this.expr(r.r, prim('usize')) : null;
      const op = r.op === '..' ? '<' : '<='; // ..< exclusive
      const cond = r.op === '..<' ? `${iName} < ${endC}` : `${iName} < ${endC}`;
      lines.push(`${pad}for (size_t ${iName} = ${startC}; ${this.stripOuterParens(cond)}; ${iName}++) {`);
      this.pushScope();
      this.declare(iName, prim('usize'));
      const marker = this.scopes.length - 1;
      this.loops.push({ markerScope: marker, cont: null });
      for (const st of s.body.stmts) this.emitStmtInto(lines, st, indent + 1);
      if (!this.blockEndsTerminated(s.body)) this.popScopeEmitting(lines, indent + 1);
      else this.popScope();
      this.loops.pop();
      lines.push(`${pad}}`);
      return;
    }

    const src = items[0];
    const srcTy = this.exprType(src);
    const elemTy = this.sliceElemType(srcTy);
    const srcC = this.expr(src, null);
    const xName = s.captures[0] || `zig_x${this.tmpCount++}`;
    const useIdx = s.captures.length > 1;
    const iName = useIdx ? (s.captures[1] || `zig_i${this.tmpCount++}`) : `zig_i${this.tmpCount++}`;
    const lenC = this.lenOf(src, srcTy);
    const elemAccess = this.elemAccess(src, srcTy, iName);

    lines.push(`${pad}for (size_t ${iName} = 0; ${iName} < ${lenC}; ${iName}++) {`);
    this.pushScope();
    lines.push(`${this.ind(indent + 1)}${this.cType(elemTy)} ${xName} = ${elemAccess};`);
    this.declare(xName, elemTy);
    this.declare(iName, prim('usize'));
    const marker = this.scopes.length - 1;
    this.loops.push({ markerScope: marker, cont: null });
    for (const st of s.body.stmts) this.emitStmtInto(lines, st, indent + 1);
    if (!this.blockEndsTerminated(s.body)) this.popScopeEmitting(lines, indent + 1);
    else this.popScope();
    this.loops.pop();
    lines.push(`${pad}}`);
  }

  emitSwitchInto(lines, s, indent) {
    const pad = this.ind(indent);
    const subjTy = this.exprType(s.subject);
    const subj = this.expr(s.subject, subjTy);
    const tmp = `zig_sw${this.tmpCount++}`;
    const useElse = s.arms.some((a) => a.vals.some((v) => v.k === 'ident' && v.name === 'else') || a.vals.some((v) => v.k === 'enumlit' && v.name === 'else'));
    lines.push(`${pad}{`);
    lines.push(`${this.ind(indent + 1)}${this.cType(subjTy)} ${tmp} = ${subj};`);
    let first = true;
    for (const arm of s.arms) {
      const isElse = arm.vals.some((v) => v.k === 'ident' && v.name === 'else') || arm.vals.some((v) => v.k === 'enumlit' && v.name === 'else');
      if (isElse) {
        lines.push(`${this.ind(indent + 1)}else {`);
      } else {
        const conds = arm.vals.map((v) => `${tmp} == ${this.expr(v, subjTy)}`).join(' || ');
        lines.push(`${this.ind(indent + 1)}${first ? 'if' : 'else if'} (${conds}) {`);
        first = false;
      }
      this.pushScope();
      for (const st of arm.body.stmts) this.emitStmtInto(lines, st, indent + 2);
      this.popScope();
      lines.push(`${this.ind(indent + 1)}}`);
    }
    lines.push(`${pad}}`);
  }

  stripOuterParens(s) {
    s = String(s).trim();
    if (!s.startsWith('(') || !s.endsWith(')')) return s;
    let depth = 0, q = null;
    for (let i = 0; i < s.length; i++) {
      const c = s[i];
      if (q) { if (c === '\\') { i++; continue; } if (c === q) q = null; continue; }
      if (c === '"' || c === "'") { q = c; continue; }
      if (c === '(') depth++;
      else if (c === ')') { depth--; if (depth === 0 && i !== s.length - 1) return s; }
    }
    return depth === 0 ? s.slice(1, -1) : s;
  }

  condText(cond, capture) {
    if (capture) return `${this.expr(cond, null)} != null`;
    return this.expr(cond, null);
  }

  stripOptional(ty) {
    if (!ty) return prim('i32');
    if (ty.k === 'optional') return ty.child;
    return ty;
  }

  sliceElemType(ty) {
    if (!ty) throw new Error('cannot determine element type of loop source');
    if (ty.k === 'slice') return ty.child;
    if (ty.k === 'array') return ty.child;
    if (ty.k === 'ptr') return ty.child;
    if (ty.k === 'optional') return this.sliceElemType(ty.child);
    throw new Error('unsupported for-loop source type');
  }

  lenOf(e, ty) {
    if (ty.k === 'slice') return `(${this.expr(e, null)}).len`;
    if (ty.k === 'array') return `(${this.expr(ty.len, prim('usize'))})`;
    throw new Error('cannot compute length for for-loop source');
  }

  elemAccess(e, ty, idx) {
    if (ty.k === 'slice') return `(${this.expr(e, null)}).ptr[${idx}]`;
    return `${this.expr(e, null)}[${idx}]`;
  }

  /* ---------- lvalue ---------- */
  lvalue(e) {
    switch (e.k) {
      case 'ident': return e.name;
      case 'field': {
        const objTy = this.exprType(e.obj);
        const o = this.expr(e.obj, null);
        if (this.isPointerToStruct(objTy)) return `(${o})->${e.name}`;
        return `${o}.${e.name}`;
      }
      case 'index': {
        const objTy = this.exprType(e.obj);
        const o = this.expr(e.obj, null);
        let idx = this.expr(e.index, prim('usize'));
        // char-subscript hygiene: `u8` maps to C `char`, which is signed here
        const it = this.exprType(e.index);
        if (this.isCharLike(it)) idx = `((size_t)(${idx}))`;
        if (objTy && objTy.k === 'slice') return `(${o}).ptr[${idx}]`;
        return `${o}[${idx}]`;
      }
      case 'deref': {
        const t = this.exprType(e.obj);
        if (t && t.k === 'optional') return `${this.expr(e.obj, null)}`;
        return `(*${this.expr(e.obj, null)})`;
      }
      default: throw new Error('unsupported assignment target ' + e.k);
    }
  }

  isPointerToStruct(ty) {
    if (!ty) return false;
    if (ty.k === 'ptr') return this.isStructLike(ty.child);
    if (ty.k === 'optional' && ty.child.k === 'ptr') return this.isStructLike(ty.child.child);
    return false;
  }
  isStructLike(ty) { return ty && ((ty.k === 'named' && (this.structs.has(ty.name) || this.auxStructs.has(ty.name))) || (ty.k === 'prim' && this.structs.has(ty.name))); }
  structFields(name) { return this.structs.get(name) || this.auxStructs.get(name) || null; }

  listInfo(ty) {
    if (ty && ty.k === 'ptr' && ty.ptrKind === 'single') ty = ty.child;
    if (!ty || ty.k !== 'named') return null;
    if (ty.name === 'std.ArrayList' || ty.name === 'std.ArrayListUnmanaged') {
      if (!ty.args || !ty.args[0]) return null;
      return { name: this.listName(ty.args[0]), elemTy: ty.args[0] };
    }
    if (this.listTypes.has(ty.name)) return { name: ty.name, elemTy: this.listTypes.get(ty.name).elemTy };
    return null;
  }

  mapInfo(ty) {
    if (ty && ty.k === 'ptr' && ty.ptrKind === 'single') ty = ty.child;
    if (!ty || ty.k !== 'named') return null;
    if (ty.name === 'std.AutoHashMap' || ty.name === 'std.AutoHashMapUnmanaged') {
      if (!ty.args || !ty.args[1]) return null;
      return { name: this.mapName(ty.args[0], ty.args[1]), keyTy: ty.args[0], valTy: ty.args[1] };
    }
    if (ty.name === 'std.StringHashMap' || ty.name === 'std.StringHashMapUnmanaged') {
      if (!ty.args || !ty.args[0]) return null;
      const k = slice(prim('u8'), { isConst: true });
      return { name: this.strMapName(ty.args[0]), keyTy: k, valTy: ty.args[0], keyKind: 'str' };
    }
    if (this.mapTypes.has(ty.name)) { const i = this.mapTypes.get(ty.name); return { name: ty.name, keyTy: i.keyTy, valTy: i.valTy, keyKind: i.keyKind }; }
    return null;
  }

  containerTypeOfTypeCall(e) {
    if (!e || e.k !== 'call') return null;
    const p = this.dottedPath(e.callee);
    if (p === 'std.ArrayList' || p === 'std.ArrayListUnmanaged') {
      const t = e.args[0] && e.args[0].ty;
      return t ? named('std.ArrayList', [t]) : null;
    }
    if (p === 'std.AutoHashMap' || p === 'std.AutoHashMapUnmanaged') {
      const k = e.args[0] && e.args[0].ty, v = e.args[1] && e.args[1].ty;
      return k && v ? named('std.AutoHashMap', [k, v]) : null;
    }
    if (p === 'std.StringHashMap' || p === 'std.StringHashMapUnmanaged') {
      const v = e.args[0] && e.args[0].ty;
      return v ? named('std.StringHashMap', [v]) : null;
    }
    return null;
  }

  isEmptyInit(e) {
    if (!e) return false;
    if (e.k === 'enumlit' && e.name === 'empty') return true;
    if (e.k === 'field' && e.name === 'empty' && this.containerTypeOfTypeCall(e.obj)) return true;
    return false;
  }

  /* ---------- expressions ---------- */
  expr(e, expTy) {
    if (!e) return '0';
    switch (e.k) {
      case 'int': return e.v;
      case 'float': return e.v;
      case 'str': {
        // A string literal used where a slice is expected becomes a slice view.
        if (expTy && expTy.k === 'slice' && this.isCharLike(expTy.child)) {
          const sname = this.cType(expTy);
          const pty = `${expTy.isConst ? 'const ' : ''}${this.cType(expTy.child)}*`;
          return `((${sname}){ .ptr = (${pty})${e.v}, .len = sizeof(${e.v}) - 1 })`;
        }
        return e.v;
      }
      case 'char': return `'${e.v}'`;
      case 'bool': return e.v;
      case 'null': return this.nullText(expTy);
      case 'undefined': return this.undefinedText(expTy);
      case 'enumlit': {
        if (this.isEmptyInit(e) && expTy) return `((${this.cType(expTy)}){0})`;
        return e.name;
      }
      case 'abort': return 'abort()';
      case 'ident': {
        if (e.name === 'unreachable') return 'abort()';
        return e.name;
      }
      case 'addr': return `(&${this.lvalue(e.obj)})`;
      case 'deref': {
        const t = this.exprType(e.obj);
        if (t && t.k === 'optional') return `${this.expr(e.obj, null)}`;
        return `(*${this.expr(e.obj, null)})`;
      }
      case 'unwrap': {
        const t = this.exprType(e.obj);
        if (t && t.k === 'optional' && !this.isPointerish(t.child)) return `((${this.expr(e.obj, t)}).value)`;
        return `${this.expr(e.obj, null)}`;
      }
      case 'field': return this.emitField(e);
      case 'index': return this.lvalue(e);
      case 'slicex': return this.emitSlice(e);
      case 'binop': return this.emitBinop(e, expTy);
      case 'unop': {
        if (e.op === '!') return `(!${this.expr(e.e, prim('bool'))})`;
        if (e.op === '-') return `(-${this.expr(e.e, expTy)})`;
        if (e.op === '~') return `(~${this.expr(e.e, expTy)})`;
        throw new Error('unsupported unary ' + e.op);
      }
      case 'optprefix': return this.expr(e.obj, this.stripOptional(expTy));
      case 'call': return this.emitCall(e);
      case 'builtin': return this.emitBuiltin(e, expTy);
      case 'structinit': return this.emitStructInit(e, expTy);
      case 'arrayinit': return this.emitArrayInit(e, expTy);
      case 'ifexpr': return this.emitIfExpr(e, expTy);
      case 'assignexpr': return `${this.lvalue(e.lhs)} ${e.op} ${this.expr(e.rhs, this.lvalueType(e.lhs))}`;
      case 'exprseq': return this.expr(e.lhs, expTy);
      default: throw new Error('unsupported expression ' + e.k);
    }
  }

  nullText(expTy) {
    if (expTy && expTy.k === 'optional') {
      if (expTy.child.k === 'ptr') return 'NULL';
      return `((${this.cType(expTy)}){0})`;
    }
    return 'NULL';
  }

  undefinedText(expTy) {
    if (!expTy) return '0';
    if (expTy.k === 'ptr') return 'NULL';
    if (expTy.k === 'slice') return `((${this.cType(expTy)}){0})`;
    if (expTy.k === 'optional') return this.nullText(expTy);
    if (this.listInfo(expTy) || this.mapInfo(expTy)) return `((${this.cType(expTy)}){0})`;
    return '0';
  }

  emitField(e) {
    // std.* handling
    if (e.obj.k === 'ident' && e.obj.name === 'std') {
      return `/* std.${e.name} */`;
    }
    const objTy = this.exprType(e.obj);
    const li = this.listInfo(objTy);
    if (li && e.name === 'items') {
      const sname = this.cType(slice(li.elemTy, {}));
      const o = this.expr(e.obj, null);
      return `((${sname}){ .ptr = (${o}).data, .len = (${o}).len })`;
    }
    if (e.name === 'len') {
      if (objTy && objTy.k === 'array') return objTy.len ? `(${this.expr(objTy.len, prim('usize'))})` : '0';
      if (objTy && objTy.k === 'ptr') return `(${this.expr(e.obj, null)})->len`;
      return `(${this.expr(e.obj, null)}).len`;
    }
    const o = this.expr(e.obj, null);
    if (this.isPointerToStruct(objTy)) return `(${o})->${e.name}`;
    return `${o}.${e.name}`;
  }

  emitSlice(e) {
    const srcTy = this.exprType(e.obj);
    let elemTy, isConst = false, ptrExpr, lenExpr;
    if (srcTy && srcTy.k === 'slice') { elemTy = srcTy.child; isConst = srcTy.isConst; ptrExpr = `(${this.expr(e.obj, null)}).ptr`; lenExpr = `(${this.expr(e.obj, null)}).len`; }
    else if (srcTy && srcTy.k === 'array') { elemTy = srcTy.child; isConst = !!srcTy.childConst; ptrExpr = `${this.expr(e.obj, null)}`; lenExpr = String(e.len); }
    else if (srcTy && srcTy.k === 'ptr') { elemTy = srcTy.child; isConst = srcTy.isConst; ptrExpr = `${this.expr(e.obj, null)}`; lenExpr = null; }
    else { throw new Error('cannot slice this expression'); }
    const sname = this.cType(slice(elemTy, { isConst }));
    const startC = e.start ? this.expr(e.start, prim('usize')) : '0';
    let endC;
    if (e.end) endC = this.expr(e.end, prim('usize'));
    else if (lenExpr !== null) endC = lenExpr;
    else throw new Error('open-ended slice of pointer needs a length');
    return `((${sname}){ .ptr = ${ptrExpr} + (${startC}), .len = (${endC}) - (${startC}) })`;
  }

  emitBinop(e, expTy) {
    const op = e.op;
    if (op === 'and') return `(${this.expr(e.l, prim('bool'))} && ${this.expr(e.r, prim('bool'))})`;
    if (op === 'or') return `(${this.expr(e.l, prim('bool'))} || ${this.expr(e.r, prim('bool'))})`;
    if (op === 'orelse') {
      const lt = this.exprType(e.l);
      const isUnreach = e.r && e.r.k === 'ident' && e.r.name === 'unreachable';
      if (lt && lt.k === 'optional' && !this.isPointerish(lt.child)) {
        const l = this.expr(e.l, lt);
        if (isUnreach) return `((${l}).value)`;
        return `((${l}).has ? (${l}).value : (${this.expr(e.r, lt.child)}))`;
      }
      const inner = lt && lt.k === 'optional' ? lt.child : (expTy || prim('i32'));
      const l = this.expr(e.l, inner);
      if (isUnreach) return `(${l})`;
      return `((${l}) ? (${l}) : (${this.expr(e.r, inner)}))`;
    }
    if (op === 'catch') return this.expr(e.l, expTy);
    if (op === '..' || op === '..<') throw new Error('range used outside of for-loop');
    if (CMP_OP[op]) return `(${this.expr(e.l, null)} ${op} ${this.expr(e.r, null)})`;
    if (op === '/' ) {
      const t = expTy || this.exprType(e.l);
      return `(${this.expr(e.l, t)} / ${this.expr(e.r, t)})`;
    }
    if (ARITH_OP[op]) {
      const t = expTy || this.exprType(e.l) || this.exprType(e.r);
      return `(${this.expr(e.l, t)} ${ARITH_OP[op]} ${this.expr(e.r, t)})`;
    }
    throw new Error('unsupported operator ' + op);
  }

  emitStructInit(e, expTy) {
    const ty = e.ty || expTy;
    if (!ty) throw new Error('cannot infer anonymous struct literal type');
    const name = this.cType(ty);
    const fields = e.fields.map((f) => `.${f.name} = ${this.expr(f.value, this.fieldType(ty, f.name))}`);
    return `((${name}){ ${fields.join(', ')} })`;
  }

  fieldType(ty, name) {
    let st = ty;
    if (st.k === 'optional') st = st.child.k === 'ptr' ? st.child.child : st.child;
    if (st.k === 'named') {
      const fs = this.structFields(st.name);
      if (fs) { const f = fs.find((x) => x.name === name); if (f) return f.ty; }
    }
    return null;
  }

  emitArrayInit(e, expTy) {
    const ty = e.ty || expTy;
    let elemTy = null;
    if (ty) {
      if (ty.k === 'array') elemTy = ty.child;
      else if (ty.k === 'slice') elemTy = ty.child;
      else elemTy = ty;
    }
    if (!elemTy) elemTy = prim('i32');
    // For []const u8 from string bytes this is fine.
    const elems = e.elems.map((x) => this.expr(x, elemTy)).join(', ');
    if (ty && ty.k === 'slice') {
      const sname = this.cType(slice(elemTy, { isConst: ty.isConst }));
      return `((${sname}){ .ptr = (${this.cType(elemTy)}[]){ ${elems} }, .len = ${e.elems.length} })`;
    }
    return `(${this.cType(elemTy)}[]){ ${elems} }`;
  }

  emitIfExpr(e, expTy) {
    if (e.then.k === 'block' || (e.else && e.else.k === 'block')) {
      throw new Error('block-bodied if-expression is not supported; use a statement or a simple if/else');
    }
    const cond = this.expr(e.cond, prim('bool'));
    const a = this.expr(e.then, expTy);
    const b = e.else ? this.expr(e.else, expTy) : '0';
    return `((${cond}) ? (${a}) : (${b}))`;
  }

  emitCall(e) {
    const callee = e.callee;
    // std.AutoHashMap(K, V).init(allocator)
    if (callee.k === 'field' && callee.name === 'init') {
      const recv = this.containerTypeOfTypeCall(callee.obj);
      if (recv) {
        const mi = this.mapInfo(recv);
        if (mi) return `${mi.name}_init()`;
        const li = this.listInfo(recv);
        if (li) return `((${li.name}){0})`;
      }
    }
    // container methods on a value
    if (callee.k === 'field') {
      const lowered = this.emitContainerMethod(this.exprType(callee.obj), callee.name, callee.obj, e.args);
      if (lowered !== null) return lowered;
    }
    const path = this.dottedPath(callee);
    if (path) {
      const handled = this.emitStdPath(path, e.args);
      if (handled !== null) return handled;
      if (path.startsWith('std.')) {
        throw new Error(`unsupported std path '${path}' (extend zig2c or rewrite in the supported subset)`);
      }
    }
    // allocator calls (detected by method name, so aliases work)
    if (callee.k === 'field') {
      const m = callee.name;
      if (m === 'alloc' || m === 'allocSentinel') {
        const T = e.args[0].ty;
        const n = this.expr(e.args[1], prim('usize'));
        const sname = this.cType(slice(T, {}));
        return `((${sname}){ .ptr = (${this.cType(T)}*)malloc(sizeof(${this.cType(T)}) * (${n})), .len = (${n}) })`;
      }
      if (m === 'free') { const a = this.expr(e.args[0], null); return `free((${a}).ptr)`; }
      if (m === 'create') { const T = e.args[0].ty; return `((${this.cType(T)}*)malloc(sizeof(${this.cType(T)})))`; }
      if (m === 'destroy') { return `free(${this.expr(e.args[0], null)})`; }
      if (m === 'dupe') {
        const T = e.args[0].ty; const src = this.expr(e.args[1], null);
        return `((${this.cType(slice(T, {}))}){ .ptr = (${this.cType(T)}*)memcpy(malloc((${src}).len * sizeof(${this.cType(T)})), (${src}).ptr, (${src}).len * sizeof(${this.cType(T)})), .len = (${src}).len })`;
      }
    }
    if (callee.k === 'ident') {
      return `${callee.name}(${e.args.map((a) => this.expr(a, null)).join(', ')})`;
    }
    throw new Error('unsupported call form');
  }

  emitContainerMethod(rt, m, objExpr, args) {
    const isPtrRecv = rt && rt.k === 'ptr' && rt.ptrKind === 'single';
    const R = isPtrRecv ? `(${this.expr(objExpr, null)})` : `&(${this.expr(objExpr, null)})`;
    if (rt && rt.k === 'named' && this.iterTypes.has(rt.name)) {
      const it = this.iterTypes.get(rt.name);
      if (m === 'next') {
        const fn = it.kind === 'entry' ? 'iter_next' : it.kind === 'key' ? 'key_next' : 'val_next';
        return `${it.mapName}_${fn}(${R})`;
      }
      return null;
    }
    const li = this.listInfo(rt);
    if (li) {
      const n = li.name;
      switch (m) {
        case 'append': return `${n}_append(${R}, (${this.expr(args[1], li.elemTy)}))`;
        case 'appendSlice': {
          const s = this.expr(args[1], null);
          return `${n}_appendSlice(${R}, (${s}).ptr, (${s}).len)`;
        }
        case 'deinit': return `${n}_deinit(${R})`;
        case 'clearRetainingCapacity': case 'clearAndFree': return `${n}_clear(${R})`;
        case 'ensureTotalCapacity': return `${n}_reserve(${R}, ${this.expr(args[0], prim('usize'))})`;
        case 'toOwnedSlice': return `${n}_toOwnedSlice(${R})`;
        case 'orderedRemove': return `${n}_orderedRemove(${R}, ${this.expr(args[0], prim('usize'))})`;
        case 'swapRemove': return `${n}_swapRemove(${R}, ${this.expr(args[0], prim('usize'))})`;
        case 'insert': return `${n}_insert(${R}, ${this.expr(args[0], prim('usize'))}, ${this.expr(args[1], li.elemTy)})`;
        case 'pop': return `${n}_pop(${R})`;
        case 'getLast': {
          const o = this.expr(objExpr, null);
          return isPtrRecv ? `((${o})->data[(${o})->len - 1])` : `((${o}).data[(${o}).len - 1])`;
        }
        case 'len': return `((${this.expr(objExpr, null)}).len)`;
        default: return null;
      }
    }
    const mi = this.mapInfo(rt);
    if (mi) {
      const n = mi.name;
      switch (m) {
        case 'init': return `${n}_init()`;
        case 'put': return `${n}_put(${R}, ${this.expr(args[0], mi.keyTy)}, ${this.expr(args[1], mi.valTy)})`;
        case 'get': return `${n}_get(${R}, ${this.expr(args[0], mi.keyTy)})`;
        case 'contains': return `${n}_contains(${R}, ${this.expr(args[0], mi.keyTy)})`;
        case 'remove': return `${n}_remove(${R}, ${this.expr(args[0], mi.keyTy)})`;
        case 'count': case 'size': return `${n}_count(${R})`;
        case 'getOrPut': return `${n}_getOrPut(${R}, ${this.expr(args[0], mi.keyTy)})`;
        case 'iterator': return `${n}_iter(${R})`;
        case 'keyIterator': return `${n}_key_iter(${R})`;
        case 'valueIterator': return `${n}_val_iter(${R})`;
        case 'deinit': return `${n}_deinit(${R})`;
        default: return null;
      }
    }
    return null;
  }

  emitStdPath(path, args) {
    if (path.startsWith('std.sort.') || path === 'std.mem.sort') {
      // std.sort.pdq(T, slice, ctx, lessThan);  std.mem.sort(T, slice, ctx, lessThan)
      return this.emitSort(args);
    }
    switch (path) {
      case 'std.mem.eql': {
        this.helper('memeql');
        const a = this.expr(args[1], null), b = this.expr(args[2], null);
        return `zig_mem_eql((${a}).ptr, (${a}).len, (${b}).ptr, (${b}).len)`;
      }
      case 'std.mem.reverse': {
        this.helper('reverse');
        const s = this.expr(args[0], null);
        const T = args[1] && args[1].ty ? this.cType(args[1].ty) : 'int';
        return `zig_reverse(${T}, (${s}).ptr, (${s}).len)`;
      }
      case 'std.mem.sliceTo': case 'std.mem.span': {
        const p = this.expr(args[0], null);
        const t = this.exprType(args[0]);
        const elem = t && t.k === 'ptr' ? t.child : prim('u8');
        const isC = t && t.k === 'ptr' ? t.isConst : true;
        const sname = this.cType(slice(elem, { isConst: isC }));
        return `((${sname}){ .ptr = (${p}), .len = strlen((const char*)(${p})) })`;
      }
      case 'std.mem.len': {
        const p = this.expr(args[0], null);
        return `strlen((const char*)(${p}))`;
      }
      case 'std.mem.swap': {
        const a = this.lvalue(args[1]), b = this.lvalue(args[2]);
        const T = args[0] && args[0].ty ? this.cType(args[0].ty) : 'int';
        return `do { ${T} zig__sw = ${a}; ${a} = ${b}; ${b} = zig__sw; } while (0)`;
      }
      case 'std.mem.copyForwards': {
        const dst = this.expr(args[1], null), src = this.expr(args[2], null);
        return `memmove((${dst}).ptr, (${src}).ptr, (${src}).len)`;
      }
      case 'std.ascii.isAlphanumeric': { this.helper('isalpha'); this.helper('isdigit'); this.helper('isalnum'); return `zig_is_alnum(${this.expr(args[0], null)})`; }
      case 'std.ascii.isAlphabetic': { this.helper('isalpha'); return `zig_is_alpha(${this.expr(args[0], null)})`; }
      case 'std.ascii.isDigit': { this.helper('isdigit'); return `zig_is_digit(${this.expr(args[0], null)})`; }
      case 'std.ascii.isWhitespace': { this.helper('isspace'); return `zig_is_space(${this.expr(args[0], null)})`; }
      case 'std.ascii.toLower': { this.helper('tolower'); return `zig_to_lower(${this.expr(args[0], null)})`; }
      case 'std.ascii.toUpper': { this.helper('toupper'); return `zig_to_upper(${this.expr(args[0], null)})`; }
      case 'std.math.max': { this.helper('max'); return `zig_max(${this.expr(args[0], null)}, ${this.expr(args[1], null)})`; }
      case 'std.math.min': { this.helper('min'); return `zig_min(${this.expr(args[0], null)}, ${this.expr(args[1], null)})`; }
      case 'std.math.absInt': { this.helper('abs'); return `zig_abs(${this.expr(args[0], null)})`; }
      case 'std.debug.print': {
        const fmt = this.expr(args[0], null);
        const tupleArgs = args[1];
        const parts = tupleArgs && (tupleArgs.k === 'arrayinit' || tupleArgs.k === 'structinit')
          ? tupleArgs.elems.map((x) => this.expr(x, null))
          : [];
        return `printf(${[fmt, ...parts].join(', ')})`;
      }
      default:
        return null;
    }
  }

  emitSort(args) {
    // args: [T, slice, ctx, lessThan]
    const T = args[0].ty;
    const sliceExprSrc = this.expr(args[1], null);
    const cmpFn = args[3] && args[3].k === 'ident' ? args[3].name : null;
    if (!cmpFn) throw new Error('std.sort requires a named comparison function');
    const idx = this.cmpCount++;
    const wrapper = `static int zig_cmp_${idx}(const void *a, const void *b) { const ${T ? this.cType(T) : 'int'} *x = a, *y = b; if (${cmpFn}(*x, *y)) return -1; if (${cmpFn}(*y, *x)) return 1; return 0; }`;
    this.cmpWrappers.push(wrapper);
    const Tn = T ? this.cType(T) : 'int';
    return `qsort((${sliceExprSrc}).ptr, (${sliceExprSrc}).len, sizeof(${Tn}), zig_cmp_${idx})`;
  }

  emitBuiltin(e, expTy) {
    const n = e.name;
    const a = e.args || [];
    switch (n) {
      case '@import': return '/* import */';
      case '@as': {
        const T = a[0].ty;
        const c = this.cType(T);
        if (a[1].k === 'null') return 'NULL';
        if (T && T.k === 'slice') return this.expr(a[1], T);
        return `((${c})(${this.expr(a[1], T)}))`;
      }
      case '@intCast': {
        const target = expTy || prim('i32');
        return `((${this.cType(target)})(${this.expr(a[0], null)}))`;
      }
      case '@truncate': {
        const target = expTy || prim('i32');
        return `((${this.cType(target)})(${this.expr(a[0], null)}))`;
      }
      case '@intFromFloat': case '@floatFromInt': {
        const target = expTy || prim('i32');
        return `((${this.cType(target)})(${this.expr(a[0], null)}))`;
      }
      case '@intFromPtr': return `((size_t)(${this.expr(a[0], null)}))`;
      case '@ptrFromInt': {
        const target = expTy || ptr(prim('void'), { ptrKind: 'single' });
        return `((${this.cType(target)})(${this.expr(a[0], null)}))`;
      }
      case '@ptrCast': {
        const target = expTy || ptr(prim('void'), { ptrKind: 'single' });
        return `((${this.cType(target)})(${this.expr(a[0], null)}))`;
      }
      case '@alignCast': return this.expr(a[0], expTy);
      case '@constCast': return this.expr(a[0], expTy);
      case '@sizeOf': return `sizeof(${this.cType(a[0].ty)})`;
      case '@bitSizeOf': return `(8 * sizeof(${this.cType(a[0].ty)}))`;
      case '@min': { this.helper('min'); return `zig_min(${this.expr(a[0], expTy)}, ${this.expr(a[1], expTy)})`; }
      case '@max': { this.helper('max'); return `zig_max(${this.expr(a[0], expTy)}, ${this.expr(a[1], expTy)})`; }
      case '@abs': { this.helper('abs'); return `zig_abs(${this.expr(a[0], expTy)})`; }
      case '@mod': { this.helper('mod'); return `zig_mod(${this.expr(a[0], expTy)}, ${this.expr(a[1], expTy)})`; }
      case '@rem': return `((${this.expr(a[0], expTy)}) % (${this.expr(a[1], expTy)}))`;
      case '@divTrunc': return `((${this.expr(a[0], expTy)}) / (${this.expr(a[1], expTy)}))`;
      case '@divFloor': { this.helper('divfloor'); return `zig_div_floor(${this.expr(a[0], null)}, ${this.expr(a[1], null)})`; }
      case '@sqrt': return `sqrt(${this.expr(a[0], null)})`;
      case '@intFromEnum': return this.expr(a[0], expTy);
      case '@memset': return `memset(${this.expr(a[0], null)}, ${this.expr(a[1], null)}, ${this.expr(a[2], null)})`;
      case '@memcpy': return `memcpy(${this.expr(a[0], null)}, ${this.expr(a[1], null)}, ${this.expr(a[2], null)})`;
      default:
        throw new Error(`unsupported builtin '${n}' (extend zig2c or rewrite in the supported subset)`);
    }
  }
}

/* ============================== CLI ============================== */

function main() {
  const args = process.argv.slice(2);
  if (!args.length || args.includes('-h') || args.includes('--help')) {
    console.log('usage: node zig2c.js <input.zig> [-o output.c]');
    process.exit(args.length ? 0 : 1);
  }
  const inFile = args[0];
  let outFile = null;
  const oi = args.indexOf('-o');
  if (oi >= 0) outFile = args[oi + 1];
  let provided = ['ListNode', 'TreeNode', 'Node'];
  const pi = args.findIndex((a) => a.startsWith('--provided='));
  if (pi >= 0) {
    const v = args[pi].slice('--provided='.length).trim();
    provided = v ? v.split(',').map((s) => s.trim()).filter(Boolean) : [];
  }
  const src = fs.readFileSync(inFile, 'utf8');
  try {
    const toks = lex(src);
    const p = new Parser(toks, inFile);
    const items = p.parseProgram();
    const em = new Emitter(items, { provided });
    const c = em.emit();
    if (outFile) { fs.writeFileSync(outFile, c); console.error(`wrote ${outFile}`); }
    else process.stdout.write(c);
  } catch (err) {
    console.error(`zig2c: ${err.message}`);
    process.exit(2);
  }
}

if (require.main === module) main();
module.exports = { lex, Parser, Emitter };
