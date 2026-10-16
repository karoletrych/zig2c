// LeetCode 1071. Greatest Common Divisor of Strings
// C signature:  char* gcdOfStrings(char* str1, char* str2);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn gcdOfStrings(str1: [*]u8, str2: [*]u8) [*]u8 {
    const a = std.mem.sliceTo(str1, 0);
    const b = std.mem.sliceTo(str2, 0);

    // The common divisor exists iff str1 + str2 == str2 + str1.
    var same = true;
    const total = a.len + b.len;
    var i: usize = 0;
    while (i < total) : (i += 1) {
        const x = if (i < a.len) a[i] else b[i - a.len];
        const y = if (i < b.len) b[i] else a[i - b.len];
        if (x != y) {
            same = false;
            break;
        }
    }

    if (!same) {
        const empty = allocator.alloc(u8, 1) catch unreachable;
        empty[0] = 0;
        return empty.ptr;
    }

    // The answer is the prefix of length gcd(len(a), len(b)).
    var x: usize = a.len;
    var y: usize = b.len;
    while (y != 0) {
        const t = x % y;
        x = y;
        y = t;
    }
    const g = x;

    const buf = allocator.alloc(u8, g + 1) catch unreachable;
    var k: usize = 0;
    while (k < g) : (k += 1) buf[k] = a[k];
    buf[g] = 0;
    return buf.ptr;
}

test "gcdOfStrings examples" {
    const r1 = gcdOfStrings(@constCast("ABCABC"), @constCast("ABC"));
    try std.testing.expectEqualStrings("ABC", std.mem.span(@as([*:0]u8, @ptrCast(r1))));

    const r2 = gcdOfStrings(@constCast("ABABAB"), @constCast("ABAB"));
    try std.testing.expectEqualStrings("AB", std.mem.span(@as([*:0]u8, @ptrCast(r2))));

    const r3 = gcdOfStrings(@constCast("LEET"), @constCast("CODE"));
    try std.testing.expectEqualStrings("", std.mem.span(@as([*:0]u8, @ptrCast(r3))));
}

test "gcdOfStrings edges" {
    const r1 = gcdOfStrings(@constCast("AAAA"), @constCast("AA"));
    try std.testing.expectEqualStrings("AA", std.mem.span(@as([*:0]u8, @ptrCast(r1))));

    const r2 = gcdOfStrings(@constCast("ABC"), @constCast("ABC"));
    try std.testing.expectEqualStrings("ABC", std.mem.span(@as([*:0]u8, @ptrCast(r2))));

    const r3 = gcdOfStrings(@constCast(""), @constCast(""));
    try std.testing.expectEqualStrings("", std.mem.span(@as([*:0]u8, @ptrCast(r3))));

    const r4 = gcdOfStrings(@constCast("A"), @constCast("AA"));
    try std.testing.expectEqualStrings("A", std.mem.span(@as([*:0]u8, @ptrCast(r4))));
}
