// LeetCode 136. Single Number
// C signature:  int singleNumber(int* nums, int numsSize);
//
// XOR is associative and x ^ x == 0, so every doubled value cancels and the
// unique one survives.
const std = @import("std");

pub fn singleNumber(nums: [*]i32, numsSize: i32) i32 {
    var x: i32 = 0;
    var i: i32 = 0;
    while (i < numsSize) : (i += 1) {
        x ^= nums[@intCast(i)];
    }
    return x;
}

test "singleNumber examples" {
    var a = [_]i32{ 2, 2, 1 };
    try std.testing.expectEqual(@as(i32, 1), singleNumber(&a, 3));

    var b = [_]i32{ 4, 1, 2, 1, 2 };
    try std.testing.expectEqual(@as(i32, 4), singleNumber(&b, 5));

    var c = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 1), singleNumber(&c, 1));
}

test "singleNumber edges" {
    var a = [_]i32{ 0, 0, 7 };
    try std.testing.expectEqual(@as(i32, 7), singleNumber(&a, 3));

    var b = [_]i32{ -3, 5, 5, -3, -8 };
    try std.testing.expectEqual(@as(i32, -8), singleNumber(&b, 5));

    var c = [_]i32{ 100000, 100000, -100000 };
    try std.testing.expectEqual(@as(i32, -100000), singleNumber(&c, 3));
}
