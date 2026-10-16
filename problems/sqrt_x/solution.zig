// LeetCode 69. Sqrt(x)
// C signature:  int mySqrt(int x);
//
// Binary search for the largest mid with mid*mid <= x. The product is done in
// 64-bit so it cannot overflow.
const std = @import("std");

pub fn mySqrt(x: i32) i32 {
    if (x < 2) return x;
    var lo: i64 = 1;
    var hi: i64 = x;
    const target: i64 = @as(i64, x);
    while (lo <= hi) {
        const mid = lo + @divTrunc(hi - lo, 2);
        if (mid * mid <= target) {
            lo = mid + 1;
        } else {
            hi = mid - 1;
        }
    }
    return @as(i32, @intCast(hi));
}

test "mySqrt examples" {
    try std.testing.expectEqual(@as(i32, 2), mySqrt(4));
    try std.testing.expectEqual(@as(i32, 2), mySqrt(8));
}

test "mySqrt edges" {
    try std.testing.expectEqual(@as(i32, 0), mySqrt(0));
    try std.testing.expectEqual(@as(i32, 1), mySqrt(1));
    try std.testing.expectEqual(@as(i32, 1), mySqrt(2));
    try std.testing.expectEqual(@as(i32, 1), mySqrt(3));
    try std.testing.expectEqual(@as(i32, 3), mySqrt(9));
    try std.testing.expectEqual(@as(i32, 3), mySqrt(15));
    try std.testing.expectEqual(@as(i32, 4), mySqrt(16));
    try std.testing.expectEqual(@as(i32, 46339), mySqrt(2147395599));
    try std.testing.expectEqual(@as(i32, 46340), mySqrt(2147483647));
}
