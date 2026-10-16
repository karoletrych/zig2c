// LeetCode 50. Pow(x, n)
// C signature:  double myPow(double x, int n);
//
// Fast exponentiation. The exponent is held in an i64 so that INT_MIN can be
// negated safely, and a negative exponent becomes 1/x.
const std = @import("std");

pub fn myPow(x: f64, n: i32) f64 {
    var e: i64 = @as(i64, n);
    var base: f64 = x;
    if (e < 0) {
        e = -e;
        base = 1.0 / x;
    }
    var result: f64 = 1.0;
    while (e > 0) {
        if (@mod(e, 2) == 1) result *= base;
        base *= base;
        e = @divTrunc(e, 2);
    }
    return result;
}

test "myPow examples" {
    try std.testing.expect(myPow(2.0, 10) == 1024.0);
    try std.testing.expect(@abs(myPow(2.1, 3) - 9.261) < 1e-9);
    try std.testing.expect(myPow(2.0, -2) == 0.25);
}

test "myPow edges" {
    try std.testing.expect(myPow(5.0, 0) == 1.0);
    try std.testing.expect(myPow(-2.0, 3) == -8.0);
    try std.testing.expect(myPow(-2.0, 2) == 4.0);
    try std.testing.expect(myPow(1.0, 2147483647) == 1.0);
    try std.testing.expect(myPow(1.0, -2147483648) == 1.0);
    try std.testing.expect(myPow(2.0, 2147483647) > 0.0);
    try std.testing.expect(myPow(2.0, -2147483648) == 0.0);
    try std.testing.expect(@abs(myPow(0.5, 3) - 0.125) < 1e-12);
}
