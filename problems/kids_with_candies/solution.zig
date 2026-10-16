// LeetCode 1431. Kids With the Greatest Number of Candies
// C signature:  bool* kidsWithCandies(int* candies, int candiesSize, int extraCandies, int* returnSize);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn kidsWithCandies(candies: [*]i32, candiesSize: i32, extraCandies: i32, returnSize: *i32) ?[*]bool {
    const n: usize = @intCast(candiesSize);

    var mx: i32 = 0;
    var i: usize = 0;
    while (i < n) : (i += 1) {
        if (candies[i] > mx) mx = candies[i];
    }

    const out = allocator.alloc(bool, n) catch unreachable;
    i = 0;
    while (i < n) : (i += 1) {
        out[i] = candies[i] + extraCandies >= mx;
    }
    returnSize.* = candiesSize;
    return out.ptr;
}

test "kidsWithCandies examples" {
    var a = [_]i32{ 2, 3, 5, 1, 3 };
    var rs: i32 = 0;
    const r = kidsWithCandies(&a, 5, 3, &rs).?;
    try std.testing.expectEqual(@as(i32, 5), rs);
    try std.testing.expect(r[0]);
    try std.testing.expect(r[1]);
    try std.testing.expect(r[2]);
    try std.testing.expect(!r[3]);
    try std.testing.expect(r[4]);

    var b = [_]i32{ 4, 2, 1, 1, 2 };
    const r2 = kidsWithCandies(&b, 5, 1, &rs).?;
    try std.testing.expect(r2[0]);
    try std.testing.expect(!r2[1]);
    try std.testing.expect(!r2[2]);
    try std.testing.expect(!r2[3]);
    try std.testing.expect(!r2[4]);
}

test "kidsWithCandies edges" {
    var a = [_]i32{ 12, 1, 12 };
    var rs: i32 = 0;
    const r = kidsWithCandies(&a, 3, 10, &rs).?;
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expect(r[0]);
    try std.testing.expect(!r[1]);
    try std.testing.expect(r[2]);

    var b = [_]i32{7};
    const r2 = kidsWithCandies(&b, 1, 0, &rs).?;
    try std.testing.expectEqual(@as(i32, 1), rs);
    try std.testing.expect(r2[0]);
}
