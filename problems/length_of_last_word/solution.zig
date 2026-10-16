// LeetCode 58. Length of Last Word
// C signature:  int lengthOfLastWord(char* s);
const std = @import("std");

pub fn lengthOfLastWord(s: [*]u8) i32 {
    const a = std.mem.sliceTo(s, 0);
    var end: usize = a.len;
    while (end > 0 and a[end - 1] == ' ') end -= 1;
    var start: usize = end;
    while (start > 0 and a[start - 1] != ' ') start -= 1;
    return @intCast(end - start);
}

test "lengthOfLastWord examples" {
    try std.testing.expectEqual(@as(i32, 5), lengthOfLastWord(@constCast("Hello World")));
    try std.testing.expectEqual(@as(i32, 4), lengthOfLastWord(@constCast("   fly me   to   the moon  ")));
    try std.testing.expectEqual(@as(i32, 6), lengthOfLastWord(@constCast("luffy is still joyboy")));
}

test "lengthOfLastWord edges" {
    try std.testing.expectEqual(@as(i32, 1), lengthOfLastWord(@constCast("a")));
    try std.testing.expectEqual(@as(i32, 1), lengthOfLastWord(@constCast("a ")));
    try std.testing.expectEqual(@as(i32, 3), lengthOfLastWord(@constCast(" day")));
    try std.testing.expectEqual(@as(i32, 0), lengthOfLastWord(@constCast("   ")));
}
