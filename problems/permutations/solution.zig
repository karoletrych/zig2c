// LeetCode 46. Permutations
// C signature:  int** permute(int* nums, int numsSize, int* returnSize,
//                             int** returnColumnSizes);
//
// n! rows are allocated up front and a DFS over the unused positions fills them
// in lexicographic order (by position, not by value).
const std = @import("std");
const allocator = std.heap.c_allocator;

fn factorialCount(n: i32) usize {
    var r: usize = 1;
    var i: i32 = 2;
    while (i <= n) : (i += 1) r *= @intCast(i);
    return r;
}

fn buildPerms(nums: [*]i32, n: i32, used: [*]bool, buf: [*]i32, depth: i32, rows: [*][*]i32, cols: [*]i32, count: *i32) void {
    if (depth == n) {
        const nu: usize = @intCast(n);
        const row = allocator.alloc(i32, nu) catch unreachable;
        var i: usize = 0;
        while (i < nu) : (i += 1) row[i] = buf[i];
        rows[@intCast(count.*)] = row.ptr;
        cols[@intCast(count.*)] = n;
        count.* += 1;
        return;
    }
    var i: i32 = 0;
    while (i < n) : (i += 1) {
        if (used[@intCast(i)]) continue;
        used[@intCast(i)] = true;
        buf[@intCast(depth)] = nums[@intCast(i)];
        buildPerms(nums, n, used, buf, depth + 1, rows, cols, count);
        used[@intCast(i)] = false;
    }
}

pub fn permute(nums: [*]i32, numsSize: i32, returnSize: *i32, returnColumnSizes: [*][*]i32) ?[*][*]i32 {
    const n: usize = @intCast(numsSize);
    var cap: usize = factorialCount(numsSize);
    if (cap == 0) cap = 1;
    var bcap: usize = 1;
    if (numsSize > 0) bcap = n;

    const rows = allocator.alloc([*]i32, cap) catch unreachable;
    const cols = allocator.alloc(i32, cap) catch unreachable;
    const used = allocator.alloc(bool, n) catch unreachable;
    const buf = allocator.alloc(i32, bcap) catch unreachable;
    defer allocator.free(used);
    defer allocator.free(buf);

    var i: usize = 0;
    while (i < n) : (i += 1) used[i] = false;

    var count: i32 = 0;
    buildPerms(nums, numsSize, used.ptr, buf.ptr, 0, rows.ptr, cols.ptr, &count);

    returnColumnSizes[0] = cols.ptr;
    returnSize.* = count;
    return rows.ptr;
}

test "permute examples" {
    var nums = [_]i32{ 1, 2, 3 };
    var rs: i32 = 0;
    var cb = [_][*]i32{undefined};
    const r = permute(&nums, 3, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 6), rs);
    try std.testing.expectEqual(@as(i32, 3), cb[0][0]);
    const want = [6][3]i32{
        .{ 1, 2, 3 }, .{ 1, 3, 2 }, .{ 2, 1, 3 },
        .{ 2, 3, 1 }, .{ 3, 1, 2 }, .{ 3, 2, 1 },
    };
    var i: usize = 0;
    while (i < 6) : (i += 1) {
        var j: usize = 0;
        while (j < 3) : (j += 1) try std.testing.expectEqual(want[i][j], r[i][j]);
    }
}

test "permute edges" {
    var one = [_]i32{7};
    var rs: i32 = 0;
    var cb = [_][*]i32{undefined};
    const r = permute(&one, 1, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 1), rs);
    try std.testing.expectEqual(@as(i32, 1), cb[0][0]);
    try std.testing.expectEqual(@as(i32, 7), r[0][0]);

    // negative values keep their signs
    var two = [_]i32{ -1, 2 };
    var rs2: i32 = 0;
    var cb2 = [_][*]i32{undefined};
    const r2 = permute(&two, 2, &rs2, &cb2).?;
    try std.testing.expectEqual(@as(i32, 2), rs2);
    try std.testing.expectEqual(@as(i32, 2), cb2[0][0]);
    try std.testing.expectEqual(@as(i32, -1), r2[0][0]);
    try std.testing.expectEqual(@as(i32, 2), r2[0][1]);
    try std.testing.expectEqual(@as(i32, 2), r2[1][0]);
    try std.testing.expectEqual(@as(i32, -1), r2[1][1]);

    // 5! = 120
    var five = [_]i32{ 1, 2, 3, 4, 5 };
    var rs3: i32 = 0;
    var cb3 = [_][*]i32{undefined};
    const r3 = permute(&five, 5, &rs3, &cb3).?;
    try std.testing.expectEqual(@as(i32, 120), rs3);
    try std.testing.expectEqual(@as(i32, 5), cb3[0][0]);
    // first row is the input order, last row is reversed
    try std.testing.expectEqual(@as(i32, 1), r3[0][0]);
    try std.testing.expectEqual(@as(i32, 5), r3[@intCast(rs3 - 1)][0]);
}
