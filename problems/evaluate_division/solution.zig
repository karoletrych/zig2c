// LeetCode 399. Evaluate Division
// C signature:  double* calcEquation(char*** equations, int equationsSize, int* equationsColSize,
//                                  double* values, int valuesSize,
//                                  char*** queries, int queriesSize, int* queriesColSize,
//                                  int* returnSize);
//
// The input is tiny (at most 20 equations -> at most 40 distinct names), so the
// names are stored in a flat `char*` table with linear search and the ratios go
// into a dense 64x64 matrix (w[u*64+v] = u/v, -1 when unknown). A query is
// answered by carrying the product of ratios along a BFS path; division is
// invertible so any path gives the same value.
const std = @import("std");
const allocator = std.heap.c_allocator;

const MAXN: i32 = 64;

fn findVar(names: [*][*]u8, count: i32, s: [*]u8) i32 {
    const target = std.mem.sliceTo(s, 0);
    var i: i32 = 0;
    while (i < count) : (i += 1) {
        const cur = std.mem.sliceTo(names[@intCast(i)], 0);
        if (std.mem.eql(u8, cur, target)) return i;
    }
    return -1;
}

pub fn calcEquation(equations: [*][*][*]u8, equationsSize: i32, equationsColSize: [*]i32, values: [*]f64, valuesSize: i32, queries: [*][*][*]u8, queriesSize: i32, queriesColSize: [*]i32, returnSize: *i32) ?[*]f64 {
    _ = equationsColSize;
    _ = valuesSize;
    _ = queriesColSize;

    const names = allocator.alloc([*]u8, MAXN) catch unreachable;
    defer allocator.free(names);
    const w = allocator.alloc(f64, MAXN * MAXN) catch unreachable;
    defer allocator.free(w);

    var z: usize = 0;
    while (z < @as(usize, @intCast(MAXN * MAXN))) : (z += 1) w[z] = -1.0;

    var nvars: i32 = 0;
    var i: i32 = 0;
    while (i < equationsSize) : (i += 1) {
        const a: [*]u8 = equations[@intCast(i)][0];
        const b: [*]u8 = equations[@intCast(i)][1];

        var ia: i32 = findVar(names.ptr, nvars, a);
        if (ia < 0) {
            names[@intCast(nvars)] = a;
            ia = nvars;
            nvars += 1;
        }
        var ib: i32 = findVar(names.ptr, nvars, b);
        if (ib < 0) {
            names[@intCast(nvars)] = b;
            ib = nvars;
            nvars += 1;
        }

        const v: f64 = values[@intCast(i)];
        w[@intCast(ia * MAXN + ib)] = v;
        w[@intCast(ib * MAXN + ia)] = 1.0 / v;
    }

    const out = allocator.alloc(f64, @intCast(queriesSize)) catch unreachable;

    var q: i32 = 0;
    while (q < queriesSize) : (q += 1) {
        const a: [*]u8 = queries[@intCast(q)][0];
        const b: [*]u8 = queries[@intCast(q)][1];
        const ia: i32 = findVar(names.ptr, nvars, a);
        const ib: i32 = findVar(names.ptr, nvars, b);

        if (ia < 0 or ib < 0) {
            out[@intCast(q)] = -1.0;
            continue;
        }
        if (ia == ib) {
            out[@intCast(q)] = 1.0;
            continue;
        }

        var seen: [64]bool = undefined;
        var val: [64]f64 = undefined;
        var queue: [64]i32 = undefined;
        var k: i32 = 0;
        while (k < MAXN) : (k += 1) seen[@intCast(k)] = false;

        var head: i32 = 0;
        var tail: i32 = 1;
        queue[0] = ia;
        seen[@intCast(ia)] = true;
        val[@intCast(ia)] = 1.0;

        while (head < tail) {
            const u: i32 = queue[@intCast(head)];
            head += 1;
            var v: i32 = 0;
            while (v < nvars) : (v += 1) {
                const ratio: f64 = w[@intCast(u * MAXN + v)];
                if (!seen[@intCast(v)] and ratio > 0.0) {
                    seen[@intCast(v)] = true;
                    val[@intCast(v)] = val[@intCast(u)] * ratio;
                    queue[@intCast(tail)] = v;
                    tail += 1;
                }
            }
        }

        if (seen[@intCast(ib)]) {
            out[@intCast(q)] = val[@intCast(ib)];
        } else {
            out[@intCast(q)] = -1.0;
        }
    }

    returnSize.* = queriesSize;
    return out.ptr;
}

