// LeetCode 71. Simplify Path
// C signature:  char* simplifyPath(char* path);
//
// Canonicalize in one pass over the input. Components are written into the
// output as they arrive; a stack of output offsets records the position of each
// component's leading '/' so ".." can truncate back to it. "." and empty
// components are ignored.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn simplifyPath(path: [*]u8) [*]u8 {
    const p = std.mem.sliceTo(path, 0);
    const out = allocator.alloc(u8, p.len + 2) catch unreachable;
    const stack = allocator.alloc(usize, p.len + 1) catch unreachable;
    defer allocator.free(stack);

    var w: usize = 0;
    var top: usize = 0;
    var i: usize = 0;
    while (i < p.len) {
        if (p[i] != '/') {
            i += 1;
            continue;
        }
        i += 1;
        const start = i;
        while (i < p.len and p[i] != '/') i += 1;
        const len = i - start;
        if (len == 0) continue;
        if (len == 1 and p[start] == '.') continue;
        if (len == 2 and p[start] == '.' and p[start + 1] == '.') {
            if (top > 0) {
                top -= 1;
                w = stack[top];
            }
            continue;
        }
        stack[top] = w;
        top += 1;
        out[w] = '/';
        w += 1;
        var k: usize = start;
        while (k < start + len) : (k += 1) {
            out[w] = p[k];
            w += 1;
        }
    }

    if (w == 0) {
        out[0] = '/';
        w = 1;
    }
    out[w] = 0;
    return out.ptr;
}

test "simplifyPath examples" {
    try std.testing.expectEqualStrings("/home", std.mem.span(@as([*:0]u8, @ptrCast(simplifyPath(@constCast("/home/"))))));
    try std.testing.expectEqualStrings("/home/foo", std.mem.span(@as([*:0]u8, @ptrCast(simplifyPath(@constCast("/home//foo/"))))));
    try std.testing.expectEqualStrings("/home/user/Pictures", std.mem.span(@as([*:0]u8, @ptrCast(simplifyPath(@constCast("/home/user/Documents/../Pictures"))))));
    try std.testing.expectEqualStrings("/", std.mem.span(@as([*:0]u8, @ptrCast(simplifyPath(@constCast("/../"))))));
    try std.testing.expectEqualStrings("/.../b/d", std.mem.span(@as([*:0]u8, @ptrCast(simplifyPath(@constCast("/.../a/../b/c/../d/./"))))));
}

test "simplifyPath edges" {
    try std.testing.expectEqualStrings("/", std.mem.span(@as([*:0]u8, @ptrCast(simplifyPath(@constCast("/"))))));
    try std.testing.expectEqualStrings("/a/b/c", std.mem.span(@as([*:0]u8, @ptrCast(simplifyPath(@constCast("/a/b/c/././."))))));
    try std.testing.expectEqualStrings("/a", std.mem.span(@as([*:0]u8, @ptrCast(simplifyPath(@constCast("/a/b/.."))))));
    try std.testing.expectEqualStrings("/b", std.mem.span(@as([*:0]u8, @ptrCast(simplifyPath(@constCast("/a/../../b"))))));
    // "..." is a literal directory name, not a parent reference.
    try std.testing.expectEqualStrings("/...", std.mem.span(@as([*:0]u8, @ptrCast(simplifyPath(@constCast("/..."))))));
}
