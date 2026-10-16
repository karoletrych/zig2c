// LeetCode 1679. Max Number of K-Sum Pairs
// C signature:  int maxOperations(int* nums, int numsSize, int k);
const std = @import("std");

fn lessThan(_: void, a: i32, b: i32) bool {
    return a < b;
}

pub fn maxOperations(nums: [*]i32, numsSize: i32, k: i32) i32 {
    const n: usize = @intCast(numsSize);
    if (n < 2) return 0;
    std.mem.sort(i32, nums[0..n], {}, lessThan);

    var l: usize = 0;
    var r: usize = n - 1;
    var count: i32 = 0;
    while (l < r) {
        const sum = nums[l] + nums[r];
        if (sum == k) {
            count += 1;
            l += 1;
            r -= 1;
        } else if (sum < k) {
            l += 1;
        } else {
            r -= 1;
        }
    }
    return count;
}

test "maxOperations examples" {
    var a = [_]i32{ 1, 2, 3, 4 };
    try std.testing.expectEqual(@as(i32, 2), maxOperations(&a, 4, 5));

    var b = [_]i32{ 3, 1, 3, 4, 3 };
    try std.testing.expectEqual(@as(i32, 1), maxOperations(&b, 5, 6));
}

test "maxOperations edges" {
    var a = [_]i32{ 1, 2, 3, 4 };
    try std.testing.expectEqual(@as(i32, 0), maxOperations(&a, 4, 100));

    var b = [_]i32{ 2, 2, 2, 2 };
    try std.testing.expectEqual(@as(i32, 2), maxOperations(&b, 4, 4));

    var c = [_]i32{ 4, 4, 1, 3, 1, 3, 2, 2, 5, 5, 5, 5, 5 };
    try std.testing.expectEqual(@as(i32, 5), maxOperations(&c, 13, 6));

    var d = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 0), maxOperations(&d, 1, 2));
}
