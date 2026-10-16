// LeetCode 1143. Longest Common Subsequence
// C signature:  int longestCommonSubsequence(char* text1, char* text2);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn longestCommonSubsequence(text1: [*]u8, text2: [*]u8) i32 {
    const a = std.mem.sliceTo(text1, 0);
    const b = std.mem.sliceTo(text2, 0);
    const m: usize = a.len;
    const n: usize = b.len;
    const w: usize = n + 1;

    const dp = allocator.alloc(i32, (m + 1) * (n + 1)) catch unreachable;

    var i: usize = 0;
    while (i <= m) : (i += 1) dp[i * w] = 0;
    var j: usize = 0;
    while (j <= n) : (j += 1) dp[j] = 0;

    i = 1;
    while (i <= m) : (i += 1) {
        j = 1;
        while (j <= n) : (j += 1) {
            if (a[i - 1] == b[j - 1]) {
                dp[i * w + j] = dp[(i - 1) * w + (j - 1)] + 1;
            } else {
                const up = dp[(i - 1) * w + j];
                const left = dp[i * w + (j - 1)];
                dp[i * w + j] = @max(up, left);
            }
        }
    }
    const ans = dp[m * w + n];
    allocator.free(dp);
    return ans;
}

test "longestCommonSubsequence examples" {
    try std.testing.expectEqual(@as(i32, 3), longestCommonSubsequence(@constCast("abcde"), @constCast("ace")));
    try std.testing.expectEqual(@as(i32, 3), longestCommonSubsequence(@constCast("abc"), @constCast("abc")));
    try std.testing.expectEqual(@as(i32, 0), longestCommonSubsequence(@constCast("abc"), @constCast("def")));
}

test "longestCommonSubsequence edges" {
    try std.testing.expectEqual(@as(i32, 0), longestCommonSubsequence(@constCast(""), @constCast("")));
    try std.testing.expectEqual(@as(i32, 0), longestCommonSubsequence(@constCast(""), @constCast("abc")));
    try std.testing.expectEqual(@as(i32, 0), longestCommonSubsequence(@constCast("abc"), @constCast("")));
    try std.testing.expectEqual(@as(i32, 1), longestCommonSubsequence(@constCast("a"), @constCast("a")));
    try std.testing.expectEqual(@as(i32, 20), longestCommonSubsequence(@constCast("aaaaaaaaaaaaaaaaaaaa"), @constCast("aaaaaaaaaaaaaaaaaaaa")));
    try std.testing.expectEqual(@as(i32, 4), longestCommonSubsequence(@constCast("abcdefg"), @constCast("bdfg")));
}
