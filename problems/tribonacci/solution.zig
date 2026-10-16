// LeetCode 1137. N-th Tribonacci Number
// C signature:  int tribonacci(int n);
const std = @import("std");

pub fn tribonacci(n: i32) i32 {
    if (n == 0) return 0;
    if (n == 1) return 1;
    if (n == 2) return 1;

    var a: i64 = 0;
    var b: i64 = 1;
    var c: i64 = 1;
    var i: i32 = 3;
    while (i <= n) : (i += 1) {
        const d = a + b + c;
        a = b;
        b = c;
        c = d;
    }
    return @as(i32, @intCast(c));
}

test "tribonacci examples" {
    try std.testing.expectEqual(@as(i32, 4), tribonacci(4));
    try std.testing.expectEqual(@as(i32, 1389537), tribonacci(25));
}

test "tribonacci edges" {
    try std.testing.expectEqual(@as(i32, 0), tribonacci(0));
    try std.testing.expectEqual(@as(i32, 1), tribonacci(1));
    try std.testing.expectEqual(@as(i32, 1), tribonacci(2));
    try std.testing.expectEqual(@as(i32, 2), tribonacci(3));
    try std.testing.expectEqual(@as(i32, 7), tribonacci(5));
    try std.testing.expectEqual(@as(i32, 149), tribonacci(10));
    try std.testing.expectEqual(@as(i32, 2082876103), tribonacci(37));
}
