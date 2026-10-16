// LeetCode 97. Interleaving String
// C signature:  bool isInterleave(char* s1, char* s2, char* s3);
//
// dp[j] = "s1[0..i] and s2[0..j] can interleave into s3[0..i+j]". The row is
// rolled over: fromA reads the old dp[j] (before it is overwritten), fromB the
// freshly written dp[j - 1]. Lengths must add up first.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn isInterleave(s1: [*]u8, s2: [*]u8, s3: [*]u8) bool {
    const a = std.mem.sliceTo(s1, 0);
    const b = std.mem.sliceTo(s2, 0);
    const c = std.mem.sliceTo(s3, 0);
    const n: usize = a.len;
    const m: usize = b.len;
    if (n + m != c.len) return false;

    const dp = allocator.alloc(bool, m + 1) catch unreachable;
    defer allocator.free(dp);

    dp[0] = true;
    var j: usize = 1;
    while (j <= m) : (j += 1) {
        dp[j] = dp[j - 1] and b[j - 1] == c[j - 1];
    }

    var i: usize = 1;
    while (i <= n) : (i += 1) {
        dp[0] = dp[0] and a[i - 1] == c[i - 1];
        j = 1;
        while (j <= m) : (j += 1) {
            const fromA = dp[j] and a[i - 1] == c[i + j - 1];
            const fromB = dp[j - 1] and b[j - 1] == c[i + j - 1];
            dp[j] = fromA or fromB;
        }
    }
    return dp[m];
}

test "isInterleave examples" {
    try std.testing.expect(isInterleave(@constCast("aabcc"), @constCast("dbbca"), @constCast("aadbbcbcac")));
    try std.testing.expect(!isInterleave(@constCast("aabcc"), @constCast("dbbca"), @constCast("aadbbbaccc")));
}

test "isInterleave edges" {
    // all empty
    try std.testing.expect(isInterleave(@constCast(""), @constCast(""), @constCast("")));

    // one side empty, exact match and mismatch
    try std.testing.expect(isInterleave(@constCast("abc"), @constCast(""), @constCast("abc")));
    try std.testing.expect(!isInterleave(@constCast("abc"), @constCast(""), @constCast("abd")));
    try std.testing.expect(isInterleave(@constCast(""), @constCast("xyz"), @constCast("xyz")));

    // s3 length does not match
    try std.testing.expect(!isInterleave(@constCast("a"), @constCast("b"), @constCast("abc")));
    try std.testing.expect(!isInterleave(@constCast("ab"), @constCast("bc"), @constCast("babcx")));

    // singleton pieces
    try std.testing.expect(isInterleave(@constCast("a"), @constCast("b"), @constCast("ab")));
    try std.testing.expect(isInterleave(@constCast("a"), @constCast("b"), @constCast("ba")));
    try std.testing.expect(!isInterleave(@constCast("a"), @constCast("b"), @constCast("aa")));

    // interleaving order matters
    try std.testing.expect(isInterleave(@constCast("ab"), @constCast("bc"), @constCast("babc")));
    // `badc` needs `b` from s1 before its leading `a`, so it cannot interleave
    try std.testing.expect(!isInterleave(@constCast("ab"), @constCast("cd"), @constCast("badc")));
}
