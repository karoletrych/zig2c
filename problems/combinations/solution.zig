// LeetCode 77. Combinations
// C signature:  int** combine(int n, int k, int* returnSize,
//                            int** returnColumnSizes);
//
// The exact number of rows C(n, k) is computed up front (so a single allocation
// suffices) and a DFS emits the combinations in lexicographic order. A branch is
// cut as soon as there are not enough larger values left to fill the row.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn chooseCount(n: i32, k: i32) usize {
    if (k < 0 or k > n) return 0;
    var kk: i32 = k;
    if (kk > n - kk) kk = n - kk;
    var r: u64 = 1;
    var i: i32 = 1;
    while (i <= kk) : (i += 1) {
        r = r * @as(u64, @intCast(n - kk + i)) / @as(u64, @intCast(i));
    }
    return @intCast(r);
}

fn buildCombos(n: i32, k: i32, start: i32, buf: [*]i32, depth: i32, rows: [*][*]i32, cols: [*]i32, count: *i32) void {
    if (depth == k) {
        const ku: usize = @intCast(k);
        const row = allocator.alloc(i32, ku) catch unreachable;
        var i: usize = 0;
        while (i < ku) : (i += 1) row[i] = buf[i];
        rows[@intCast(count.*)] = row.ptr;
        cols[@intCast(count.*)] = k;
        count.* += 1;
        return;
    }
    var v: i32 = start;
    while (v <= n) : (v += 1) {
        if (n - v + 1 < k - depth) break;
        buf[@intCast(depth)] = v;
        buildCombos(n, k, v + 1, buf, depth + 1, rows, cols, count);
    }
}

pub fn combine(n: i32, k: i32, returnSize: *i32, returnColumnSizes: [*][*]i32) ?[*][*]i32 {
    var cap: usize = chooseCount(n, k);
    if (cap == 0) cap = 1;
    var bcap: usize = 1;
    if (k > 0) bcap = @intCast(k);

    const rows = allocator.alloc([*]i32, cap) catch unreachable;
    const cols = allocator.alloc(i32, cap) catch unreachable;
    const buf = allocator.alloc(i32, bcap) catch unreachable;
    defer allocator.free(buf);

    var count: i32 = 0;
    buildCombos(n, k, 1, buf.ptr, 0, rows.ptr, cols.ptr, &count);

    returnColumnSizes[0] = cols.ptr;
    returnSize.* = count;
    return rows.ptr;
}

test "combine examples" {
    var rs: i32 = 0;
    var cb = [_][*]i32{undefined};
    const r = combine(4, 2, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 6), rs);
    try std.testing.expectEqual(@as(i32, 2), cb[0][0]);
    const want = [6][2]i32{
        .{ 1, 2 }, .{ 1, 3 }, .{ 1, 4 }, .{ 2, 3 }, .{ 2, 4 }, .{ 3, 4 },
    };
    var i: usize = 0;
    while (i < 6) : (i += 1) {
        try std.testing.expectEqual(want[i][0], r[i][0]);
        try std.testing.expectEqual(want[i][1], r[i][1]);
    }
}

test "combine edges" {
    // k == n: exactly one row
    var rs: i32 = 0;
    var cb = [_][*]i32{undefined};
    const r = combine(3, 3, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 1), rs);
    try std.testing.expectEqual(@as(i32, 3), cb[0][0]);
    try std.testing.expectEqual(@as(i32, 1), r[0][0]);
    try std.testing.expectEqual(@as(i32, 2), r[0][1]);
    try std.testing.expectEqual(@as(i32, 3), r[0][2]);

    // k == 1
    var rs2: i32 = 0;
    var cb2 = [_][*]i32{undefined};
    const r2 = combine(4, 1, &rs2, &cb2).?;
    try std.testing.expectEqual(@as(i32, 4), rs2);
    var j: usize = 0;
    while (j < 4) : (j += 1) {
        try std.testing.expectEqual(@as(i32, 1), cb2[0][0]);
        try std.testing.expectEqual(@as(i32, @intCast(j + 1)), r2[j][0]);
    }

    // k > n: no rows
    var rs3: i32 = 0;
    var cb3 = [_][*]i32{undefined};
    _ = combine(2, 3, &rs3, &cb3).?;
    try std.testing.expectEqual(@as(i32, 0), rs3);

    // the maximum size for n <= 20
    var rs4: i32 = 0;
    var cb4 = [_][*]i32{undefined};
    _ = combine(20, 10, &rs4, &cb4).?;
    try std.testing.expectEqual(@as(i32, 184756), rs4);
}
