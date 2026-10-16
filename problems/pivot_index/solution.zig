// LeetCode 724. Find Pivot Index
// C signature:  int pivotIndex(int* nums, int numsSize);
const std = @import("std");

pub fn pivotIndex(nums: [*]i32, numsSize: i32) i32 {
    var total: i32 = 0;
    var i: i32 = 0;
    while (i < numsSize) : (i += 1) total += nums[@intCast(i)];

    var left: i32 = 0;
    i = 0;
    while (i < numsSize) : (i += 1) {
        if (left == total - left - nums[@intCast(i)]) return i;
        left += nums[@intCast(i)];
    }
    return -1;
}

test "pivotIndex" {
    var a = [_]i32{ 1, 7, 3, 6, 5, 6 };
    try std.testing.expectEqual(@as(i32, 3), pivotIndex(&a, 6));

    var b = [_]i32{ 1, 2, 3 };
    try std.testing.expectEqual(@as(i32, -1), pivotIndex(&b, 3));

    var c = [_]i32{ 2, 1, -1 };
    try std.testing.expectEqual(@as(i32, 0), pivotIndex(&c, 3));

    var d = [_]i32{0};
    try std.testing.expectEqual(@as(i32, 0), pivotIndex(&d, 1));

    var e = [_]i32{ -1, -1, -1, -1, -1, 0 };
    try std.testing.expectEqual(@as(i32, 2), pivotIndex(&e, 6));
}