test "calcEquation example 1" {
    var e0 = [_][*]u8{ @constCast("a"), @constCast("b") };
    var e1 = [_][*]u8{ @constCast("b"), @constCast("c") };
    var eq = [_][*][*]u8{ &e0, &e1 };
    var ecols = [_]i32{ 2, 2 };
    var vals = [_]f64{ 2.0, 3.0 };

    var q0 = [_][*]u8{ @constCast("a"), @constCast("c") };
    var q1 = [_][*]u8{ @constCast("b"), @constCast("a") };
    var q2 = [_][*]u8{ @constCast("a"), @constCast("e") };
    var q3 = [_][*]u8{ @constCast("a"), @constCast("a") };
    var q4 = [_][*]u8{ @constCast("x"), @constCast("x") };
    var qs = [_][*][*]u8{ &q0, &q1, &q2, &q3, &q4 };
    var qcols = [_]i32{ 2, 2, 2, 2, 2 };

    var rs: i32 = 0;
    const r = calcEquation(&eq, 2, &ecols, &vals, 2, &qs, 5, &qcols, &rs).?;
    try std.testing.expectEqual(@as(i32, 5), rs);
    try std.testing.expectApproxEqAbs(@as(f64, 6.0), r[0], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, 0.5), r[1], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, -1.0), r[2], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, 1.0), r[3], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, -1.0), r[4], 1e-9);
}

test "calcEquation examples 2 and 3" {
    var e0 = [_][*]u8{ @constCast("a"), @constCast("b") };
    var e1 = [_][*]u8{ @constCast("b"), @constCast("c") };
    var e2 = [_][*]u8{ @constCast("bc"), @constCast("cd") };
    var eq = [_][*][*]u8{ &e0, &e1, &e2 };
    var ecols = [_]i32{ 2, 2, 2 };
    var vals = [_]f64{ 1.5, 2.5, 5.0 };

    var q0 = [_][*]u8{ @constCast("a"), @constCast("c") };
    var q1 = [_][*]u8{ @constCast("c"), @constCast("b") };
    var q2 = [_][*]u8{ @constCast("bc"), @constCast("cd") };
    var q3 = [_][*]u8{ @constCast("cd"), @constCast("bc") };
    var qs = [_][*][*]u8{ &q0, &q1, &q2, &q3 };
    var qcols = [_]i32{ 2, 2, 2, 2 };

    var rs: i32 = 0;
    const r = calcEquation(&eq, 3, &ecols, &vals, 3, &qs, 4, &qcols, &rs).?;
    try std.testing.expectEqual(@as(i32, 4), rs);
    try std.testing.expectApproxEqAbs(@as(f64, 3.75), r[0], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, 0.4), r[1], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, 5.0), r[2], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, 0.2), r[3], 1e-9);

    var f0 = [_][*]u8{ @constCast("a"), @constCast("b") };
    var eq2 = [_][*][*]u8{&f0};
    var ecols2 = [_]i32{2};
    var vals2 = [_]f64{0.5};

    var g0 = [_][*]u8{ @constCast("a"), @constCast("b") };
    var g1 = [_][*]u8{ @constCast("b"), @constCast("a") };
    var g2 = [_][*]u8{ @constCast("a"), @constCast("c") };
    var g3 = [_][*]u8{ @constCast("x"), @constCast("y") };
    var qs2 = [_][*][*]u8{ &g0, &g1, &g2, &g3 };
    var qcols2 = [_]i32{ 2, 2, 2, 2 };

    var rs2: i32 = 0;
    const r2 = calcEquation(&eq2, 1, &ecols2, &vals2, 1, &qs2, 4, &qcols2, &rs2).?;
    try std.testing.expectEqual(@as(i32, 4), rs2);
    try std.testing.expectApproxEqAbs(@as(f64, 0.5), r2[0], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, 2.0), r2[1], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, -1.0), r2[2], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, -1.0), r2[3], 1e-9);
}
