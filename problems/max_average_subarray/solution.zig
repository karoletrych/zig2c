// LeetCode 643. Maximum Average Subarray I
// C signature:  double findMaxAverage(int* nums, int numsSize, int k);
const std = @import("std");

pub fn findMaxAverage(nums: [*]i32, numsSize: i32, k: i32) f64 {
    var sum: i64 = 0;
    var i: i32 = 0;
    while (i < k) : (i += 1) {
        sum += nums[@intCast(i)];
    }
    var best: i64 = sum;
    i = k;
    while (i < numsSize) : (i += 1) {
        sum += nums[@intCast(i)] - nums[@intCast(i - k)];
        if (sum > best) best = sum;
    }
    const bf: f64 = @floatFromInt(best);
    const kf: f64 = @floatFromInt(k);
    return bf / kf;
}

test "findMaxAverage" {
    var nums = [_]i32{ 1, 12, -5, -6, 50, 3 };
    try std.testing.expectApproxEqAbs(@as(f64, 12.75), findMaxAverage(&nums, 6, 4), 1e-9);

    var one = [_]i32{5};
    try std.testing.expectApproxEqAbs(@as(f64, 5.0), findMaxAverage(&one, 1, 1), 1e-9);

    var neg = [_]i32{ -1, -2, -3, -4 };
    try std.testing.expectApproxEqAbs(@as(f64, -1.5), findMaxAverage(&neg, 4, 2), 1e-9);
}
