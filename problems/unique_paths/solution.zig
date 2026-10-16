// LeetCode 62. Unique Paths
// C signature:  int uniquePaths(int m, int n);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn uniquePaths(m: i32, n: i32) i32 {
    const dp = allocator.alloc(i64, @intCast(n)) catch unreachable;

    var j: i32 = 0;
    while (j < n) : (j += 1) dp[@intCast(j)] = 1;

    var i: i32 = 1;
    while (i < m) : (i += 1) {
        j = 1;
        while (j < n) : (j += 1) {
            dp[@intCast(j)] = dp[@intCast(j)] + dp[@intCast(j - 1)];
        }
    }
    const ans = dp[@intCast(n - 1)];
    allocator.free(dp);
    return @as(i32, @intCast(ans));
}

test "uniquePaths examples" {
    try std.testing.expectEqual(@as(i32, 28), uniquePaths(3, 7));
    try std.testing.expectEqual(@as(i32, 3), uniquePaths(3, 2));
}

test "uniquePaths edges" {
    try std.testing.expectEqual(@as(i32, 1), uniquePaths(1, 1));
    try std.testing.expectEqual(@as(i32, 1), uniquePaths(1, 10));
    try std.testing.expectEqual(@as(i32, 1), uniquePaths(10, 1));
    try std.testing.expectEqual(@as(i32, 48620), uniquePaths(10, 10));
    try std.testing.expectEqual(@as(i32, 40116600), uniquePaths(15, 15));
}
