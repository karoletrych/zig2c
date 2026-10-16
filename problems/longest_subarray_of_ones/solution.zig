// LeetCode 1493. Longest Subarray of 1's After Deleting One Element
// C signature:  int longestSubarray(int* nums, int numsSize);
const std = @import("std");

pub fn longestSubarray(nums: [*]i32, numsSize: i32) i32 {
    var left: i32 = 0;
    var zeros: i32 = 0;
    var best: i32 = 0;
    var right: i32 = 0;
    while (right < numsSize) : (right += 1) {
        if (nums[@intCast(right)] == 0) zeros += 1;
        while (zeros > 1) {
            if (nums[@intCast(left)] == 0) zeros -= 1;
            left += 1;
        }
        const len = right - left + 1;
        if (len > best) best = len;
    }
    return best - 1;
}

test "longestSubarray" {
    var a = [_]i32{ 1, 1, 0, 1 };
    try std.testing.expectEqual(@as(i32, 3), longestSubarray(&a, 4));

    var b = [_]i32{ 0, 1, 1, 1, 0, 1, 1, 0, 1 };
    try std.testing.expectEqual(@as(i32, 5), longestSubarray(&b, 9));

    var c = [_]i32{ 1, 1, 1 };
    try std.testing.expectEqual(@as(i32, 2), longestSubarray(&c, 3));

    var d = [_]i32{ 0, 0, 0 };
    try std.testing.expectEqual(@as(i32, 0), longestSubarray(&d, 3));

    var e = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 0), longestSubarray(&e, 1));
}
