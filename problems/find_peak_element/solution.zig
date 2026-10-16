// LeetCode 162. Find Peak Element
// C signature:  int findPeakElement(int* nums, int numsSize);
//
// Binary search on the slope: if nums[mid] < nums[mid + 1] a peak (or a rising
// run ending in one) must exist to the right, otherwise to the left.
const std = @import("std");

pub fn findPeakElement(nums: [*]i32, numsSize: i32) i32 {
    var lo: i32 = 0;
    var hi: i32 = numsSize - 1;
    while (lo < hi) {
        const mid = lo + @divTrunc(hi - lo, 2);
        if (nums[@intCast(mid)] < nums[@intCast(mid + 1)]) {
            lo = mid + 1;
        } else {
            hi = mid;
        }
    }
    return lo;
}

test "findPeakElement examples" {
    var a = [_]i32{ 1, 2, 3, 1 };
    try std.testing.expectEqual(@as(i32, 2), findPeakElement(&a, 4));

    var b = [_]i32{ 1, 2, 1, 3, 5, 6, 4 };
    try std.testing.expectEqual(@as(i32, 5), findPeakElement(&b, 7));
}

test "findPeakElement edges" {
    var a = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 0), findPeakElement(&a, 1));

    var b = [_]i32{ 3, 2, 1 };
    try std.testing.expectEqual(@as(i32, 0), findPeakElement(&b, 3));

    var c = [_]i32{ 1, 2, 3 };
    try std.testing.expectEqual(@as(i32, 2), findPeakElement(&c, 3));

    var d = [_]i32{ 1, 2 };
    try std.testing.expectEqual(@as(i32, 1), findPeakElement(&d, 2));

    var e = [_]i32{ 2, 1 };
    try std.testing.expectEqual(@as(i32, 0), findPeakElement(&e, 2));
}
