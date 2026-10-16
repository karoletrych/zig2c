// LeetCode 139. Word Break
// C signature:  bool wordBreak(char* s, char** wordDict, int wordDictSize);
//
// dp[i] is true when the first i characters can be segmented. For every i try
// each dictionary word as the final piece.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn wordBreak(s: [*]u8, wordDict: [*][*]u8, wordDictSize: i32) bool {
    const str = std.mem.sliceTo(s, 0);
    const n = str.len;

    const dp = allocator.alloc(bool, n + 1) catch unreachable;
    var i: usize = 0;
    while (i <= n) : (i += 1) dp[i] = false;
    dp[0] = true;

    i = 1;
    while (i <= n) : (i += 1) {
        var w: i32 = 0;
        while (w < wordDictSize) : (w += 1) {
            const word = std.mem.sliceTo(wordDict[@intCast(w)], 0);
            const wl = word.len;
            if (wl <= i and dp[i - wl]) {
                if (std.mem.eql(u8, str[i - wl .. i], word)) {
                    dp[i] = true;
                    break;
                }
            }
        }
    }

    const ans = dp[n];
    allocator.free(dp);
    return ans;
}

test "wordBreak examples" {
    var d = [_][*]u8{ @constCast("leet"), @constCast("code") };
    try std.testing.expect(wordBreak(@constCast("leetcode"), &d, 2));

    var e = [_][*]u8{ @constCast("apple"), @constCast("pen") };
    try std.testing.expect(wordBreak(@constCast("applepenapple"), &e, 2));

    var f = [_][*]u8{ @constCast("cats"), @constCast("dog"), @constCast("sand"), @constCast("and"), @constCast("cat") };
    try std.testing.expect(!wordBreak(@constCast("catsandog"), &f, 5));
}

test "wordBreak edges" {
    var a = [_][*]u8{@constCast("a")};
    try std.testing.expect(wordBreak(@constCast("a"), &a, 1));

    var b = [_][*]u8{@constCast("b")};
    try std.testing.expect(!wordBreak(@constCast("a"), &b, 1));

    var c = [_][*]u8{ @constCast("aaaa"), @constCast("aaa") };
    try std.testing.expect(wordBreak(@constCast("aaaaaaa"), &c, 2));

    var g = [_][*]u8{ @constCast("ab"), @constCast("cd") };
    try std.testing.expect(wordBreak(@constCast("abcd"), &g, 2));
    try std.testing.expect(!wordBreak(@constCast("abcde"), &g, 2));

    var h = [_][*]u8{@constCast("")};
    try std.testing.expect(wordBreak(@constCast(""), &h, 1));

    var none: [1][*]u8 = undefined;
    try std.testing.expect(!wordBreak(@constCast("abc"), &none, 0));
}
