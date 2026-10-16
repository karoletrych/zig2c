// LeetCode 172. Factorial Trailing Zeroes
// C signature:  int trailingZeroes(int n);
//
// A trailing zero comes from a factor 5 paired with a factor 2; twos are
// plentiful, so just count the factors of 5 in n! with the legendre sum.
const std = @import("std");

pub fn trailingZeroes(n: i32) i32 {
    var count: i32 = 0;
    const nn: i64 = @as(i64, n);
    var p: i64 = 5;
    while (p <= nn) : (p *= 5) {
        count += @as(i32, @intCast(@divTrunc(nn, p)));
    }
    return count;
}

test "trailingZeroes examples" {
    try std.testing.expectEqual(@as(i32, 0), trailingZeroes(3));
    try std.testing.expectEqual(@as(i32, 1), trailingZeroes(5));
    try std.testing.expectEqual(@as(i32, 0), trailingZeroes(0));
}

test "trailingZeroes edges" {
    try std.testing.expectEqual(@as(i32, 2), trailingZeroes(10));
    try std.testing.expectEqual(@as(i32, 6), trailingZeroes(25));
    try std.testing.expectEqual(@as(i32, 7), trailingZeroes(30));
    try std.testing.expectEqual(@as(i32, 24), trailingZeroes(100));
    try std.testing.expectEqual(@as(i32, 249), trailingZeroes(1000));
    try std.testing.expectEqual(@as(i32, 2499), trailingZeroes(10000));
}
