// LeetCode 3. Longest Substring Without Repeating Characters
// C signature:  int lengthOfLongestSubstring(char * s);
// Note: a string parameter is written as [*]u8, which maps to C's `char*`.
const std = @import("std");

pub fn lengthOfLongestSubstring(s: [*]u8) i32 {
    const str = std.mem.sliceTo(s, 0);
    var last: [128]i32 = undefined;
    var i: usize = 0;
    while (i < 128) : (i += 1) last[i] = -1;

    var best: i32 = 0;
    var start: i32 = 0;
    for (str, 0..) |c, idx| {
        const ci: i32 = @intCast(c);
        if (last[@intCast(ci)] >= start) start = last[@intCast(ci)] + 1;
        last[@intCast(ci)] = @intCast(idx);
        const cur: i32 = @as(i32, @intCast(idx)) - start + 1;
        best = @max(best, cur);
    }
    return best;
}

test "lengthOfLongestSubstring" {
    try std.testing.expectEqual(@as(i32, 3), lengthOfLongestSubstring(@constCast("abcabcbb")));
    try std.testing.expectEqual(@as(i32, 1), lengthOfLongestSubstring(@constCast("bbbbb")));
    try std.testing.expectEqual(@as(i32, 3), lengthOfLongestSubstring(@constCast("pwwkew")));
}
