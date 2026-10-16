// LeetCode 392. Is Subsequence
// C signature:  bool isSubsequence(char* s, char* t);
const std = @import("std");

pub fn isSubsequence(s: [*]u8, t: [*]u8) bool {
    const a = std.mem.sliceTo(s, 0);
    const b = std.mem.sliceTo(t, 0);
    var i: usize = 0;
    var j: usize = 0;
    while (i < a.len and j < b.len) {
        if (a[i] == b[j]) i += 1;
        j += 1;
    }
    return i == a.len;
}

test "isSubsequence examples" {
    try std.testing.expect(isSubsequence(@constCast("abc"), @constCast("ahbgdc")));
    try std.testing.expect(!isSubsequence(@constCast("axc"), @constCast("ahbgdc")));
}

test "isSubsequence edges" {
    try std.testing.expect(isSubsequence(@constCast(""), @constCast("")));
    try std.testing.expect(isSubsequence(@constCast(""), @constCast("abc")));
    try std.testing.expect(!isSubsequence(@constCast("abc"), @constCast("")));
    try std.testing.expect(isSubsequence(@constCast("ace"), @constCast("abcde")));
    try std.testing.expect(!isSubsequence(@constCast("aec"), @constCast("abcde")));
    try std.testing.expect(isSubsequence(@constCast("b"), @constCast("abc")));
}
