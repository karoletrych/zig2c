# Zig on LeetCode (via C)

[![verify](https://github.com/karoletrych/zig2c/actions/workflows/verify.yml/badge.svg)](https://github.com/karoletrych/zig2c/actions/workflows/verify.yml)

LeetCode has no Zig option, and `zig build-obj -ofmt=c` is a dead end: its C
backend is a compiler *bootstrap* backend, so it emits SSA-style three-address
code with numbered temporaries, `goto` label state machines, mangled names and a
`#include "zig.h"` dependency. Here is what it produced for a clean 15-line Zig
function:

```c
int32_t sample_maxArea__215(int32_t const *const a0, int32_t const a1) {
 int32_t const *const *t1;
 uintptr_t t8;
 ...
 zig_loop_13:
 t5 = t3;
 t7 = t5 < t6;
 if (t7) { ... goto zig_block_2; }
```

That is not fixable, and it is not meant to be human-facing.

There is also no existing Zig -> C translator on GitHub that produces readable C
(the `zig2c` repo is unrelated). So this repository builds one.

**`zig2c` is a small, deterministic Zig -> C translator.** You write real Zig
(which you can run and test with `zig test`), and it emits clean, single-file C
that LeetCode's C judge accepts. Same input always produces the same output:
there is no model, no network, and no "fixing". You can read the whole
translator in `zig2c/zig2c.js`.

Every example in `problems/` is checked both ways: the Zig must pass `zig test`,
and the generated C must compile with `zig cc -Wall -Wextra` and produce the
same answers. Coverage:

- **All 75 problems of the official LeetCode 75 study plan** — `docs/lc75-status.md`
- **All 150 problems of the Top Interview 150 study plan** — `docs/lc150-status.md`
  (includes 32 Hard problems, design problems like LRU Cache / Min Stack / Trie,
  graph `Node`, tries, heaps, and interval/DP problems)

---

## Quick start

You need **Zig 0.17**. Put `zig` on your `PATH`, drop a Zig install under
`.tools/` (the verifier auto-detects it), or point at it explicitly:

```powershell
$env:ZIG = "C:\path\to\zig.exe"
```

Everything here was built and verified with Zig 0.17.0 on Windows; the scripts
are dependency-free Node.js and use `zig cc` as the C compiler, so no GCC/MSVC
install is needed.

Verify everything (uses Zig's bundled C compiler, `zig cc`, so no GCC needed):

```powershell
node tools\verify.js --all
```

Verification is parallel (one worker per core, capped at 8) and incremental:

```powershell
node tools\verify.js --all            # runs only changed problems, else instant
node tools\verify.js --all --force    # re-verify everything regardless
node tools\verify.js some_problem -j 4
```

Measured on this repo (146 problems): `--all --force` takes ~109s with 8 workers
versus ~556s single-threaded, and a re-run with nothing changed is instant. Two
things make that work:

- **Per-worker zig caches.** Concurrent `zig` invocations sharing one global
  cache serialize on a lock (scaling was linear in the number of jobs); giving
  each worker its own `ZIG_GLOBAL_CACHE_DIR` removes that entirely. The caches
  are persistent, so only the first run pays a one-time std build per worker.
- **Incremental cache.** A problem is skipped when `solution.zig`, `driver.c`,
  `zig2c.js` and `tools/verify.js` are all unchanged since it last passed, so
  editing one problem (or one translator rule) re-verifies only what it affects.

Write a problem:

```powershell
# scaffold one (prints the C prototype zig2c will emit, then verifies it):
node tools\new.js my_problem --fn myFn --params "nums: [*]i32, n: i32" --ret i32

# or edit problems\<name>\solution.zig and problems\<name>\driver.c, then:
node tools\verify.js <name>
```

Translate it (also done automatically by verify):

```powershell
node zig2c\zig2c.js problems\<name>\solution.zig -o problems\<name>\leetcode.c
```

Then open the problem on LeetCode, pick **C**, and paste
`problems\<name>\leetcode.c`. That file contains exactly what the judge needs:
the function with the expected signature plus a few small helpers.

---

## How it works

```
solution.zig ──► zig2c (lexer -> parser -> emitter) ──► leetcode.c
     │                                                       │
     └── zig test  (proves the algorithm)                    └── zig cc + driver.c (proves the translation)
```

Four moving parts:

| File | Role |
| --- | --- |
| `zig2c/zig2c.js` | The translator: Zig lexer, parser, C emitter. |
| `tools/verify.js` | Runs `zig test`, translates, compiles the C, runs it. |
| `problems/<name>/solution.zig` | Your Zig, with `test` blocks. Source of truth. |
| `problems/<name>/driver.c` | C test that calls the generated function. |

`zig2c` only emits what LeetCode can reach: the `pub`/`export` functions and
everything they call. Your `test` blocks and test-only helpers stay in Zig and
never appear in the C.

---

## The translation rules that matter

The one thing you must get right is the **function signature**, because
LeetCode's C harness declares it. Write the Zig types so they map to the exact C
types LeetCode expects.

| LeetCode C signature | Zig you write |
| --- | --- |
| `int* f(int* nums, int numsSize)` | `f(nums: [*]i32, numsSize: i32)` |
| `int* f(int* nums, int n, int* returnSize)` | `f(nums: [*]i32, n: i32, returnSize: *i32) ?[*]i32` |
| `char* f(char* s)` | `f(s: [*]u8)` |
| `bool f(char* s)` | `f(s: [*]u8) bool` |
| `int f(char* s)` | `f(s: [*]u8) i32` |
| `struct ListNode* f(struct ListNode* h)` | `f(h: ?*ListNode) ?*ListNode` |
| `struct TreeNode* f(struct TreeNode* r)` | `f(r: ?*TreeNode) ?*TreeNode` |
| `int f(int n)` | `f(n: i32) i32` |
| `long long f(long long n)` | `f(n: i64) i64` |

Two deliberate choices:

* **`u8` maps to C's `char`, not `uint8_t`.** LeetCode's C signatures use
  `char*` for strings, and `unsigned char*` does not match. So `[*]u8` is
  `char*` and `[*]const u8` is `const char*`.
* **`ListNode`, `TreeNode` and `Node` are treated as already defined by
  LeetCode.** Their C templates show the struct only as a comment; the harness
  provides the real definition. `zig2c` therefore emits just a `typedef` for
  them and hides the body behind `ZIG2C_LOCAL`, which only the local test build
  turns on. (If a problem turns out *not* to provide them, regenerate with
  `--provided=` to emit the definitions inline.)

### Rosetta

| Zig | C |
| --- | --- |
| `i8 i16 i32 i64` | `int8_t int16_t int long long` |
| `u8 u16 u32 u64` | `char uint16_t uint32_t unsigned long long` |
| `usize isize` | `size_t ptrdiff_t` |
| `f32 f64 bool` | `float double bool` |
| `[*]T` / `[*]const T` | `T*` / `const T*` |
| `*T` / `?*T` | `T*` (null shown as `NULL`) |
| `[]const u8` / `[]i32` | `zig_slice_*` = `{ ptr; len; }` |
| `undefined` | uninitialized declaration |
| `x.len` (slice) | `(x).len` |
| `x[i]` (slice) | `(x).ptr[i]` |
| `x[a..b]` | `(zig_slice_T){ .ptr = x + a, .len = b - a }` |
| `p.*` | `(*p)` |
| `&x` | `(&x)` |
| `s.field` / `p.field` | `s.field` / `(p)->field` |
| `x.?` | `x` |
| `if (x) \|v\| { }` | `if (x != NULL) { T* v = x; ... }` |
| `while (x) \|v\| { }` | `while (x != NULL) { T* v = x; ... }` |
| `for (0..n) \|i\|` | `for (size_t i = 0; i < n; i++)` |
| `for (s) \|x\|` | loop over a slice/array |
| `for (s, 0..) \|x, i\|` | loop with an index |
| `and` `or` `!` | `&&` `\|\|` `!` |
| `a orelse b` | `(a ? a : b)` |
| `@min` `@max` `@abs` | `zig_min` `zig_max` `zig_abs` |
| `@as(T, x)` | `((T)(x))` |
| `@intCast(x)` | `(expected_type)(x)` |
| `@sizeOf(T)` | `sizeof(T)` |
| `defer f();` | `f();` emitted before every `return`/`continue`/scope exit |
| `allocator.alloc(T, n)` | a `malloc`'d slice |
| `allocator.free(s)` | `free((s).ptr)` |
| `allocator.create(T)` | `(T*)malloc(sizeof(T))` |
| `std.mem.sliceTo(p, 0)` / `std.mem.span(p)` | slice from a NUL-terminated pointer |
| `std.mem.eql(T, a, b)` | `zig_mem_eql` |
| `std.mem.sort(...)` / `std.sort.pdq(...)` | `qsort` + a generated comparator |
| `std.ascii.isDigit/isAlphabetic/isAlphanumeric/isWhitespace/toLower/toUpper` | `zig_is_*` helpers |
| `std.debug.print(fmt, .{a, b})` | `printf(fmt, a, b)` |
| `std.ArrayList(T)` | `zig_ArrayList_T` (a growable `{ data; len; cap; }`) |
| `list.append(alloc, x)` / `.items` | `append` helper / a slice view |
| `std.AutoHashMap(K, V)` | `zig_Map_K_V` (open addressing) |
| `std.StringHashMap(V)` | `zig_SMap_V` (FNV-1a over the key bytes + `memcmp`) |
| `map.get(k)` (`?V`) | `zig_opt_V` = `{ value; has; }` |
| `?T` for non-pointer `T` | `zig_opt_T` = `{ value; has; }` |
| `map.iterator()` / `.keyIterator()` / `.valueIterator()` | per-map iterator struct + `next` |
| `?*Entry` from `it.next()` | a pointer (NULL when exhausted) |

`std.heap.c_allocator`, `std.heap.page_allocator` and any `const x = <allocator>`
alias all work; allocator calls are recognised by method name (`alloc`, `free`,
`create`, `destroy`, `dupe`), so aliases do not matter.

---

## Supported Zig subset

Functions, `pub`/`export`, parameters, recursion.

Types: integers, floats, `bool`, pointers (`*T`, `[*]T`, `[*c]T`), slices
(`[]T`, `[]const T`), optionals of pointers (`?*T`), fixed arrays (`[N]T`),
`struct` definitions and struct literals.

Statements: `var`/`const` (with type inference), assignment and compound
assignment, tuple assignment (`a, b = b, a`), `if`/`else if`/`else` (with and
without braces, with `|capture|`), `while` with `: (continue-expr)` and
`|capture|`, `for` over ranges/slices/arrays, `return`, `break`, `continue`,
`defer`, `switch` over integers, nested blocks.

Expressions: arithmetic, comparison, bitwise, shifts, `and`/`or`/`!`,
`orelse`, `.?`, `.*`, `&`, indexing, slicing, field access, calls, struct and
array literals, `if` expressions (ternaries), the common builtins (`@as`,
`@intCast`, `@min`, `@max`, `@abs`, `@sizeOf`, `@ptrCast`, `@alignCast`,
`@intFromPtr`, `@ptrFromInt`, `@truncate`, `@divFloor`, `@mod`,
`@divTrunc`).

## Not supported (yet) - and what to do

These are the honest gaps. For many of them the C solution would hand-roll the
same thing anyway, so writing it that way in Zig is the natural path.

| Not supported | Workaround |
| --- | --- |
| `std.ArrayList` **iterators** (`list.iterator()`) | iterate `list.items` instead: `for (list.items) \|x\|` or `for (0..list.items.len) \|i\|` |
| error unions / `try` / `catch` (the handler is ignored; `catch unreachable` and `catch return x` parse) | allocate and ignore failure, or `orelse` |
| `comptime`, generics, `inline for`, `anytype` | write the concrete version |
| tagged unions / `enum` switching | use integers |
| `switch` on strings, ranges, multiple values per arm beyond `a, b =>` | use `if` chains |
| labeled `break :label` | restructure |
| nested functions / closures | hoist to top level |
| slices-of-slices writing (`[][]u8` mutation) | build indices manually |
| `@memcpy` on overlapping slices | `std.mem.copyForwards` |

If you hit one of these, either rewrite it in the supported subset (usually
easy) or extend `zig2c` - see below.

---

## Adding a problem

1. `problems/<name>/solution.zig` - write real Zig. Add a `test` block using
   `std.testing.expectEqual`. Keep the `pub fn` signature matched to LeetCode's
   C signature (table above).
2. `problems/<name>/driver.c` - a `main` that `#include "leetcode.c"` and checks
   the same cases.
3. `node tools\verify.js <name>`.
4. Paste `problems/<name>/leetcode.c` into LeetCode's C editor.

Note: when you compile a driver by hand, tree/linked-list problems need
`-DZIG2C_LOCAL=1` (the verifier adds it) so the `TreeNode`/`ListNode` bodies are
visible for local runs.

## Extending the translator

Everything is in `zig2c/zig2c.js`, in three sections: `LEXER`, `PARSER`,
`EMITTER`. Useful notes:

* Adding a builtin: add a case in `emitBuiltin` (and in `builtinType` if it has
  a return type).
* Adding a std helper: add a case in `emitStdPath` (plus `stdCallType`). This is
  where further `std.*` support would go (e.g. `std.StringHashMap`,
  `std.ArrayList` iteration).
* Adding a type: extend `PRIM_CTYPE` and/or `cType`.
* The emitter walks the AST directly and writes C; there is no intermediate IR,
  which is what keeps the output readable.

If something fails, `zig2c` exits non-zero and prints the offending line, e.g.
`zig2c: solution.zig: line 42: unsupported std path 'std.hash_map...'`.

## Design principles

* **Deterministic.** Pure function of the input file.
* **Inspectable.** One readable file, no dependencies, no build step.
* **Verifiable.** The Zig is the source of truth and is tested directly; the C
  is tested separately and must agree.
* **Minimal output.** Names are preserved, no temporaries, no gotos, no runtime.

## Example output

`problems/max_depth_tree/solution.zig`:

```zig
pub const TreeNode = struct { val: i32, left: ?*TreeNode, right: ?*TreeNode };

pub fn maxDepth(root: ?*TreeNode) i32 {
    if (root == null) return 0;
    const l = maxDepth(root.?.left);
    const r = maxDepth(root.?.right);
    return 1 + @max(l, r);
}
```

becomes `problems/max_depth_tree/leetcode.c`:

```c
typedef struct TreeNode TreeNode;

/* struct TreeNode is defined by the LeetCode harness; local builds use ZIG2C_LOCAL */
#ifdef ZIG2C_LOCAL
struct TreeNode { int val; TreeNode* left; TreeNode* right; };
#endif

int maxDepth(TreeNode* root);

int maxDepth(TreeNode* root) {
    if (root == NULL) {
        return 0;
    }
    int l = maxDepth((root)->left);
    int r = maxDepth((root)->right);
    return (1 + zig_max(l, r));
}
```
