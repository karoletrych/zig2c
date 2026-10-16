// LeetCode 209. Minimum Size Subarray Sum
// C signature:  int minSubArrayLen(int target, int* nums, int numsSize);
//
// Sliding window over the positive values: grow the right edge by one, then
// shrink the left edge while the window sum still reaches the target.
const std = @import("std");

pub fn minSubArrayLen(target: i32, nums: [*]i32, numsSize: i32) i32 {
    var best: i32 = numsSize + 1;
    var sum: i32 = 0;
    var left: i32 = 0;
    var right: i32 = 0;
    while (right < numsSize) : (right += 1) {
        sum += nums[@intCast(right)];
        while (sum >= target) {
            const w = right - left + 1;
            if (w < best) best = w;
            sum -= nums[@intCast(left)];
            left += 1;
        }
    }
    if (best > numsSize) return 0;
    return best;
}

test "minSubArrayLen examples" {
    var a = [_]i32{ 2, 3, 1, 2, 4, 3 };
    try std.testing.expectEqual(@as(i32, 2), minSubArrayLen(7, &a, 6));

    var b = [_]i32{ 1, 4, 4 };
    try std.testing.expectEqual(@as(i32, 1), minSubArrayLen(4, &b, 3));

    var c = [_]i32{ 1, 1, 1, 1, 1, 1, 1, 1 };
    try std.testing.expectEqual(@as(i32, 0), minSubArrayLen(11, &c, 8));
}

test "minSubArrayLen edges" {
    var a = [_]i32{5};
    try std.testing.expectEqual(@as(i32, 1), minSubArrayLen(5, &a, 1));
    try std.testing.expectEqual(@as(i32, 0), minSubArrayLen(6, &a, 1));

    var b = [_]i32{ 1, 2, 3, 4, 5 };
    try std.testing.expectEqual(@as(i32, 5), minSubArrayLen(15, &b, 5));
    try std.testing.expectEqual(@as(i32, 2), minSubArrayLen(9, &b, 5));

    var c = [_]i32{ 10, 2, 3 };
    try std.testing.expectEqual(@as(i32, 1), minSubArrayLen(10, &c, 3));
}
