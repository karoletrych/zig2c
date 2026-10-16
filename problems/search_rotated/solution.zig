// LeetCode 33. Search in Rotated Sorted Array
// C signature:  int search(int* nums, int numsSize, int target);
//
// At each step one of the two halves around `mid` is a genuine sorted run. Test
// whether the target lies inside that sorted half; if so search it, otherwise
// search the other half. Values are distinct.
const std = @import("std");

pub fn search(nums: [*]i32, numsSize: i32, target: i32) i32 {
    var lo: i32 = 0;
    var hi: i32 = numsSize - 1;
    while (lo <= hi) {
        const mid = lo + @divTrunc(hi - lo, 2);
        const v = nums[@intCast(mid)];
        if (v == target) return mid;
        if (nums[@intCast(lo)] <= v) {
            // left half [lo, mid] is sorted
            if (nums[@intCast(lo)] <= target and target < v) {
                hi = mid - 1;
            } else {
                lo = mid + 1;
            }
        } else {
            // right half [mid, hi] is sorted
            if (v < target and target <= nums[@intCast(hi)]) {
                lo = mid + 1;
            } else {
                hi = mid - 1;
            }
        }
    }
    return -1;
}

test "search examples" {
    var a = [_]i32{ 4, 5, 6, 7, 0, 1, 2 };
    try std.testing.expectEqual(@as(i32, 4), search(&a, 7, 0));
    try std.testing.expectEqual(@as(i32, -1), search(&a, 7, 3));
}

test "search edges" {
    var one = [_]i32{1};
    try std.testing.expectEqual(@as(i32, -1), search(&one, 1, 0));
    try std.testing.expectEqual(@as(i32, 0), search(&one, 1, 1));

    var two = [_]i32{ 1, 3 };
    try std.testing.expectEqual(@as(i32, 1), search(&two, 2, 3));
    try std.testing.expectEqual(@as(i32, 0), search(&two, 2, 1));
    try std.testing.expectEqual(@as(i32, -1), search(&two, 2, 2));

    var three = [_]i32{ 5, 1, 3 };
    try std.testing.expectEqual(@as(i32, 0), search(&three, 3, 5));
    try std.testing.expectEqual(@as(i32, 1), search(&three, 3, 1));
    try std.testing.expectEqual(@as(i32, 2), search(&three, 3, 3));

    var asc = [_]i32{ 1, 3, 5, 7 };
    try std.testing.expectEqual(@as(i32, 3), search(&asc, 4, 7));
    try std.testing.expectEqual(@as(i32, 0), search(&asc, 4, 1));
    try std.testing.expectEqual(@as(i32, -1), search(&asc, 4, 4));

    var rot = [_]i32{ 7, 8, 1, 2, 3, 4, 5, 6 };
    try std.testing.expectEqual(@as(i32, 3), search(&rot, 8, 2));
    try std.testing.expectEqual(@as(i32, 0), search(&rot, 8, 7));
    try std.testing.expectEqual(@as(i32, 7), search(&rot, 8, 6));
    try std.testing.expectEqual(@as(i32, -1), search(&rot, 8, 9));
}
