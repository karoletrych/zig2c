// LeetCode 1. Two Sum  (part of the LeetCode 75 study plan)
//
// The signature mirrors the LeetCode-C signature exactly:
//   int* twoSum(int* nums, int numsSize, int target, int* returnSize);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn twoSum(nums: [*]i32, numsSize: i32, target: i32, returnSize: *i32) ?[*]i32 {
    var i: i32 = 0;
    while (i < numsSize) : (i += 1) {
        var j: i32 = i + 1;
        while (j < numsSize) : (j += 1) {
            if (nums[@intCast(i)] + nums[@intCast(j)] == target) {
                const out = allocator.alloc(i32, 2) catch unreachable;
                out[0] = i;
                out[1] = j;
                returnSize.* = 2;
                return out.ptr;
            }
        }
    }
    returnSize.* = 0;
    return null;
}

test "twoSum finds the pair" {
    var arr = [_]i32{ 2, 7, 11, 15 };
    var rs: i32 = 0;
    const r = twoSum(&arr, 4, 9, &rs).?;
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, 0), r[0]);
    try std.testing.expectEqual(@as(i32, 1), r[1]);
}
