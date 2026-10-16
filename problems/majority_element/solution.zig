// LeetCode 169. Majority Element
// C signature:  int majorityElement(int* nums, int numsSize);
//
// Boyer-Moore voting: the majority element survives cancellation.

const std = @import("std");

pub fn majorityElement(nums: [*]i32, numsSize: i32) i32 {
    var cand: i32 = nums[0];
    var count: i32 = 0;
    var i: i32 = 0;
    while (i < numsSize) : (i += 1) {
        const v = nums[@intCast(i)];
        if (count == 0) {
            cand = v;
            count = 1;
        } else if (v == cand) {
            count += 1;
        } else {
            count -= 1;
        }
    }
    return cand;
}

test "majorityElement examples" {
    var a = [_]i32{ 3, 2, 3 };
    try std.testing.expectEqual(@as(i32, 3), majorityElement(&a, 3));

    var b = [_]i32{ 2, 2, 1, 1, 1, 2, 2 };
    try std.testing.expectEqual(@as(i32, 2), majorityElement(&b, 7));
}

test "majorityElement edges" {
    var one = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 1), majorityElement(&one, 1));

    var all = [_]i32{ 5, 5, 5, 5, 5 };
    try std.testing.expectEqual(@as(i32, 5), majorityElement(&all, 5));

    var pair = [_]i32{ 9, 9 };
    try std.testing.expectEqual(@as(i32, 9), majorityElement(&pair, 2));

    var neg = [_]i32{ -1, -1, 2 };
    try std.testing.expectEqual(@as(i32, -1), majorityElement(&neg, 3));
}
