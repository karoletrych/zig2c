// LeetCode 1768. Merge Strings Alternately  (LeetCode 75)
// C signature:  char* mergeAlternately(char* word1, char* word2);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn mergeAlternately(word1: [*]u8, word2: [*]u8) [*]u8 {
    const a = std.mem.sliceTo(word1, 0);
    const b = std.mem.sliceTo(word2, 0);
    const total = a.len + b.len;
    const buf = allocator.alloc(u8, total + 1) catch unreachable;

    var i: usize = 0;
    var j: usize = 0;
    var k: usize = 0;
    while (i < a.len or j < b.len) {
        if (i < a.len) {
            buf[k] = a[i];
            k += 1;
            i += 1;
        }
        if (j < b.len) {
            buf[k] = b[j];
            k += 1;
            j += 1;
        }
    }
    buf[total] = 0;
    return buf.ptr;
}

test "mergeAlternately" {
    const r = mergeAlternately(@constCast("abc"), @constCast("pqr"));
    try std.testing.expectEqualStrings("apbqcr", std.mem.span(@as([*:0]u8, @ptrCast(r))));
    const r2 = mergeAlternately(@constCast("ab"), @constCast("pqrs"));
    try std.testing.expectEqualStrings("apbqrs", std.mem.span(@as([*:0]u8, @ptrCast(r2))));
}
