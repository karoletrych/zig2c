// LeetCode 12. Integer to Roman
// C signature:  char* intToRoman(int num);
//
// Greedy subtraction over the 13 canonical values (including the six
// subtractive pairs). Each entry carries up to two characters so the table can
// stay a flat pair of fixed arrays.
const std = @import("std");
const allocator = std.heap.c_allocator;

const NV: usize = 13;
const VALS: [NV]i32 = .{ 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1 };
const CH0: [NV]u8 = .{ 'M', 'C', 'D', 'C', 'C', 'X', 'L', 'X', 'X', 'I', 'V', 'I', 'I' };
const CH1: [NV]u8 = .{ 0, 'M', 0, 'D', 0, 'C', 0, 'L', 0, 'X', 0, 'V', 0 };
const LENS: [NV]i32 = .{ 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1 };

pub fn intToRoman(num: i32) [*]u8 {
    const buf = allocator.alloc(u8, 16) catch unreachable;
    var n = num;
    var k: usize = 0;
    var i: usize = 0;
    while (i < NV) : (i += 1) {
        while (n >= VALS[i]) {
            n -= VALS[i];
            buf[k] = CH0[i];
            k += 1;
            if (LENS[i] == 2) {
                buf[k] = CH1[i];
                k += 1;
            }
        }
    }
    buf[k] = 0;
    return buf.ptr;
}

test "intToRoman examples" {
    try std.testing.expectEqualStrings("III", std.mem.span(@as([*:0]u8, @ptrCast(intToRoman(3)))));
    try std.testing.expectEqualStrings("LVIII", std.mem.span(@as([*:0]u8, @ptrCast(intToRoman(58)))));
    try std.testing.expectEqualStrings("MCMXCIV", std.mem.span(@as([*:0]u8, @ptrCast(intToRoman(1994)))));
}

test "intToRoman edges" {
    try std.testing.expectEqualStrings("I", std.mem.span(@as([*:0]u8, @ptrCast(intToRoman(1)))));
    try std.testing.expectEqualStrings("IV", std.mem.span(@as([*:0]u8, @ptrCast(intToRoman(4)))));
    try std.testing.expectEqualStrings("IX", std.mem.span(@as([*:0]u8, @ptrCast(intToRoman(9)))));
    try std.testing.expectEqualStrings("XL", std.mem.span(@as([*:0]u8, @ptrCast(intToRoman(40)))));
    try std.testing.expectEqualStrings("CDXLIV", std.mem.span(@as([*:0]u8, @ptrCast(intToRoman(444)))));
    try std.testing.expectEqualStrings("MMMCMXCIX", std.mem.span(@as([*:0]u8, @ptrCast(intToRoman(3999)))));
}
