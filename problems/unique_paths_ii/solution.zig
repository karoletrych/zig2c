// LeetCode 63. Unique Paths II
// C signature:  int uniquePathsWithObstacles(int** obstacleGrid, int obstacleGridSize, int* obstacleGridColSize);
//
// One-dimensional DP of path counts. A cell holding an obstacle resets its
// count to zero; otherwise it accumulates the count from above and from the
// left. Counts are kept in 64-bit so intermediate sums cannot overflow.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn uniquePathsWithObstacles(obstacleGrid: [*][*]i32, obstacleGridSize: i32, obstacleGridColSize: [*]i32) i32 {
    if (obstacleGridSize == 0) return 0;
    const m: usize = @intCast(obstacleGridSize);
    const n: usize = @intCast(obstacleGridColSize[0]);
    if (n == 0) return 0;

    const dp = allocator.alloc(i64, n) catch unreachable;
    var j: usize = 0;
    while (j < n) : (j += 1) dp[j] = 0;

    j = 0;
    while (j < n) : (j += 1) {
        if (obstacleGrid[0][j] == 1) break;
        dp[j] = 1;
    }

    var i: usize = 1;
    while (i < m) : (i += 1) {
        if (obstacleGrid[i][0] == 1) dp[0] = 0;
        j = 1;
        while (j < n) : (j += 1) {
            if (obstacleGrid[i][j] == 1) {
                dp[j] = 0;
            } else {
                dp[j] = dp[j] + dp[j - 1];
            }
        }
    }

    const ans = dp[n - 1];
    allocator.free(dp);
    return @as(i32, @intCast(ans));
}

test "uniquePathsWithObstacles examples" {
    var r0 = [_]i32{ 0, 0, 0 };
    var r1 = [_]i32{ 0, 1, 0 };
    var r2 = [_]i32{ 0, 0, 0 };
    var g = [_][*]i32{ &r0, &r1, &r2 };
    var cols = [_]i32{ 3, 3, 3 };
    try std.testing.expectEqual(@as(i32, 2), uniquePathsWithObstacles(&g, 3, &cols));

    var s0 = [_]i32{ 0, 1 };
    var s1 = [_]i32{ 0, 0 };
    var g2 = [_][*]i32{ &s0, &s1 };
    var c2 = [_]i32{ 2, 2 };
    try std.testing.expectEqual(@as(i32, 1), uniquePathsWithObstacles(&g2, 2, &c2));
}

test "uniquePathsWithObstacles edges" {
    var a0 = [_]i32{0};
    var g1 = [_][*]i32{&a0};
    var c1 = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 1), uniquePathsWithObstacles(&g1, 1, &c1));

    var b0 = [_]i32{1};
    var g2 = [_][*]i32{&b0};
    var c2 = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 0), uniquePathsWithObstacles(&g2, 1, &c2));

    var d0 = [_]i32{ 1, 0 };
    var g3 = [_][*]i32{&d0};
    var c3 = [_]i32{2};
    try std.testing.expectEqual(@as(i32, 0), uniquePathsWithObstacles(&g3, 1, &c3));

    var e0 = [_]i32{ 0, 0 };
    var g4 = [_][*]i32{&e0};
    var c4 = [_]i32{2};
    try std.testing.expectEqual(@as(i32, 1), uniquePathsWithObstacles(&g4, 1, &c4));

    var f0 = [_]i32{ 1, 0 };
    var f1 = [_]i32{ 0, 0 };
    var g5 = [_][*]i32{ &f0, &f1 };
    var c5 = [_]i32{ 2, 2 };
    try std.testing.expectEqual(@as(i32, 0), uniquePathsWithObstacles(&g5, 2, &c5));

    var h0 = [_]i32{ 0, 0 };
    var h1 = [_]i32{ 1, 0 };
    var h2 = [_]i32{ 0, 0 };
    var g6 = [_][*]i32{ &h0, &h1, &h2 };
    var c6 = [_]i32{ 2, 2, 2 };
    try std.testing.expectEqual(@as(i32, 1), uniquePathsWithObstacles(&g6, 3, &c6));
}
