// LeetCode 2390. Removing Stars From a String
// C signature:  char* removeStars(char* s);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn removeStars(s: [*]u8) [*]u8 {
    const str = std.mem.sliceTo(s, 0);
    const buf = allocator.alloc(u8, str.len + 1) catch unreachable;

    var top: usize = 0;
    for (str) |c| {
        if (c == '*') {
            if (top > 0) top -= 1;
        } else {
            buf[top] = c;
            top += 1;
        }
    }
    buf[top] = 0;
    return buf.ptr;
}

test "removeStars" {
    const r1 = removeStars(@constCast("leet**cod*e"));
    try std.testing.expectEqualStrings("lecoe", std.mem.span(@as([*:0]u8, @ptrCast(r1))));
    const r2 = removeStars(@constCast("erase*****"));
    try std.testing.expectEqualStrings("", std.mem.span(@as([*:0]u8, @ptrCast(r2))));
    const r3 = removeStars(@constCast("abc"));
    try std.testing.expectEqualStrings("abc", std.mem.span(@as([*:0]u8, @ptrCast(r3))));
}
