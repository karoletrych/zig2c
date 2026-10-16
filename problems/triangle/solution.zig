// LeetCode 120. Triangle
// C signature:  int minimumTotal(int** triangle, int triangleSize, int* triangleColSize);
//
// Bottom-up DP on one row: start from the last row and repeatedly replace
// dp[j] with triangle[row][j] + min(dp[j], dp[j+1]).
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn minimumTotal(triangle: [*][*]i32, triangleSize: i32, triangleColSize: [*]i32) i32 {
    _ = triangleColSize;
    if (triangleSize == 0) return 0;
    const n: usize = @intCast(triangleSize);

    const dp = allocator.alloc(i32, n) catch unreachable;
    const lastRow: usize = n - 1;
    var j: usize = 0;
    while (j <= lastRow) : (j += 1) dp[j] = triangle[lastRow][j];

    var i: usize = lastRow;
    while (i > 0) : (i -= 1) {
        const row = i - 1;
        j = 0;
        while (j <= row) : (j += 1) {
            dp[j] = triangle[row][j] + @min(dp[j], dp[j + 1]);
        }
    }

    const ans = dp[0];
    allocator.free(dp);
    return ans;
}

test "minimumTotal examples" {
    var r0 = [_]i32{2};
    var r1 = [_]i32{ 3, 4 };
    var r2 = [_]i32{ 6, 5, 7 };
    var r3 = [_]i32{ 4, 1, 8, 3 };
    var t = [_][*]i32{ &r0, &r1, &r2, &r3 };
    var cols = [_]i32{ 1, 2, 3, 4 };
    try std.testing.expectEqual(@as(i32, 11), minimumTotal(&t, 4, &cols));
}

test "minimumTotal edges" {
    var r0 = [_]i32{-10};
    var t1 = [_][*]i32{&r0};
    var c1 = [_]i32{1};
    try std.testing.expectEqual(@as(i32, -10), minimumTotal(&t1, 1, &c1));

    var a0 = [_]i32{-1};
    var a1 = [_]i32{ 2, 3 };
    var a2 = [_]i32{ 1, -1, -3 };
    var t2 = [_][*]i32{ &a0, &a1, &a2 };
    var c2 = [_]i32{ 1, 2, 3 };
    try std.testing.expectEqual(@as(i32, -1), minimumTotal(&t2, 3, &c2));

    var b0 = [_]i32{1};
    var b1 = [_]i32{ 1, 1 };
    var t3 = [_][*]i32{ &b0, &b1 };
    var c3 = [_]i32{ 1, 2 };
    try std.testing.expectEqual(@as(i32, 2), minimumTotal(&t3, 2, &c3));
}
