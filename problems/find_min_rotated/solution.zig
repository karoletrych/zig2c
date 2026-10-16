// LeetCode 153. Find Minimum in Rotated Sorted Array
// C signature:  int findMin(int* nums, int numsSize);
//
// Compare the middle with the right end: if the middle is smaller, the minimum
// lies in [lo, mid]; otherwise it lies in (mid, hi]. Values are distinct.
const std = @import("std");

pub fn findMin(nums: [*]i32, numsSize: i32) i32 {
    var lo: i32 = 0;
    var hi: i32 = numsSize - 1;
    while (lo < hi) {
        const mid = lo + @divTrunc(hi - lo, 2);
        if (nums[@intCast(mid)] < nums[@intCast(hi)]) {
            hi = mid;
        } else {
            lo = mid + 1;
        }
    }
    return nums[@intCast(lo)];
}

test "findMin examples" {
    var a = [_]i32{ 3, 4, 5, 1, 2 };
    try std.testing.expectEqual(@as(i32, 1), findMin(&a, 5));

    var b = [_]i32{ 4, 5, 6, 7, 0, 1, 2 };
    try std.testing.expectEqual(@as(i32, 0), findMin(&b, 7));

    var c = [_]i32{ 11, 13, 15, 17 };
    try std.testing.expectEqual(@as(i32, 11), findMin(&c, 4));
}

test "findMin edges" {
    var one = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 1), findMin(&one, 1));

    var two = [_]i32{ 2, 1 };
    try std.testing.expectEqual(@as(i32, 1), findMin(&two, 2));

    var twoAsc = [_]i32{ 1, 2 };
    try std.testing.expectEqual(@as(i32, 1), findMin(&twoAsc, 2));

    var three = [_]i32{ 2, 3, 1 };
    try std.testing.expectEqual(@as(i32, 1), findMin(&three, 3));

    var three2 = [_]i32{ 3, 1, 2 };
    try std.testing.expectEqual(@as(i32, 1), findMin(&three2, 3));

    var rev3 = [_]i32{ 2, 1, 0 };
    try std.testing.expectEqual(@as(i32, 0), findMin(&rev3, 3));

    // rotated by one at the high end
    var rot = [_]i32{ 5, 1, 2, 3, 4 };
    try std.testing.expectEqual(@as(i32, 1), findMin(&rot, 5));

    // negative values
    var neg = [_]i32{ 3, -2, -1, 0, 1 };
    try std.testing.expectEqual(@as(i32, -2), findMin(&neg, 5));
}
