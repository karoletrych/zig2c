// LeetCode 242. Valid Anagram
// C signature:  bool isAnagram(char* s, char* t);
//
// Count letters of s up and letters of t down; everything must cancel.
const std = @import("std");

pub fn isAnagram(s: [*]u8, t: [*]u8) bool {
    const a = std.mem.sliceTo(s, 0);
    const b = std.mem.sliceTo(t, 0);
    if (a.len != b.len) return false;

    var counts: [256]i32 = undefined;
    var i: usize = 0;
    while (i < 256) : (i += 1) counts[i] = 0;

    for (a) |c| {
        const ci: usize = @intCast(c);
        counts[ci] += 1;
    }
    for (b) |c| {
        const ci: usize = @intCast(c);
        if (counts[ci] == 0) return false;
        counts[ci] -= 1;
    }
    return true;
}

test "isAnagram examples" {
    try std.testing.expect(isAnagram(@constCast("anagram"), @constCast("nagaram")));
    try std.testing.expect(!isAnagram(@constCast("rat"), @constCast("car")));
    try std.testing.expect(isAnagram(@constCast(""), @constCast("")));
    try std.testing.expect(!isAnagram(@constCast("a"), @constCast("")));
    try std.testing.expect(isAnagram(@constCast("aacc"), @constCast("ccac")) == false);
}
