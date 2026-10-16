// LeetCode 5. Longest Palindromic Substring
// C signature:  char* longestPalindrome(char* s);
//
// Expand around every centre (odd and even) and remember the widest span,
// then copy it into a fresh NUL-terminated buffer.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn longestPalindrome(s: [*]u8) [*]u8 {
    const str = std.mem.sliceTo(s, 0);
    const n = str.len;

    if (n == 0) {
        const e = allocator.alloc(u8, 1) catch unreachable;
        e[0] = 0;
        return e.ptr;
    }

    var bestStart: usize = 0;
    var bestLen: usize = 1;

    var center: usize = 0;
    while (center < n) : (center += 1) {
        // Odd length palindrome centred on `center`.
        var a = center;
        var b = center;
        while (a > 0 and b + 1 < n and str[a - 1] == str[b + 1]) {
            a -= 1;
            b += 1;
        }
        if (b - a + 1 > bestLen) {
            bestLen = b - a + 1;
            bestStart = a;
        }

        // Even length palindrome centred between `center` and `center+1`.
        if (center + 1 < n and str[center] == str[center + 1]) {
            a = center;
            b = center + 1;
            while (a > 0 and b + 1 < n and str[a - 1] == str[b + 1]) {
                a -= 1;
                b += 1;
            }
            if (b - a + 1 > bestLen) {
                bestLen = b - a + 1;
                bestStart = a;
            }
        }
    }

    const buf = allocator.alloc(u8, bestLen + 1) catch unreachable;
    var k: usize = 0;
    while (k < bestLen) : (k += 1) buf[k] = str[bestStart + k];
    buf[bestLen] = 0;
    return buf.ptr;
}

test "longestPalindrome examples" {
    try std.testing.expectEqualStrings("bab", std.mem.span(@as([*:0]u8, @ptrCast(longestPalindrome(@constCast("babad"))))));
    try std.testing.expectEqualStrings("bb", std.mem.span(@as([*:0]u8, @ptrCast(longestPalindrome(@constCast("cbbd"))))));
}

test "longestPalindrome edges" {
    try std.testing.expectEqualStrings("a", std.mem.span(@as([*:0]u8, @ptrCast(longestPalindrome(@constCast("a"))))));
    try std.testing.expectEqualStrings("", std.mem.span(@as([*:0]u8, @ptrCast(longestPalindrome(@constCast(""))))));
    try std.testing.expectEqualStrings("a", std.mem.span(@as([*:0]u8, @ptrCast(longestPalindrome(@constCast("ac"))))));
    try std.testing.expectEqualStrings("a", std.mem.span(@as([*:0]u8, @ptrCast(longestPalindrome(@constCast("ab"))))));
    try std.testing.expectEqualStrings("aba", std.mem.span(@as([*:0]u8, @ptrCast(longestPalindrome(@constCast("abacdfgdcaba"))))));
    try std.testing.expectEqualStrings("abccba", std.mem.span(@as([*:0]u8, @ptrCast(longestPalindrome(@constCast("abccabccba"))))));
    try std.testing.expectEqualStrings("aaaa", std.mem.span(@as([*:0]u8, @ptrCast(longestPalindrome(@constCast("aaaa"))))));
}
