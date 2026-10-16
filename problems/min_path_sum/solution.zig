// LeetCode 64. Minimum Path Sum
// C signature:  int minPathSum(int** grid, int gridSize, int* gridColSize);
//
// One-dimensional DP: dp[j] is the cost to reach the current row's column j,
// taking the better of "came from above" and "came from the left".
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn minPathSum(grid: [*][*]i32, gridSize: i32, gridColSize: [*]i32) i32 {
    if (gridSize == 0) return 0;
    const m: usize = @intCast(gridSize);
    const n: usize = @intCast(gridColSize[0]);
    if (n == 0) return 0;

    const dp = allocator.alloc(i32, n) catch unreachable;
    var j: usize = 0;
    while (j < n) : (j += 1) {
        if (j == 0) {
            dp[0] = grid[0][0];
        } else {
            dp[j] = dp[j - 1] + grid[0][j];
        }
    }

    var i: usize = 1;
    while (i < m) : (i += 1) {
        dp[0] = dp[0] + grid[i][0];
        j = 1;
        while (j < n) : (j += 1) {
            dp[j] = @min(dp[j], dp[j - 1]) + grid[i][j];
        }
    }

    const ans = dp[n - 1];
    allocator.free(dp);
    return ans;
}

test "minPathSum examples" {
    var r0 = [_]i32{ 1, 3, 1 };
    var r1 = [_]i32{ 1, 5, 1 };
    var r2 = [_]i32{ 4, 2, 1 };
    var g = [_][*]i32{ &r0, &r1, &r2 };
    var cols = [_]i32{ 3, 3, 3 };
    try std.testing.expectEqual(@as(i32, 7), minPathSum(&g, 3, &cols));

    var s0 = [_]i32{ 1, 2, 3 };
    var s1 = [_]i32{ 4, 5, 6 };
    var g2 = [_][*]i32{ &s0, &s1 };
    var c2 = [_]i32{ 3, 3 };
    try std.testing.expectEqual(@as(i32, 12), minPathSum(&g2, 2, &c2));
}

test "minPathSum edges" {
    var a0 = [_]i32{1};
    var g1 = [_][*]i32{&a0};
    var c1 = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 1), minPathSum(&g1, 1, &c1));

    var b0 = [_]i32{ 5, 6, 7 };
    var g2 = [_][*]i32{&b0};
    var c2 = [_]i32{3};
    try std.testing.expectEqual(@as(i32, 18), minPathSum(&g2, 1, &c2));

    var d0 = [_]i32{5};
    var d1 = [_]i32{6};
    var d2 = [_]i32{7};
    var g3 = [_][*]i32{ &d0, &d1, &d2 };
    var c3 = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 18), minPathSum(&g3, 3, &c3));

    var e0 = [_]i32{ 0, 0 };
    var e1 = [_]i32{ 0, 0 };
    var g4 = [_][*]i32{ &e0, &e1 };
    var c4 = [_]i32{ 2, 2 };
    try std.testing.expectEqual(@as(i32, 0), minPathSum(&g4, 2, &c4));
}
