// LeetCode 1456. Maximum Number of Vowels in a Substring of Given Length
// C signature:  int maxVowels(char* s, int k);
const std = @import("std");

fn isVowel(c: u8) bool {
    return c == 'a' or c == 'e' or c == 'i' or c == 'o' or c == 'u';
}

pub fn maxVowels(s: [*]u8, k: i32) i32 {
    const str = std.mem.sliceTo(s, 0);
    const n: i32 = @intCast(str.len);

    var count: i32 = 0;
    var i: i32 = 0;
    while (i < k and i < n) : (i += 1) {
        if (isVowel(str[@intCast(i)])) count += 1;
    }
    var best: i32 = count;

    i = k;
    while (i < n) : (i += 1) {
        if (isVowel(str[@intCast(i)])) count += 1;
        if (isVowel(str[@intCast(i - k)])) count -= 1;
        if (count > best) best = count;
    }
    return best;
}

test "maxVowels" {
    try std.testing.expectEqual(@as(i32, 3), maxVowels(@constCast("abciiidef"), 3));
    try std.testing.expectEqual(@as(i32, 2), maxVowels(@constCast("aeiou"), 2));
    try std.testing.expectEqual(@as(i32, 2), maxVowels(@constCast("leetcode"), 3));
    try std.testing.expectEqual(@as(i32, 1), maxVowels(@constCast("a"), 1));
    try std.testing.expectEqual(@as(i32, 0), maxVowels(@constCast("bcdfg"), 3));
}
