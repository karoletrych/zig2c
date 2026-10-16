// LeetCode 338. Counting Bits
// C signature:  int* countBits(int n, int* returnSize);
//
// out[i] = out[i >> 1] + (i & 1): popcount(i) is popcount(i/2) plus the low bit.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn countBits(n: i32, returnSize: *i32) ?[*]i32 {
    const total: usize = @intCast(n + 1);
    const out = allocator.alloc(i32, total) catch unreachable;

    out[0] = 0;
    var i: usize = 1;
    const limit: usize = @intCast(n);
    while (i <= limit) : (i += 1) {
        out[i] = out[i >> 1] + @as(i32, @intCast(i & 1));
    }

    returnSize.* = n + 1;
    return out.ptr;
}

test "countBits examples" {
    var rs: i32 = 0;
    const r = countBits(5, &rs).?;
    try std.testing.expectEqual(@as(i32, 6), rs);
    try std.testing.expectEqual(@as(i32, 0), r[0]);
    try std.testing.expectEqual(@as(i32, 1), r[1]);
    try std.testing.expectEqual(@as(i32, 1), r[2]);
    try std.testing.expectEqual(@as(i32, 2), r[3]);
    try std.testing.expectEqual(@as(i32, 1), r[4]);
    try std.testing.expectEqual(@as(i32, 2), r[5]);
}

test "countBits edges" {
    var rs: i32 = 0;
    const z = countBits(0, &rs).?;
    try std.testing.expectEqual(@as(i32, 1), rs);
    try std.testing.expectEqual(@as(i32, 0), z[0]);

    rs = 0;
    const one = countBits(1, &rs).?;
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, 0), one[0]);
    try std.testing.expectEqual(@as(i32, 1), one[1]);

    rs = 0;
    const r2 = countBits(2, &rs).?;
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqual(@as(i32, 1), r2[2]);
}
