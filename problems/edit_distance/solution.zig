// LeetCode 72. Edit Distance
// C signature:  int minDistance(char* word1, char* word2);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn minDistance(word1: [*]u8, word2: [*]u8) i32 {
    const a = std.mem.sliceTo(word1, 0);
    const b = std.mem.sliceTo(word2, 0);
    const m: usize = a.len;
    const n: usize = b.len;
    const w: usize = n + 1;

    const dp = allocator.alloc(i32, (m + 1) * (n + 1)) catch unreachable;

    var i: usize = 0;
    while (i <= m) : (i += 1) dp[i * w] = @as(i32, @intCast(i));
    var j: usize = 0;
    while (j <= n) : (j += 1) dp[j] = @as(i32, @intCast(j));

    i = 1;
    while (i <= m) : (i += 1) {
        j = 1;
        while (j <= n) : (j += 1) {
            if (a[i - 1] == b[j - 1]) {
                dp[i * w + j] = dp[(i - 1) * w + (j - 1)];
            } else {
                const del = dp[(i - 1) * w + j];
                const ins = dp[i * w + (j - 1)];
                const rep = dp[(i - 1) * w + (j - 1)];
                dp[i * w + j] = 1 + @min(@min(del, ins), rep);
            }
        }
    }
    const ans = dp[m * w + n];
    allocator.free(dp);
    return ans;
}

test "minDistance examples" {
    try std.testing.expectEqual(@as(i32, 3), minDistance(@constCast("horse"), @constCast("ros")));
    try std.testing.expectEqual(@as(i32, 5), minDistance(@constCast("intention"), @constCast("execution")));
}

test "minDistance edges" {
    try std.testing.expectEqual(@as(i32, 0), minDistance(@constCast(""), @constCast("")));
    try std.testing.expectEqual(@as(i32, 3), minDistance(@constCast("abc"), @constCast("")));
    try std.testing.expectEqual(@as(i32, 3), minDistance(@constCast(""), @constCast("abc")));
    try std.testing.expectEqual(@as(i32, 0), minDistance(@constCast("abc"), @constCast("abc")));
    try std.testing.expectEqual(@as(i32, 1), minDistance(@constCast("a"), @constCast("b")));
    try std.testing.expectEqual(@as(i32, 3), minDistance(@constCast("kitten"), @constCast("sitting")));
    try std.testing.expectEqual(@as(i32, 0), minDistance(@constCast("aaaa"), @constCast("aaaa")));
}
