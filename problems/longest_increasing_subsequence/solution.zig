// LeetCode 300. Longest Increasing Subsequence
// C signature:  int lengthOfLIS(int* nums, int numsSize);
//
// Patience sorting: tails[k] is the smallest tail of any increasing
// subsequence of length k+1. Binary search the first tail >= x and replace it.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn lengthOfLIS(nums: [*]i32, numsSize: i32) i32 {
    if (numsSize == 0) return 0;

    const tails = allocator.alloc(i32, @intCast(numsSize)) catch unreachable;
    var size: usize = 0;

    var i: i32 = 0;
    while (i < numsSize) : (i += 1) {
        const x = nums[@intCast(i)];
        var lo: usize = 0;
        var hi: usize = size;
        while (lo < hi) {
            const mid = lo + @divTrunc(hi - lo, 2);
            if (tails[mid] < x) {
                lo = mid + 1;
            } else {
                hi = mid;
            }
        }
        tails[lo] = x;
        if (lo == size) size += 1;
    }

    allocator.free(tails);
    return @as(i32, @intCast(size));
}

test "lengthOfLIS examples" {
    var a = [_]i32{ 10, 9, 2, 5, 3, 7, 101, 18 };
    try std.testing.expectEqual(@as(i32, 4), lengthOfLIS(&a, 8));

    var b = [_]i32{ 0, 1, 0, 3, 2, 3 };
    try std.testing.expectEqual(@as(i32, 4), lengthOfLIS(&b, 6));

    var c = [_]i32{ 7, 7, 7, 7, 7, 7, 7 };
    try std.testing.expectEqual(@as(i32, 1), lengthOfLIS(&c, 7));
}

test "lengthOfLIS edges" {
    var a = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 1), lengthOfLIS(&a, 1));

    var b = [_]i32{ 2, 1 };
    try std.testing.expectEqual(@as(i32, 1), lengthOfLIS(&b, 2));

    var c = [_]i32{ 1, 2, 3, 4, 5 };
    try std.testing.expectEqual(@as(i32, 5), lengthOfLIS(&c, 5));

    var d = [_]i32{ 5, 4, 3, 2, 1 };
    try std.testing.expectEqual(@as(i32, 1), lengthOfLIS(&d, 5));

    var e = [_]i32{ -3, -2, -1, 0 };
    try std.testing.expectEqual(@as(i32, 4), lengthOfLIS(&e, 4));

    try std.testing.expectEqual(@as(i32, 0), lengthOfLIS(undefined, 0));
}
