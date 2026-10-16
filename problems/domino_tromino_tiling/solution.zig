// LeetCode 790. Domino and Tromino Tiling
// C signature:  int numTilings(int n);
const std = @import("std");

const MOD: i64 = 1000000007;

pub fn numTilings(n: i32) i32 {
    if (n == 0) return 1;
    if (n == 1) return 1;
    if (n == 2) return 2;

    var d0: i64 = 1; // dp[n-3]
    var d1: i64 = 1; // dp[n-2]
    var d2: i64 = 2; // dp[n-1]
    var i: i32 = 3;
    while (i <= n) : (i += 1) {
        const d3 = @mod(2 * d2 + d0, MOD);
        d0 = d1;
        d1 = d2;
        d2 = d3;
    }
    return @as(i32, @intCast(d2));
}

test "numTilings examples" {
    try std.testing.expectEqual(@as(i32, 5), numTilings(3));
    try std.testing.expectEqual(@as(i32, 11), numTilings(4));
    try std.testing.expectEqual(@as(i32, 24), numTilings(5));
    try std.testing.expectEqual(@as(i32, 312342182), numTilings(30));
}

test "numTilings edges" {
    try std.testing.expectEqual(@as(i32, 1), numTilings(0));
    try std.testing.expectEqual(@as(i32, 1), numTilings(1));
    try std.testing.expectEqual(@as(i32, 2), numTilings(2));
}
