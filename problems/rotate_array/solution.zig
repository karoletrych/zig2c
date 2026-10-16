// LeetCode 189. Rotate Array
// C signature:  void rotate(int* nums, int numsSize, int k);
//
// Reverse the whole array, then each of the two parts. k may exceed numsSize.

const std = @import("std");

fn reverseRange(nums: [*]i32, lo0: i32, hi0: i32) void {
    var lo = lo0;
    var hi = hi0;
    while (lo < hi) {
        const t = nums[@intCast(lo)];
        nums[@intCast(lo)] = nums[@intCast(hi)];
        nums[@intCast(hi)] = t;
        lo += 1;
        hi -= 1;
    }
}

pub fn rotate(nums: [*]i32, numsSize: i32, k: i32) void {
    if (numsSize <= 1) return;
    const kk = @mod(k, numsSize);
    if (kk == 0) return;
    reverseRange(nums, 0, numsSize - 1);
    reverseRange(nums, 0, kk - 1);
    reverseRange(nums, kk, numsSize - 1);
}

test "rotate examples" {
    var a = [_]i32{ 1, 2, 3, 4, 5, 6, 7 };
    rotate(&a, 7, 3);
    try std.testing.expectEqual(@as(i32, 5), a[0]);
    try std.testing.expectEqual(@as(i32, 6), a[1]);
    try std.testing.expectEqual(@as(i32, 7), a[2]);
    try std.testing.expectEqual(@as(i32, 1), a[3]);
    try std.testing.expectEqual(@as(i32, 2), a[4]);
    try std.testing.expectEqual(@as(i32, 3), a[5]);
    try std.testing.expectEqual(@as(i32, 4), a[6]);

    var b = [_]i32{ -1, -100, 3, 99 };
    rotate(&b, 4, 2);
    try std.testing.expectEqual(@as(i32, 3), b[0]);
    try std.testing.expectEqual(@as(i32, 99), b[1]);
    try std.testing.expectEqual(@as(i32, -1), b[2]);
    try std.testing.expectEqual(@as(i32, -100), b[3]);
}

test "rotate edges" {
    // k larger than the array size wraps around
    var a = [_]i32{ 1, 2, 3 };
    rotate(&a, 3, 4);
    try std.testing.expectEqual(@as(i32, 3), a[0]);
    try std.testing.expectEqual(@as(i32, 1), a[1]);
    try std.testing.expectEqual(@as(i32, 2), a[2]);

    var one = [_]i32{7};
    rotate(&one, 1, 5);
    try std.testing.expectEqual(@as(i32, 7), one[0]);

    var same = [_]i32{ 1, 2, 3 };
    rotate(&same, 3, 3);
    try std.testing.expectEqual(@as(i32, 1), same[0]);
    try std.testing.expectEqual(@as(i32, 2), same[1]);
    try std.testing.expectEqual(@as(i32, 3), same[2]);
}
