// LeetCode 216. Combination Sum III
// C signature:  int** combinationSum3(int k, int n, int* returnSize,
//                                    int** returnColumnSizes);
//
// DFS over the digits 1..9 in increasing order; a leaf at depth k with no
// remaining sum is a valid combination. Every row therefore has length k.
const std = @import("std");
const allocator = std.heap.c_allocator;

const MAX_ROWS: usize = 200;

fn dfs(next: i32, k: i32, remaining: i32, buf: [*]i32, depth: i32, rows: [*][*]i32, cols: [*]i32, count: *i32) void {
    if (depth == k) {
        if (remaining == 0) {
            const row = allocator.alloc(i32, @intCast(k)) catch unreachable;
            var i: usize = 0;
            while (i < @as(usize, @intCast(k))) : (i += 1) row[i] = buf[i];
            rows[@intCast(count.*)] = row.ptr;
            cols[@intCast(count.*)] = k;
            count.* += 1;
        }
        return;
    }
    var v: i32 = next;
    while (v <= 9) : (v += 1) {
        if (v > remaining) break;
        buf[@intCast(depth)] = v;
        dfs(v + 1, k, remaining - v, buf, depth + 1, rows, cols, count);
    }
}

pub fn combinationSum3(k: i32, n: i32, returnSize: *i32, returnColumnSizes: [*][*]i32) ?[*][*]i32 {
    const rows = allocator.alloc([*]i32, MAX_ROWS) catch unreachable;
    const cols = allocator.alloc(i32, MAX_ROWS) catch unreachable;
    const buf = allocator.alloc(i32, 16) catch unreachable;

    var count: i32 = 0;
    dfs(1, k, n, buf.ptr, 0, rows.ptr, cols.ptr, &count);

    returnColumnSizes[0] = cols.ptr;
    returnSize.* = count;
    return rows.ptr;
}

test "combinationSum3 examples" {
    var rs: i32 = 0;
    var cb = [_][*]i32{undefined};
    const r = combinationSum3(3, 7, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 1), rs);
    try std.testing.expectEqual(@as(i32, 3), cb[0][0]);
    try std.testing.expectEqual(@as(i32, 1), r[0][0]);
    try std.testing.expectEqual(@as(i32, 2), r[0][1]);
    try std.testing.expectEqual(@as(i32, 4), r[0][2]);

    var rs2: i32 = 0;
    var cb2 = [_][*]i32{undefined};
    const r2 = combinationSum3(3, 9, &rs2, &cb2).?;
    try std.testing.expectEqual(@as(i32, 3), rs2);
    try std.testing.expectEqual(@as(i32, 3), cb2[0][0]);
    try std.testing.expectEqual(@as(i32, 1), r2[0][0]);
    try std.testing.expectEqual(@as(i32, 2), r2[0][1]);
    try std.testing.expectEqual(@as(i32, 6), r2[0][2]);
    try std.testing.expectEqual(@as(i32, 1), r2[1][0]);
    try std.testing.expectEqual(@as(i32, 3), r2[1][1]);
    try std.testing.expectEqual(@as(i32, 5), r2[1][2]);
    try std.testing.expectEqual(@as(i32, 2), r2[2][0]);
    try std.testing.expectEqual(@as(i32, 3), r2[2][1]);
    try std.testing.expectEqual(@as(i32, 4), r2[2][2]);
}

test "combinationSum3 edges" {
    var rs: i32 = 0;
    var cb = [_][*]i32{undefined};
    _ = combinationSum3(4, 1, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 0), rs);

    var rs2: i32 = 0;
    var cb2 = [_][*]i32{undefined};
    _ = combinationSum3(2, 18, &rs2, &cb2).?;
    try std.testing.expectEqual(@as(i32, 0), rs2);

    // only 1..9 are available: 1+2+...+9 = 45
    var rs3: i32 = 0;
    var cb3 = [_][*]i32{undefined};
    const r3 = combinationSum3(9, 45, &rs3, &cb3).?;
    try std.testing.expectEqual(@as(i32, 1), rs3);
    try std.testing.expectEqual(@as(i32, 9), cb3[0][0]);
    var q: usize = 0;
    while (q < 9) : (q += 1) try std.testing.expectEqual(@as(i32, @intCast(q + 1)), r3[0][q]);

    // C(9,4) = 126 rows is the maximum
    var rs4: i32 = 0;
    var cb4 = [_][*]i32{undefined};
    const r4 = combinationSum3(4, 20, &rs4, &cb4).?;
    try std.testing.expectEqual(@as(i32, 12), rs4);
    try std.testing.expectEqual(@as(i32, 4), cb4[0][0]);
    try std.testing.expectEqual(@as(i32, 1), r4[0][0]);
    try std.testing.expectEqual(@as(i32, 2), r4[0][1]);
    try std.testing.expectEqual(@as(i32, 8), r4[0][2]);
    try std.testing.expectEqual(@as(i32, 9), r4[0][3]);
}
