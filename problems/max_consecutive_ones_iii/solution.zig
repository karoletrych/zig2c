// LeetCode 1004. Max Consecutive Ones III
// C signature:  int longestOnes(int* nums, int numsSize, int k);
const std = @import("std");

pub fn longestOnes(nums: [*]i32, numsSize: i32, k: i32) i32 {
    var left: i32 = 0;
    var zeros: i32 = 0;
    var best: i32 = 0;
    var right: i32 = 0;
    while (right < numsSize) : (right += 1) {
        if (nums[@intCast(right)] == 0) zeros += 1;
        while (zeros > k) {
            if (nums[@intCast(left)] == 0) zeros -= 1;
            left += 1;
        }
        const len = right - left + 1;
        if (len > best) best = len;
    }
    return best;
}

test "longestOnes" {
    var a = [_]i32{ 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0 };
    try std.testing.expectEqual(@as(i32, 6), longestOnes(&a, 11, 2));

    var b = [_]i32{ 0, 0, 1, 1, 1, 0, 0 };
    try std.testing.expectEqual(@as(i32, 3), longestOnes(&b, 7, 0));

    var c = [_]i32{ 1, 1, 1, 1 };
    try std.testing.expectEqual(@as(i32, 4), longestOnes(&c, 4, 0));

    var d = [_]i32{ 0, 0, 0 };
    try std.testing.expectEqual(@as(i32, 3), longestOnes(&d, 3, 5));
}
