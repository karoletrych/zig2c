// LeetCode 746. Min Cost Climbing Stairs
// C signature:  int minCostClimbingStairs(int* cost, int costSize);
const std = @import("std");

pub fn minCostClimbingStairs(cost: [*]i32, costSize: i32) i32 {
    var prev2: i32 = 0; // dp[i-2]
    var prev1: i32 = 0; // dp[i-1]
    var i: i32 = 2;
    while (i <= costSize) : (i += 1) {
        const from1 = prev1 + cost[@intCast(i - 1)];
        const from2 = prev2 + cost[@intCast(i - 2)];
        const cur = @min(from1, from2);
        prev2 = prev1;
        prev1 = cur;
    }
    return prev1;
}

test "minCostClimbingStairs examples" {
    var a = [_]i32{ 10, 15, 20 };
    try std.testing.expectEqual(@as(i32, 15), minCostClimbingStairs(&a, 3));

    var b = [_]i32{ 1, 100, 1, 1, 1, 100, 1, 1, 100, 1 };
    try std.testing.expectEqual(@as(i32, 6), minCostClimbingStairs(&b, 10));
}

test "minCostClimbingStairs edges" {
    var z = [_]i32{ 0, 0 };
    try std.testing.expectEqual(@as(i32, 0), minCostClimbingStairs(&z, 2));

    var s = [_]i32{ 5, 5 };
    try std.testing.expectEqual(@as(i32, 5), minCostClimbingStairs(&s, 2));

    var c = [_]i32{ 1, 2, 3 };
    try std.testing.expectEqual(@as(i32, 2), minCostClimbingStairs(&c, 3));
}
