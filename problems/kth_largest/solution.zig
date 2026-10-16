// LeetCode 215. Kth Largest Element in an Array  (LeetCode 75)
// C signature:  int findKthLargest(int* nums, int numsSize, int k);
// Demonstrates the std.sort helper: a Zig comparator is lowered to qsort.
const std = @import("std");

fn lessThan(_: void, a: i32, b: i32) bool {
    return a < b;
}

pub fn findKthLargest(nums: [*]i32, numsSize: i32, k: i32) i32 {
    const n: usize = @intCast(numsSize);
    std.mem.sort(i32, nums[0..n], {}, lessThan);
    return nums[n - @as(usize, @intCast(k))];
}

test "findKthLargest" {
    var a = [_]i32{ 3, 2, 1, 5, 6, 4 };
    try std.testing.expectEqual(@as(i32, 5), findKthLargest(&a, 6, 2));
    var b = [_]i32{ 3, 2, 3, 1, 2, 4, 5, 5, 6 };
    try std.testing.expectEqual(@as(i32, 4), findKthLargest(&b, 9, 4));
}
