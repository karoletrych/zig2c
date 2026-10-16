// LeetCode 14. Longest Common Prefix
// C signature:  char* longestCommonPrefix(char** strs, int strsSize);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn longestCommonPrefix(strs: [*][*]u8, strsSize: i32) [*]u8 {
    if (strsSize <= 0) {
        const empty = allocator.alloc(u8, 1) catch unreachable;
        empty[0] = 0;
        return empty.ptr;
    }
    const first = std.mem.sliceTo(strs[0], 0);
    var len: usize = first.len;
    var i: i32 = 1;
    while (i < strsSize) : (i += 1) {
        const cur = std.mem.sliceTo(strs[@intCast(i)], 0);
        if (cur.len < len) len = cur.len;
        var j: usize = 0;
        while (j < len) : (j += 1) {
            if (cur[j] != first[j]) {
                len = j;
                break;
            }
        }
    }
    const buf = allocator.alloc(u8, len + 1) catch unreachable;
    var k: usize = 0;
    while (k < len) : (k += 1) buf[k] = first[k];
    buf[len] = 0;
    return buf.ptr;
}

test "longestCommonPrefix examples" {
    var a = [_][*]u8{ @constCast("flower"), @constCast("flow"), @constCast("flight") };
    try std.testing.expectEqualStrings("fl", std.mem.sliceTo(longestCommonPrefix(&a, 3), 0));

    var b = [_][*]u8{ @constCast("dog"), @constCast("racecar"), @constCast("car") };
    try std.testing.expectEqualStrings("", std.mem.sliceTo(longestCommonPrefix(&b, 3), 0));
}

test "longestCommonPrefix edges" {
    var c = [_][*]u8{@constCast("single")};
    try std.testing.expectEqualStrings("single", std.mem.sliceTo(longestCommonPrefix(&c, 1), 0));

    var d = [_][*]u8{ @constCast("ab"), @constCast("a") };
    try std.testing.expectEqualStrings("a", std.mem.sliceTo(longestCommonPrefix(&d, 2), 0));

    var e = [_][*]u8{ @constCast(""), @constCast("b") };
    try std.testing.expectEqualStrings("", std.mem.sliceTo(longestCommonPrefix(&e, 2), 0));

    var f = [_][*]u8{ @constCast("cir"), @constCast("car") };
    try std.testing.expectEqualStrings("c", std.mem.sliceTo(longestCommonPrefix(&f, 2), 0));

    var g = [_][*]u8{ @constCast("abc"), @constCast("abc"), @constCast("abc") };
    try std.testing.expectEqualStrings("abc", std.mem.sliceTo(longestCommonPrefix(&g, 3), 0));
}
