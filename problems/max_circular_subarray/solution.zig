// LeetCode 918. Maximum Sum Circular Subarray
// C signature:  int maxSubarraySumCircular(int* nums, int numsSize);
//
// A best circular subarray is either an ordinary subarray (Kadane max) or the
// whole array minus a non-wrapping minimum subarray (the part left out). When
// every value is negative the "wrap" candidate would be the empty set, so the
// max answer is the least negative single element.
const std = @import("std");

pub fn maxSubarraySumCircular(nums: [*]i32, numsSize: i32) i32 {
    if (numsSize <= 0) return 0;
    var total: i32 = nums[0];
    var maxCur: i32 = nums[0];
    var maxBest: i32 = nums[0];
    var minCur: i32 = nums[0];
    var minBest: i32 = nums[0];
    var i: i32 = 1;
    while (i < numsSize) : (i += 1) {
        const x = nums[@intCast(i)];
        total += x;

        if (maxCur < 0) maxCur = x else maxCur += x;
        if (maxCur > maxBest) maxBest = maxCur;

        if (minCur > 0) minCur = x else minCur += x;
        if (minCur < minBest) minBest = minCur;
    }
    if (maxBest < 0) return maxBest;
    const wrap = total - minBest;
    return @max(maxBest, wrap);
}

test "maxSubarraySumCircular examples" {
    var a = [_]i32{ 1, -2, 3, -2 };
    try std.testing.expectEqual(@as(i32, 3), maxSubarraySumCircular(&a, 4));

    var b = [_]i32{ 5, -3, 5 };
    try std.testing.expectEqual(@as(i32, 10), maxSubarraySumCircular(&b, 3));

    var c = [_]i32{ -3, -2, -3 };
    try std.testing.expectEqual(@as(i32, -2), maxSubarraySumCircular(&c, 3));
}

test "maxSubarraySumCircular edges" {
    // single element, positive and negative
    var one = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 1), maxSubarraySumCircular(&one, 1));
    var negOne = [_]i32{-7};
    try std.testing.expectEqual(@as(i32, -7), maxSubarraySumCircular(&negOne, 1));

    // fully wrapping is the whole array
    var all = [_]i32{ 3, 1, 4, 1, 5 };
    try std.testing.expectEqual(@as(i32, 14), maxSubarraySumCircular(&all, 5));

    // all equal negatives
    var eq = [_]i32{ -2, -2, -2, -2 };
    try std.testing.expectEqual(@as(i32, -2), maxSubarraySumCircular(&eq, 4));

    // wrap-around beats the best non-wrapping run
    var wrap = [_]i32{ 3, -1, 2, -1 };
    try std.testing.expectEqual(@as(i32, 4), maxSubarraySumCircular(&wrap, 4));

    var big = [_]i32{ -1, 40, -1 };
    try std.testing.expectEqual(@as(i32, 40), maxSubarraySumCircular(&big, 3));

    // zeros alongside a positive
    var z = [_]i32{ 0, 0, 5, 0 };
    try std.testing.expectEqual(@as(i32, 5), maxSubarraySumCircular(&z, 4));
}
