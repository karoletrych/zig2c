// LeetCode 1657. Determine if Two Strings Are Close
// C signature:  bool closeStrings(char* word1, char* word2);
// Words are lowercase English letters, so 26-entry frequency tables suffice.
const std = @import("std");

pub fn closeStrings(word1: [*]u8, word2: [*]u8) bool {
    const a = std.mem.sliceTo(word1, 0);
    const b = std.mem.sliceTo(word2, 0);
    if (a.len != b.len) return false;

    var ca: [26]i32 = undefined;
    var cb: [26]i32 = undefined;
    var i: usize = 0;
    while (i < 26) : (i += 1) {
        ca[i] = 0;
        cb[i] = 0;
    }

    for (a) |ch| {
        if (ch >= 'a' and ch <= 'z') ca[@intCast(ch - 'a')] += 1;
    }
    for (b) |ch| {
        if (ch >= 'a' and ch <= 'z') cb[@intCast(ch - 'a')] += 1;
    }

    // The same set of characters must be present in both words.
    i = 0;
    while (i < 26) : (i += 1) {
        if (ca[i] > 0 and cb[i] == 0) return false;
        if (cb[i] > 0 and ca[i] == 0) return false;
    }

    // The multisets of positive frequencies must be equal.
    var used: [26]bool = undefined;
    i = 0;
    while (i < 26) : (i += 1) used[i] = false;

    i = 0;
    while (i < 26) : (i += 1) {
        if (ca[i] > 0) {
            var found = false;
            var d: usize = 0;
            while (d < 26) : (d += 1) {
                if (!used[d] and cb[d] == ca[i]) {
                    used[d] = true;
                    found = true;
                    break;
                }
            }
            if (!found) return false;
        }
    }
    return true;
}

test "closeStrings" {
    try std.testing.expect(closeStrings(@constCast("abc"), @constCast("bca")));
    try std.testing.expect(!closeStrings(@constCast("a"), @constCast("aa")));
    try std.testing.expect(closeStrings(@constCast("cabbba"), @constCast("abbccc")));
    try std.testing.expect(!closeStrings(@constCast("uau"), @constCast("ssx")));
    try std.testing.expect(!closeStrings(@constCast("abbzzca"), @constCast("babzzcz")));
    try std.testing.expect(closeStrings(@constCast("a"), @constCast("a")));
}
