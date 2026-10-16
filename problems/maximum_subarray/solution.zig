// LeetCode 53. Maximum Subarray
// C signature:  int maxSubArray(int* nums, int numsSize);
//
// Kadane: `cur` is the best sum of a subarray ending at the current position.
// If the running sum is negative it can only hurt, so start over at nums[i].
const std = @import("std");

pub fn maxSubArray(nums: [*]i32, numsSize: i32) i32 {
    if (numsSize <= 0) return 0;
    var best: i32 = nums[0];
    var cur: i32 = nums[0];
    var i: i32 = 1;
    while (i < numsSize) : (i += 1) {
        const x = nums[@intCast(i)];
        if (cur < 0) cur = x else cur += x;
        if (cur > best) best = cur;
    }
    return best;
}

test "maxSubArray examples" {
    var a = [_]i32{ -2, 1, -3, 4, -1, 2, 1, -5, 4 };
    try std.testing.expectEqual(@as(i32, 6), maxSubArray(&a, 9));

    var b = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 1), maxSubArray(&b, 1));

    var c = [_]i32{ 5, 4, -1, 7, 8 };
    try std.testing.expectEqual(@as(i32, 23), maxSubArray(&c, 5));
}

test "maxSubArray edges" {
    // all negative: the answer is the least negative single element
    var a = [_]i32{ -3, -1, -2 };
    try std.testing.expectEqual(@as(i32, -1), maxSubArray(&a, 3));

    var b = [_]i32{ -8, -3, -6, -2, -5, -4 };
    try std.testing.expectEqual(@as(i32, -2), maxSubArray(&b, 6));

    // all equal / all positive
    var c = [_]i32{ 7, 7, 7, 7 };
    try std.testing.expectEqual(@as(i32, 28), maxSubArray(&c, 4));

    // single negative
    var d = [_]i32{-5};
    try std.testing.expectEqual(@as(i32, -5), maxSubArray(&d, 1));

    // zeros mixed in
    var e = [_]i32{ 0, 0, 0 };
    try std.testing.expectEqual(@as(i32, 0), maxSubArray(&e, 3));
}
