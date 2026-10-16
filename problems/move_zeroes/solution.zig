// LeetCode 283. Move Zeroes
// C signature:  void moveZeroes(int* nums, int numsSize);
const std = @import("std");

pub fn moveZeroes(nums: [*]i32, numsSize: i32) void {
    const n: usize = @intCast(numsSize);
    var w: usize = 0;
    var i: usize = 0;
    while (i < n) : (i += 1) {
        if (nums[i] != 0) {
            nums[w] = nums[i];
            w += 1;
        }
    }
    while (w < n) : (w += 1) {
        nums[w] = 0;
    }
}

test "moveZeroes examples" {
    var a = [_]i32{ 0, 1, 0, 3, 12 };
    moveZeroes(&a, 5);
    try std.testing.expectEqual(@as(i32, 1), a[0]);
    try std.testing.expectEqual(@as(i32, 3), a[1]);
    try std.testing.expectEqual(@as(i32, 12), a[2]);
    try std.testing.expectEqual(@as(i32, 0), a[3]);
    try std.testing.expectEqual(@as(i32, 0), a[4]);

    var b = [_]i32{0};
    moveZeroes(&b, 1);
    try std.testing.expectEqual(@as(i32, 0), b[0]);
}

test "moveZeroes edges" {
    var a = [_]i32{ 1, 2, 3 };
    moveZeroes(&a, 3);
    try std.testing.expectEqual(@as(i32, 1), a[0]);
    try std.testing.expectEqual(@as(i32, 2), a[1]);
    try std.testing.expectEqual(@as(i32, 3), a[2]);

    var b = [_]i32{ 0, 0, 0 };
    moveZeroes(&b, 3);
    try std.testing.expectEqual(@as(i32, 0), b[0]);
    try std.testing.expectEqual(@as(i32, 0), b[1]);
    try std.testing.expectEqual(@as(i32, 0), b[2]);

    var c = [_]i32{ 4, 0, 5, 0, 0, 6 };
    moveZeroes(&c, 6);
    try std.testing.expectEqual(@as(i32, 4), c[0]);
    try std.testing.expectEqual(@as(i32, 5), c[1]);
    try std.testing.expectEqual(@as(i32, 6), c[2]);
    try std.testing.expectEqual(@as(i32, 0), c[3]);
    try std.testing.expectEqual(@as(i32, 0), c[4]);
    try std.testing.expectEqual(@as(i32, 0), c[5]);
}
