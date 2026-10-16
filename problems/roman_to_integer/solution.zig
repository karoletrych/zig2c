// LeetCode 13. Roman to Integer
// C signature:  int romanToInt(char* s);
//
// Values are normally added; a symbol smaller than the one after it is
// subtracted (subtractive notation, e.g. IV, IX, XL).

const std = @import("std");

fn romanVal(c: u8) i32 {
    if (c == 'I') return 1;
    if (c == 'V') return 5;
    if (c == 'X') return 10;
    if (c == 'L') return 50;
    if (c == 'C') return 100;
    if (c == 'D') return 500;
    if (c == 'M') return 1000;
    return 0;
}

pub fn romanToInt(s: [*]u8) i32 {
    const chars = std.mem.sliceTo(s, 0);
    var total: i32 = 0;
    var i: usize = 0;
    while (i < chars.len) : (i += 1) {
        const v = romanVal(chars[i]);
        var next: i32 = 0;
        if (i + 1 < chars.len) next = romanVal(chars[i + 1]);
        if (v < next) {
            total -= v;
        } else {
            total += v;
        }
    }
    return total;
}

test "romanToInt examples" {
    try std.testing.expectEqual(@as(i32, 3), romanToInt(@constCast("III")));
    try std.testing.expectEqual(@as(i32, 58), romanToInt(@constCast("LVIII")));
    try std.testing.expectEqual(@as(i32, 1994), romanToInt(@constCast("MCMXCIV")));
}

test "romanToInt edges" {
    try std.testing.expectEqual(@as(i32, 4), romanToInt(@constCast("IV")));
    try std.testing.expectEqual(@as(i32, 9), romanToInt(@constCast("IX")));
    try std.testing.expectEqual(@as(i32, 40), romanToInt(@constCast("XL")));
    try std.testing.expectEqual(@as(i32, 90), romanToInt(@constCast("XC")));
    try std.testing.expectEqual(@as(i32, 400), romanToInt(@constCast("CD")));
    try std.testing.expectEqual(@as(i32, 900), romanToInt(@constCast("CM")));
    try std.testing.expectEqual(@as(i32, 1), romanToInt(@constCast("I")));
    try std.testing.expectEqual(@as(i32, 4000), romanToInt(@constCast("MMMM")));
}
