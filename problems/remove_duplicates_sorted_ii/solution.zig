// LeetCode 80. Remove Duplicates from Sorted Array II
// C signature:  int removeDuplicates(int* nums, int numsSize);
//
// Each distinct value may appear at most twice. Because the array is sorted,
// every run of equal values can be counted in one pass and truncated to two.

const std = @import("std");

pub fn removeDuplicates(nums: [*]i32, numsSize: i32) i32 {
    var k: i32 = 0;
    var i: i32 = 0;
    while (i < numsSize) {
        var j: i32 = i;
        while (j < numsSize and nums[@intCast(j)] == nums[@intCast(i)]) : (j += 1) {}
        const keep = @min(j - i, 2);
        var t: i32 = 0;
        while (t < keep) : (t += 1) {
            nums[@intCast(k)] = nums[@intCast(i)];
            k += 1;
        }
        i = j;
    }
    return k;
}

test "removeDuplicates examples" {
    var a = [_]i32{ 1, 1, 1, 2, 2, 3 };
    try std.testing.expectEqual(@as(i32, 5), removeDuplicates(&a, 6));
    try std.testing.expectEqual(@as(i32, 1), a[0]);
    try std.testing.expectEqual(@as(i32, 1), a[1]);
    try std.testing.expectEqual(@as(i32, 2), a[2]);
    try std.testing.expectEqual(@as(i32, 2), a[3]);
    try std.testing.expectEqual(@as(i32, 3), a[4]);

    var b = [_]i32{ 0, 0, 1, 1, 1, 1, 2, 3, 3 };
    try std.testing.expectEqual(@as(i32, 7), removeDuplicates(&b, 9));
    try std.testing.expectEqual(@as(i32, 0), b[0]);
    try std.testing.expectEqual(@as(i32, 0), b[1]);
    try std.testing.expectEqual(@as(i32, 1), b[2]);
    try std.testing.expectEqual(@as(i32, 1), b[3]);
    try std.testing.expectEqual(@as(i32, 2), b[4]);
    try std.testing.expectEqual(@as(i32, 3), b[5]);
    try std.testing.expectEqual(@as(i32, 3), b[6]);
}

test "removeDuplicates edges" {
    var empty = [_]i32{0};
    try std.testing.expectEqual(@as(i32, 0), removeDuplicates(&empty, 0));

    var one = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 1), removeDuplicates(&one, 1));

    var two = [_]i32{ 1, 1 };
    try std.testing.expectEqual(@as(i32, 2), removeDuplicates(&two, 2));

    var many = [_]i32{ 4, 4, 4, 4, 4 };
    try std.testing.expectEqual(@as(i32, 2), removeDuplicates(&many, 5));
    try std.testing.expectEqual(@as(i32, 4), many[0]);
    try std.testing.expectEqual(@as(i32, 4), many[1]);
}
