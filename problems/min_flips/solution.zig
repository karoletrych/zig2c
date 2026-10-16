// LeetCode 1318. Minimum Flips to Make a OR b Equal to c
// C signature:  int minFlips(int a, int b, int c);
//
// Walk the bits of a, b and c together (all non-negative, so shifting right
// digit by digit is enough). At each bit:
//   c has 0  -> both a and b must be 0, flip every set bit.
//   c has 1  -> at least one of a, b must be 1; if neither is, flip one.
const std = @import("std");

pub fn minFlips(a: i32, b: i32, c: i32) i32 {
    var x = a;
    var y = b;
    var z = c;
    var flips: i32 = 0;

    while (x > 0 or y > 0 or z > 0) {
        const abit = x & 1;
        const bbit = y & 1;
        const cbit = z & 1;

        if (cbit == 0) {
            flips += abit + bbit;
        } else if (abit == 0 and bbit == 0) {
            flips += 1;
        }

        x >>= 1;
        y >>= 1;
        z >>= 1;
    }

    return flips;
}

test "minFlips examples" {
    try std.testing.expectEqual(@as(i32, 3), minFlips(2, 6, 5));
    try std.testing.expectEqual(@as(i32, 1), minFlips(4, 2, 7));
    try std.testing.expectEqual(@as(i32, 0), minFlips(1, 2, 3));
}

test "minFlips edges" {
    try std.testing.expectEqual(@as(i32, 0), minFlips(0, 0, 0));
    try std.testing.expectEqual(@as(i32, 1), minFlips(0, 0, 1));
    try std.testing.expectEqual(@as(i32, 3), minFlips(0, 0, 7));
    try std.testing.expectEqual(@as(i32, 4), minFlips(3, 3, 0));
    try std.testing.expectEqual(@as(i32, 3), minFlips(7, 0, 0));
    try std.testing.expectEqual(@as(i32, 3), minFlips(0, 7, 0));
    try std.testing.expectEqual(@as(i32, 3), minFlips(8, 3, 5));
    try std.testing.expectEqual(@as(i32, 0), minFlips(15, 0, 15));
    try std.testing.expectEqual(@as(i32, 10), minFlips(1024, 1023, 1024));
    try std.testing.expectEqual(@as(i32, 0), minFlips(1073741824, 1073741824, 1073741824));
}
