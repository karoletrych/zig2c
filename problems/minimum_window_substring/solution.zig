// LeetCode 76. Minimum Window Substring
// C signature:  char* minWindow(char* s, char* t);
//
// Sliding window with a 256-entry need/have count table. `required` counts the
// distinct characters of t; `formed` counts how many of them currently have
// their full requirement inside the window. Shrink the window while it stays
// valid, recording the shortest span seen.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn minWindow(s: [*]u8, t: [*]u8) [*]u8 {
    const a = std.mem.sliceTo(s, 0);
    const b = std.mem.sliceTo(t, 0);

    if (b.len == 0) {
        const e = allocator.alloc(u8, 1) catch unreachable;
        e[0] = 0;
        return e.ptr;
    }

    var need: [256]i32 = undefined;
    var have: [256]i32 = undefined;
    var z: usize = 0;
    while (z < 256) : (z += 1) {
        need[z] = 0;
        have[z] = 0;
    }

    var required: i32 = 0;
    var i: usize = 0;
    while (i < b.len) : (i += 1) {
        const ci: usize = @intCast(b[i]);
        if (need[ci] == 0) required += 1;
        need[ci] += 1;
    }

    var bestLen: usize = a.len + 1;
    var bestStart: usize = 0;
    var formed: i32 = 0;
    var left: usize = 0;
    var right: usize = 0;
    while (right < a.len) : (right += 1) {
        const c: usize = @intCast(a[right]);
        have[c] += 1;
        if (need[c] > 0 and have[c] == need[c]) formed += 1;

        while (formed == required) {
            const w = right - left + 1;
            if (w < bestLen) {
                bestLen = w;
                bestStart = left;
            }
            const lc: usize = @intCast(a[left]);
            have[lc] -= 1;
            if (need[lc] > 0 and have[lc] < need[lc]) formed -= 1;
            left += 1;
        }
    }

    var outLen: usize = 0;
    if (bestLen <= a.len) outLen = bestLen;
    const buf = allocator.alloc(u8, outLen + 1) catch unreachable;
    var k: usize = 0;
    while (k < outLen) : (k += 1) buf[k] = a[bestStart + k];
    buf[outLen] = 0;
    return buf.ptr;
}

test "minWindow examples" {
    try std.testing.expectEqualStrings("BANC", std.mem.sliceTo(minWindow(@constCast("ADOBECODEBANC"), @constCast("ABC")), 0));
    try std.testing.expectEqualStrings("a", std.mem.sliceTo(minWindow(@constCast("a"), @constCast("a")), 0));
    try std.testing.expectEqualStrings("", std.mem.sliceTo(minWindow(@constCast("a"), @constCast("aa")), 0));
}

test "minWindow edges" {
    try std.testing.expectEqualStrings("", std.mem.sliceTo(minWindow(@constCast(""), @constCast("a")), 0));
    try std.testing.expectEqualStrings("", std.mem.sliceTo(minWindow(@constCast("abc"), @constCast("")), 0));
    try std.testing.expectEqualStrings("aa", std.mem.sliceTo(minWindow(@constCast("aaab"), @constCast("aa")), 0));
    try std.testing.expectEqualStrings("b", std.mem.sliceTo(minWindow(@constCast("abbcabb"), @constCast("b")), 0));
    try std.testing.expectEqualStrings("ab", std.mem.sliceTo(minWindow(@constCast("ab"), @constCast("ab")), 0));
    try std.testing.expectEqualStrings("ba", std.mem.sliceTo(minWindow(@constCast("bba"), @constCast("ab")), 0));
    try std.testing.expectEqualStrings("a", std.mem.sliceTo(minWindow(@constCast("a"), @constCast("a")), 0));
    try std.testing.expectEqualStrings("", std.mem.sliceTo(minWindow(@constCast("abc"), @constCast("xyz")), 0));
}
