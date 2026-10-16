// LeetCode 137. Single Number II
// C signature:  int singleNumber(int* nums, int numsSize);
//
// Keep two bitmasks: `ones` has the bits seen exactly once (mod 3), `twos` the
// bits seen exactly twice. A bit that shows up three times clears itself out.
const std = @import("std");

pub fn singleNumber(nums: [*]i32, numsSize: i32) i32 {
    var ones: i32 = 0;
    var twos: i32 = 0;
    var i: i32 = 0;
    while (i < numsSize) : (i += 1) {
        const x = nums[@intCast(i)];
        ones = (ones ^ x) & ~twos;
        twos = (twos ^ x) & ~ones;
    }
    return ones;
}

test "singleNumber examples" {
    var a = [_]i32{ 2, 2, 3, 2 };
    try std.testing.expectEqual(@as(i32, 3), singleNumber(&a, 4));

    var b = [_]i32{ 0, 1, 0, 1, 0, 1, 99 };
    try std.testing.expectEqual(@as(i32, 99), singleNumber(&b, 7));

    var c = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 1), singleNumber(&c, 1));
}

test "singleNumber edges" {
    var a = [_]i32{ -2, -2, -2, 5 };
    try std.testing.expectEqual(@as(i32, 5), singleNumber(&a, 4));

    var b = [_]i32{ -1, -1, -1, -3 };
    try std.testing.expectEqual(@as(i32, -3), singleNumber(&b, 4));

    var c = [_]i32{ 1000000, 1000000, 1000000, -1000000 };
    try std.testing.expectEqual(@as(i32, -1000000), singleNumber(&c, 4));

    var d = [_]i32{ 0, 0, 0, 7 };
    try std.testing.expectEqual(@as(i32, 7), singleNumber(&d, 4));

    var e = [_]i32{ 7, 7, 7, 0 };
    try std.testing.expectEqual(@as(i32, 0), singleNumber(&e, 4));
}
