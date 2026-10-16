# Authoring a problem for zig2c

You are adding a LeetCode problem to `problems/<name>/` so that it can be solved
in real Zig and submitted to LeetCode as C. Read `README.md` first for the big
picture. This file is the checklist.

## Deliverables

Two files per problem:

- `problems/<name>/solution.zig` — real Zig. Must compile and pass with
  `zig test solution.zig -lc`. Add at least one `test` block with
  `std.testing.expectEqual` / `expect`. The `pub fn` signature must match
  LeetCode's C signature (see the mapping below).
- `problems/<name>/driver.c` — a `main` that `#include "leetcode.c"` and checks
  the same cases:

```c
#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    /* ...call the function, CHECK the results... */
    printf("<name>: OK\n");
    return 0;
}
```

## The loop

```powershell
node tools\verify.js <name>
node tools\verify.js <name> --force   # if a cached result looks stale
node tools\verify.js <name> -j 1      # debugging: one worker, ordered output
```

It runs `zig test`, translates, compiles the C with `zig cc -Wall -Wextra
-DZIG2C_LOCAL=1`, and runs it. **Iterate until all three steps are green.**
`zig` is auto-found under `.tools/`; you can also set `$env:ZIG`.

Verification is parallel and incremental (see README); results are cached per
problem and invalidated by any change to `solution.zig`, `driver.c`, `zig2c.js`
or `tools/verify.js`.

## Hard rules

1. **Do not modify** `zig2c/zig2c.js`, `tools/verify.js`, or any other
   problem. Only create files under your own `problems/<name>/`.
2. **Do not weaken tests** to make them pass. If the C and Zig disagree, the
   translator or your code has a bug — find it.
3. Stay inside the supported subset (below). If you need a feature that is not
   supported, either implement the algorithm a different way (usually the way
   you would write it in C) or report it as a blocker.
4. Warnings are treated as failures worth fixing (the verifier prints them).

## Signature mapping (get this exactly right)

| LeetCode C signature | Zig you write |
| --- | --- |
| `int* f(int* nums, int numsSize)` | `f(nums: [*]i32, numsSize: i32)` |
| `int* f(int* nums, int n, int* returnSize)` | `f(nums: [*]i32, n: i32, returnSize: *i32) ?[*]i32` |
| `char* f(char* s)` | `f(s: [*]u8)` (return `?[*]u8` or `[*]u8`) |
| `bool* f(..., int* returnSize)` | `f(..., returnSize: *i32) ?[*]bool` |
| `int** f(..., int* returnSize, int** returnColumnSizes)` | `f(..., returnSize: *i32, returnColumnSizes: [*][*]i32) ?[*][*]i32` |
| `char** f(char* s, int* returnSize)` | `f(s: [*]u8, returnSize: *i32) ?[*][*]u8` |
| `int** grid` param | `grid: [*][*]i32` |
| `int* gridColSize` param | `gridColSize: [*]i32` |
| `struct TreeNode* f(struct TreeNode* root)` | `f(root: ?*TreeNode) ?*TreeNode` |
| `int f(struct TreeNode* root)` | `f(root: ?*TreeNode) i32` |
| `long long f(int* a, int n, int k)` | `f(a: [*]i32, n: i32, k: i32) i64` |
| `double f(int* nums, int n, int k)` | `f(nums: [*]i32, n: i32, k: i32) f64` |

Key points:

- `u8` maps to C `char` (so `[*]u8` is `char*`). Use `u8` for strings.
- `i32` -> `int`, `i64` -> `long long`, `usize` -> `size_t`, `bool` -> `bool`,
  `f64` -> `double`.
- Return `?[*]T` when the C return is a pointer that can be NULL; otherwise use
  the non-optional `[*]T`. Both emit `T*`.
- Arrays returned to LeetCode must be `malloc`'d; use
  `allocator.alloc(T, n) catch unreachable` (see below).
- Set `returnSize.* = n;` before returning.
- `ListNode` / `TreeNode` are assumed to be provided by LeetCode: name your
  struct exactly `ListNode` (fields `val: i32`, `next: ?*ListNode`) or
  `TreeNode` (fields `val: i32`, `left/right: ?*TreeNode`). Do not add them to
  `providedStructs`; the translator already hides their bodies behind
  `ZIG2C_LOCAL`. For local `driver.c` builds the verifier passes
  `-DZIG2C_LOCAL=1`, so they are visible.
- Design problems (e.g. `RecentCounter`) define their own struct and the
  `xxxCreate/xxxPing/xxxFree` functions; just write several `pub fn`s.

## Allocators and containers

```zig
const std = @import("std");
const allocator = std.heap.c_allocator;
```

- `allocator.alloc(T, n) catch unreachable` -> a `malloc`'d `[]T` (slice).
- `allocator.free(slice)` -> `free(slice.ptr)`.
- Use `defer allocator.free(x);` for cleanup; it is emitted before every
  `return`/`continue`/block exit.
- `std.ArrayList(T)` is **unmanaged** in Zig 0.17:
  ```zig
  var list: std.ArrayList(i32) = .empty;
  defer list.deinit(allocator);
  list.append(allocator, 7) catch unreachable;
  for (list.items) |v| { ... }
  ```
  Supported methods: `append(alloc, x)`, `appendSlice(alloc, s)`, `deinit(alloc)`,
  `items`, `toOwnedSlice(alloc)`, `clearRetainingCapacity()`, `orderedRemove(i)`,
  `swapRemove(i)`, `insert(i, x)`, `pop()` (returns `?T`), `getLast()` (returns
  `T`), `ensureTotalCapacity(n)`. Iterators are not supported.
