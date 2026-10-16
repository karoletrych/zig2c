// LeetCode 26. Remove Duplicates from Sorted Array
// C signature:  int removeDuplicates(int* nums, int numsSize);
//
// The array is sorted, so equal values are adjacent. Keep the first of each run.

const std = @import("std");

pub fn removeDuplicates(nums: [*]i32, numsSize: i32) i32 {
    if (numsSize == 0) return 0;
    var k: i32 = 1;
    var i: i32 = 1;
    while (i < numsSize) : (i += 1) {
        if (nums[@intCast(i)] != nums[@intCast(k - 1)]) {
            nums[@intCast(k)] = nums[@intCast(i)];
            k += 1;
        }
    }
    return k;
}

test "removeDuplicates examples" {
    var a = [_]i32{ 1, 1, 2 };
    try std.testing.expectEqual(@as(i32, 2), removeDuplicates(&a, 3));
    try std.testing.expectEqual(@as(i32, 1), a[0]);
    try std.testing.expectEqual(@as(i32, 2), a[1]);

    var b = [_]i32{ 0, 0, 1, 1, 1, 2, 2, 3, 3, 4 };
    try std.testing.expectEqual(@as(i32, 5), removeDuplicates(&b, 10));
    try std.testing.expectEqual(@as(i32, 0), b[0]);
    try std.testing.expectEqual(@as(i32, 1), b[1]);
    try std.testing.expectEqual(@as(i32, 2), b[2]);
    try std.testing.expectEqual(@as(i32, 3), b[3]);
    try std.testing.expectEqual(@as(i32, 4), b[4]);
}

test "removeDuplicates edges" {
    var empty = [_]i32{0};
    try std.testing.expectEqual(@as(i32, 0), removeDuplicates(&empty, 0));

    var one = [_]i32{5};
    try std.testing.expectEqual(@as(i32, 1), removeDuplicates(&one, 1));

    var same = [_]i32{ 2, 2, 2, 2 };
    try std.testing.expectEqual(@as(i32, 1), removeDuplicates(&same, 4));
    try std.testing.expectEqual(@as(i32, 2), same[0]);
}
