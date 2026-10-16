// LeetCode 35. Search Insert Position
// C signature:  int searchInsert(int* nums, int numsSize, int target);
//
// Lower-bound binary search over [0, numsSize): returns the first index whose
// value is >= target, which is both the target's position and its insert point.
const std = @import("std");

pub fn searchInsert(nums: [*]i32, numsSize: i32, target: i32) i32 {
    var lo: i32 = 0;
    var hi: i32 = numsSize;
    while (lo < hi) {
        const mid = lo + @divTrunc(hi - lo, 2);
        if (nums[@intCast(mid)] < target) {
            lo = mid + 1;
        } else {
            hi = mid;
        }
    }
    return lo;
}

test "searchInsert examples" {
    var a = [_]i32{ 1, 3, 5, 6 };
    try std.testing.expectEqual(@as(i32, 2), searchInsert(&a, 4, 5));
    try std.testing.expectEqual(@as(i32, 1), searchInsert(&a, 4, 2));
    try std.testing.expectEqual(@as(i32, 4), searchInsert(&a, 4, 7));
}

test "searchInsert edges" {
    var a = [_]i32{ 1, 3, 5, 6 };
    // present at the left edge
    try std.testing.expectEqual(@as(i32, 0), searchInsert(&a, 4, 1));
    // present at the right edge
    try std.testing.expectEqual(@as(i32, 3), searchInsert(&a, 4, 6));
    // smaller than everything
    try std.testing.expectEqual(@as(i32, 0), searchInsert(&a, 4, 0));
    try std.testing.expectEqual(@as(i32, 0), searchInsert(&a, 4, -5));
    // larger than everything
    try std.testing.expectEqual(@as(i32, 4), searchInsert(&a, 4, 100));

    // single element
    var one = [_]i32{4};
    try std.testing.expectEqual(@as(i32, 0), searchInsert(&one, 1, 4));
    try std.testing.expectEqual(@as(i32, 0), searchInsert(&one, 1, 1));
    try std.testing.expectEqual(@as(i32, 1), searchInsert(&one, 1, 9));

    // all equal
    var eq = [_]i32{ 2, 2, 2 };
    try std.testing.expectEqual(@as(i32, 0), searchInsert(&eq, 3, 2));
    try std.testing.expectEqual(@as(i32, 3), searchInsert(&eq, 3, 3));
}
