// LeetCode 67. Add Binary
// C signature:  char* addBinary(char* a, char* b);
//
// Grade-school addition from the least significant bit into a buffer one byte
// longer than the longer operand, then trim a leading zero and NUL-terminate.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn addBinary(a: [*]u8, b: [*]u8) [*]u8 {
    const x = std.mem.sliceTo(a, 0);
    const y = std.mem.sliceTo(b, 0);

    const maxLen = if (x.len > y.len) x.len else y.len;
    const buf = allocator.alloc(u8, maxLen + 1) catch unreachable;

    var i: usize = x.len;
    var j: usize = y.len;
    var carry: u8 = 0;
    var k: usize = maxLen + 1;
    while (k > 0) : (k -= 1) {
        var sum: u8 = carry;
        if (i > 0) {
            i -= 1;
            sum += x[i] - '0';
        }
        if (j > 0) {
            j -= 1;
            sum += y[j] - '0';
        }
        carry = if (sum >= 2) 1 else 0;
        buf[k - 1] = '0' + (sum & 1);
    }

    var start: usize = 0;
    if (maxLen > 0 and buf[0] == '0') start = 1;
    const resLen = (maxLen + 1) - start;
    const res = allocator.alloc(u8, resLen + 1) catch unreachable;
    var t: usize = 0;
    while (t < resLen) : (t += 1) res[t] = buf[start + t];
    res[resLen] = 0;
    return res.ptr;
}

test "addBinary examples" {
    try std.testing.expectEqualStrings("100", std.mem.span(@as([*:0]u8, @ptrCast(addBinary(@constCast("11"), @constCast("1"))))));
    try std.testing.expectEqualStrings("10101", std.mem.span(@as([*:0]u8, @ptrCast(addBinary(@constCast("1010"), @constCast("1011"))))));
}

test "addBinary edges" {
    try std.testing.expectEqualStrings("0", std.mem.span(@as([*:0]u8, @ptrCast(addBinary(@constCast("0"), @constCast("0"))))));
    try std.testing.expectEqualStrings("1", std.mem.span(@as([*:0]u8, @ptrCast(addBinary(@constCast("1"), @constCast("0"))))));
    try std.testing.expectEqualStrings("1", std.mem.span(@as([*:0]u8, @ptrCast(addBinary(@constCast("0"), @constCast("1"))))));
    try std.testing.expectEqualStrings("10000", std.mem.span(@as([*:0]u8, @ptrCast(addBinary(@constCast("1111"), @constCast("1"))))));
    try std.testing.expectEqualStrings("1", std.mem.span(@as([*:0]u8, @ptrCast(addBinary(@constCast(""), @constCast("1"))))));
    try std.testing.expectEqualStrings("0", std.mem.span(@as([*:0]u8, @ptrCast(addBinary(@constCast(""), @constCast(""))))));
    try std.testing.expectEqualStrings("100110", std.mem.span(@as([*:0]u8, @ptrCast(addBinary(@constCast("1101"), @constCast("11001"))))));
}
