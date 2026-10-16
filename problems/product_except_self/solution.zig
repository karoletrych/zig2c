// LeetCode 238. Product of Array Except Self  (LeetCode 75)
// C signature:  int* productExceptSelf(int* nums, int numsSize, int* returnSize);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn productExceptSelf(nums: [*]i32, numsSize: i32, returnSize: *i32) [*]i32 {
    const out = allocator.alloc(i32, @intCast(numsSize)) catch unreachable;
    returnSize.* = numsSize;

    var prefix: i32 = 1;
    var i: i32 = 0;
    while (i < numsSize) : (i += 1) {
        out[@intCast(i)] = prefix;
        prefix *= nums[@intCast(i)];
    }

    var suffix: i32 = 1;
    var j: i32 = numsSize - 1;
    while (j >= 0) : (j -= 1) {
        out[@intCast(j)] *= suffix;
        suffix *= nums[@intCast(j)];
    }
    return out.ptr;
}

test "productExceptSelf" {
    var nums = [_]i32{ 1, 2, 3, 4 };
    var rs: i32 = 0;
    const r = productExceptSelf(&nums, 4, &rs);
    try std.testing.expectEqual(@as(i32, 4), rs);
    const want = [_]i32{ 24, 12, 8, 6 };
    for (want, 0..) |w, k| try std.testing.expectEqual(w, r[k]);
}
