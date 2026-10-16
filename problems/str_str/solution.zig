// LeetCode 28. Find the Index of the First Occurrence in a String
// C signature:  int strStr(char* haystack, char* needle);
const std = @import("std");

pub fn strStr(haystack: [*]u8, needle: [*]u8) i32 {
    const h = std.mem.sliceTo(haystack, 0);
    const nd = std.mem.sliceTo(needle, 0);
    if (nd.len == 0) return 0;
    if (nd.len > h.len) return -1;
    var i: usize = 0;
    while (i + nd.len <= h.len) : (i += 1) {
        var j: usize = 0;
        var ok = true;
        while (j < nd.len) : (j += 1) {
            if (h[i + j] != nd[j]) {
                ok = false;
                break;
            }
        }
        if (ok) return @intCast(i);
    }
    return -1;
}

test "strStr examples" {
    try std.testing.expectEqual(@as(i32, 0), strStr(@constCast("sadbutsad"), @constCast("sad")));
    try std.testing.expectEqual(@as(i32, -1), strStr(@constCast("leetcode"), @constCast("leeto")));
}

test "strStr edges" {
    try std.testing.expectEqual(@as(i32, 2), strStr(@constCast("hello"), @constCast("ll")));
    try std.testing.expectEqual(@as(i32, 0), strStr(@constCast("abc"), @constCast("")));
    try std.testing.expectEqual(@as(i32, 4), strStr(@constCast("mississippi"), @constCast("issip")));
    try std.testing.expectEqual(@as(i32, -1), strStr(@constCast("aaa"), @constCast("aaaa")));
    try std.testing.expectEqual(@as(i32, 0), strStr(@constCast("a"), @constCast("a")));
    try std.testing.expectEqual(@as(i32, -1), strStr(@constCast(""), @constCast("a")));
}
