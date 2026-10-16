// LeetCode 70. Climbing Stairs
// C signature:  int climbStairs(int n);
//
// Number of ways is the Fibonacci sequence F(n+1); only the last two values
// are needed.
const std = @import("std");

pub fn climbStairs(n: i32) i32 {
    if (n <= 2) return n;
    var a: i32 = 1;
    var b: i32 = 2;
    var i: i32 = 3;
    while (i <= n) : (i += 1) {
        const c = a + b;
        a = b;
        b = c;
    }
    return b;
}

test "climbStairs examples" {
    try std.testing.expectEqual(@as(i32, 2), climbStairs(2));
    try std.testing.expectEqual(@as(i32, 3), climbStairs(3));
}

test "climbStairs edges" {
    try std.testing.expectEqual(@as(i32, 1), climbStairs(1));
    try std.testing.expectEqual(@as(i32, 5), climbStairs(4));
    try std.testing.expectEqual(@as(i32, 8), climbStairs(5));
    try std.testing.expectEqual(@as(i32, 89), climbStairs(10));
    try std.testing.expectEqual(@as(i32, 1836311903), climbStairs(45));
}
