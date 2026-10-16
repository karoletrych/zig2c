// LeetCode 151. Reverse Words in a String
// C signature:  char* reverseWords(char* s);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn reverseWords(s: [*]u8) [*]u8 {
    const a = std.mem.sliceTo(s, 0);
    const buf = allocator.alloc(u8, a.len + 1) catch unreachable;

    var k: usize = 0;
    var end: usize = a.len;
    while (end > 0) {
        // Skip trailing spaces of the current (unprocessed) prefix.
        while (end > 0 and a[end - 1] == ' ') end -= 1;
        if (end == 0) break;
        // Find the start of this word.
        var start = end;
        while (start > 0 and a[start - 1] != ' ') start -= 1;
        if (k > 0) {
            buf[k] = ' ';
            k += 1;
        }
        var idx = start;
        while (idx < end) : (idx += 1) {
            buf[k] = a[idx];
            k += 1;
        }
        end = start;
    }
    buf[k] = 0;
    return buf.ptr;
}

test "reverseWords examples" {
    const r1 = reverseWords(@constCast("the sky is blue"));
    try std.testing.expectEqualStrings("blue is sky the", std.mem.span(@as([*:0]u8, @ptrCast(r1))));

    const r2 = reverseWords(@constCast("  hello world  "));
    try std.testing.expectEqualStrings("world hello", std.mem.span(@as([*:0]u8, @ptrCast(r2))));

    const r3 = reverseWords(@constCast("a good   example"));
    try std.testing.expectEqualStrings("example good a", std.mem.span(@as([*:0]u8, @ptrCast(r3))));
}

test "reverseWords edges" {
    const r1 = reverseWords(@constCast("a"));
    try std.testing.expectEqualStrings("a", std.mem.span(@as([*:0]u8, @ptrCast(r1))));

    const r2 = reverseWords(@constCast("   "));
    try std.testing.expectEqualStrings("", std.mem.span(@as([*:0]u8, @ptrCast(r2))));

    const r3 = reverseWords(@constCast(""));
    try std.testing.expectEqualStrings("", std.mem.span(@as([*:0]u8, @ptrCast(r3))));

    const r4 = reverseWords(@constCast("one"));
    try std.testing.expectEqualStrings("one", std.mem.span(@as([*:0]u8, @ptrCast(r4))));
}
