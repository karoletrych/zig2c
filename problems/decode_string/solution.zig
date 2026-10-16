// LeetCode 394. Decode String
// C signature:  char* decodeString(char* s);
//
// Two passes over the input, both with a small fixed stack of repeat counts:
//   1. decodedLen() computes the exact length of the result.
//   2. the main loop writes into an exactly-sized buffer; on ']' the segment
//      already written is one copy, so (count - 1) more copies are appended.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn decodedLen(str: []u8) usize {
    var nums: [256]i32 = undefined;
    var bases: [256]usize = undefined;
    var top: usize = 0;
    var num: i32 = 0;
    var len: usize = 0;

    for (str) |c| {
        if (std.ascii.isDigit(c)) {
            num = num * 10 + @as(i32, @intCast(c - '0'));
        } else if (c == '[') {
            nums[top] = num;
            bases[top] = len;
            top += 1;
            num = 0;
        } else if (c == ']') {
            top -= 1;
            const base = bases[top];
            const seg = len - base;
            len = base + @as(usize, @intCast(nums[top])) * seg;
        } else {
            len += 1;
        }
    }
    return len;
}

pub fn decodeString(s: [*]u8) [*]u8 {
    const str = std.mem.sliceTo(s, 0);
    const total = decodedLen(str);
    const out = allocator.alloc(u8, total + 1) catch unreachable;

    var nums: [256]i32 = undefined;
    var starts: [256]usize = undefined;
    var top: usize = 0;
    var num: i32 = 0;
    var w: usize = 0;

    for (str) |c| {
        if (std.ascii.isDigit(c)) {
            num = num * 10 + @as(i32, @intCast(c - '0'));
        } else if (c == '[') {
            nums[top] = num;
            starts[top] = w;
            top += 1;
            num = 0;
        } else if (c == ']') {
            top -= 1;
            const count = nums[top];
            const start = starts[top];
            const seg = w - start;
            var r: i32 = 1;
            while (r < count) : (r += 1) {
                var k: usize = 0;
                while (k < seg) : (k += 1) {
                    out[w + k] = out[start + k];
                }
                w += seg;
            }
        } else {
            out[w] = c;
            w += 1;
        }
    }
    out[total] = 0;
    return out.ptr;
}

test "decodeString" {
    const r1 = decodeString(@constCast("3[a]2[bc]"));
    try std.testing.expectEqualStrings("aaabcbc", std.mem.span(@as([*:0]u8, @ptrCast(r1))));
    const r2 = decodeString(@constCast("3[a2[c]]"));
    try std.testing.expectEqualStrings("accaccacc", std.mem.span(@as([*:0]u8, @ptrCast(r2))));
    const r3 = decodeString(@constCast("2[abc]3[cd]ef"));
    try std.testing.expectEqualStrings("abcabccdcdcdef", std.mem.span(@as([*:0]u8, @ptrCast(r3))));
    const r4 = decodeString(@constCast("10[a]"));
    try std.testing.expectEqualStrings("aaaaaaaaaa", std.mem.span(@as([*:0]u8, @ptrCast(r4))));
    const r5 = decodeString(@constCast("abc"));
    try std.testing.expectEqualStrings("abc", std.mem.span(@as([*:0]u8, @ptrCast(r5))));
    const r6 = decodeString(@constCast("3[z]2[2[y]pq4[2[jk]e1[f]]]ef"));
    try std.testing.expectEqualStrings("zzzyypqjkjkefjkjkefjkjkefjkjkefyypqjkjkefjkjkefjkjkefjkjkefef", std.mem.span(@as([*:0]u8, @ptrCast(r6))));
}
