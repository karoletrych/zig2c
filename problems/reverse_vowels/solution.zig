// LeetCode 345. Reverse Vowels of a String
// C signature:  char* reverseVowels(char* s);
const std = @import("std");
const allocator = std.heap.c_allocator;

fn isVowel(c: u8) bool {
    return c == 'a' or c == 'e' or c == 'i' or c == 'o' or c == 'u'
        or c == 'A' or c == 'E' or c == 'I' or c == 'O' or c == 'U';
}

pub fn reverseVowels(s: [*]u8) [*]u8 {
    const a = std.mem.sliceTo(s, 0);
    const buf = allocator.alloc(u8, a.len + 1) catch unreachable;

    var k: usize = 0;
    while (k < a.len) : (k += 1) buf[k] = a[k];
    buf[a.len] = 0;

    var i: usize = 0;
    var j: usize = a.len;
    while (i < j) {
        if (!isVowel(buf[i])) {
            i += 1;
        } else if (!isVowel(buf[j - 1])) {
            j -= 1;
        } else {
            const t = buf[i];
            buf[i] = buf[j - 1];
            buf[j - 1] = t;
            i += 1;
            j -= 1;
        }
    }
    return buf.ptr;
}

test "reverseVowels examples" {
    const r1 = reverseVowels(@constCast("IceCreAm"));
    try std.testing.expectEqualStrings("AceCreIm", std.mem.span(@as([*:0]u8, @ptrCast(r1))));

    const r2 = reverseVowels(@constCast("leetcode"));
    try std.testing.expectEqualStrings("leotcede", std.mem.span(@as([*:0]u8, @ptrCast(r2))));
}

test "reverseVowels edges" {
    const r1 = reverseVowels(@constCast("aA"));
    try std.testing.expectEqualStrings("Aa", std.mem.span(@as([*:0]u8, @ptrCast(r1))));

    const r2 = reverseVowels(@constCast("bcdfg"));
    try std.testing.expectEqualStrings("bcdfg", std.mem.span(@as([*:0]u8, @ptrCast(r2))));

    const r3 = reverseVowels(@constCast(""));
    try std.testing.expectEqualStrings("", std.mem.span(@as([*:0]u8, @ptrCast(r3))));

    const r4 = reverseVowels(@constCast("Ea"));
    try std.testing.expectEqualStrings("aE", std.mem.span(@as([*:0]u8, @ptrCast(r4))));
}