- `std.AutoHashMap(K, V)` is managed:
  ```zig
  var map = std.AutoHashMap(i32, i32).init(allocator);
  defer map.deinit();
  map.put(k, v) catch unreachable;
  if (map.get(k)) |v| { ... }
  const gop = map.getOrPut(k) catch unreachable;
  if (!gop.found_existing) gop.value_ptr.* = 0;
  gop.value_ptr.* += 1;
  _ = map.remove(k);
  ```
- `std.StringHashMap(V)` is managed with slice keys:
  ```zig
  var m = std.StringHashMap(i32).init(allocator);
  defer m.deinit();
  m.put("apple", 1) catch unreachable;
  if (m.get("apple")) |v| { ... }
  _ = m.remove("apple");
  const n = m.count();
  ```
- Hash-map iteration is supported (keys, values, or entries):
  ```zig
  var it = map.keyIterator();
  while (it.next()) |k| sum += k.*;            // k is *K

  var eit = map.iterator();
  while (eit.next()) |entry| total += entry.value_ptr.*;  // entry.key_ptr / entry.value_ptr
  ```
  `std.ArrayList` iteration is **not** supported — loop over `list.items`.

## Scaffolding

```powershell
node tools\new.js <dir> [--fn name] [--params "a: T, b: T"] [--ret T] [--no-verify]
```

Creates `problems/<dir>/solution.zig` and `driver.c`, prints the C prototype
zig2c emits (compare it against LeetCode's signature), and runs the verifier so
you start from green.

## Supported Zig subset (quick list)

Functions/recursion; integers, floats, `bool`, pointers, slices, `?*T`,
optional values (`?i32` -> a `{ value; has; }` struct), fixed arrays, structs and
struct literals. `var`/`const` with inference, assignment (incl. `+=` etc. and
`a, b = b, a`), `if`/`else if`/`else` (with/without braces, `|capture|`),
`while` (with `: (cont)` and `|capture|`), `for` over ranges/slices/arrays,
`return`, `break`, `continue`, `defer`, `switch` on integers, nested blocks.

Expressions: arithmetic/comparison/bitwise/shifts, `and`/`or`/`!`, `orelse`,
`.?`, `.*`, `&`, indexing, slicing `a..b`, field access, calls, struct/array
literals, `if` expressions, and builtins `@as`, `@intCast`, `@min`, `@max`,
`@abs`, `@sizeOf`, `@ptrCast`, `@alignCast`, `@intFromPtr`, `@ptrFromInt`,
`@truncate`, `@divFloor`, `@divTrunc`, `@mod`, `@memcpy`, `@memset`.

`std` helpers: `std.mem.eql`, `std.mem.sliceTo`, `std.mem.span`, `std.mem.len`,
`std.mem.sort` / `std.sort.pdq`, `std.mem.reverse`, `std.mem.swap`,
`std.mem.copyForwards`, `std.ascii.*`, `std.math.min/max/absInt`,
`std.debug.print`.

Also supported (handy extras): struct fields that are fixed arrays
(`buf: [8]i32`) and `for (x) |v|` over a fixed array; array literals with an
inferred length (`const T = [_]i32{1,2,3};`) at top level or in a body; error
union return types like `fn f() !void` (the error is dropped, so use
`catch return x;` / `catch unreachable`); `if (m.get(k)) |v|` where `m` is a
`std.AutoHashMap` (returns a `?V` value); and passing a container by pointer
(`m: *std.AutoHashMap(K,V)`) to a helper.

`for (0..n) |i|` is **exclusive** (0..n-1). `a.len` on a slice, `a[i]`,
`a[x..y]`. `.ptr` on a slice.

## Not supported (work around it)

- `std.ArrayList` iterators (`list.iterator()`) — iterate `list.items` instead.
- error unions / `try` (use `catch unreachable`); `catch` is ignored.
- `comptime`, generics, `anytype`, tagged unions, `enum` types (use `i32` constants).
- `switch` on strings or with ranges / `else` handling is limited — prefer `if` chains.
- labeled `break :label` — restructure.
- nested functions / closures — hoist them to top level.
- `@memcpy`/`@memset` are fine; overlapping `@memcpy` is not.
- Multi-argument-or-`else` shapes that are unusual.

## Common pitfalls

- Zig often needs a known result type: write `@as(i32, @intCast(x))` rather than
  just `@intCast(x)` in a sub-expression.
- A `?*T` and a `?T` are different in C (NULL pointer vs `{value,has}`). Use
  `?*T` for linked structures.
- Negative modulo: `@mod` is rem-like in the lowering; if you need floor
  semantics use `@divFloor`. Test edge cases.
- `while (cond) : (cond2)` is supported and the continue expression runs on
  `continue` too.
- Characters are `u8`; compare with `'a'` etc. String bytes come from
  `std.mem.sliceTo(s, 0)`.
- For problems where the judge provides a function (e.g. `guess`), declare it
  with `extern fn guess(num: i32) i32;`, skip the Zig `test` block (it cannot
  link), and test only through `driver.c`.

## Definition of done

`node tools\verify.js <name>` prints three green steps. Then report which
problems you finished and anything you could not do.
