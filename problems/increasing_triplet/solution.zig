// LeetCode 334. Increasing Triplet Subsequence
// C signature:  bool increasingTriplet(int* nums, int numsSize);
const std = @import("std");

pub fn increasingTriplet(nums: [*]i32, numsSize: i32) bool {
    const n: usize = @intCast(numsSize);
    var first: i32 = 2147483647;
    var second: i32 = 2147483647;
    var i: usize = 0;
    while (i < n) : (i += 1) {
        const x = nums[i];
        if (x <= first) {
            first = x;
        } else if (x <= second) {
            second = x;
        } else {
            return true;
        }
    }
    return false;
}

test "increasingTriplet examples" {
    var a = [_]i32{ 1, 2, 3, 4, 5 };
    try std.testing.expect(increasingTriplet(&a, 5));

    var b = [_]i32{ 5, 4, 3, 2, 1 };
    try std.testing.expect(!increasingTriplet(&b, 5));

    var c = [_]i32{ 2, 1, 5, 0, 4, 6 };
    try std.testing.expect(increasingTriplet(&c, 6));
}

test "increasingTriplet edges" {
    var a = [_]i32{ 1, 2, 3 };
    try std.testing.expect(increasingTriplet(&a, 3));

    var b = [_]i32{ 1, 1, 1 };
    try std.testing.expect(!increasingTriplet(&b, 3));

    var c = [_]i32{ 1, 2 };
    try std.testing.expect(!increasingTriplet(&c, 2));

    var d = [_]i32{ 20, 100, 10, 12, 5, 13 };
    try std.testing.expect(increasingTriplet(&d, 6));

    var e = [_]i32{ 1, 5, 0, 4, 1, 3 };
    try std.testing.expect(increasingTriplet(&e, 6));
}
