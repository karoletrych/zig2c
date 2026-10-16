// LeetCode 55. Jump Game
// C signature:  bool canJump(int* nums, int numsSize);
//
// Keep the farthest index reachable so far; fail if a position is unreachable.

const std = @import("std");

pub fn canJump(nums: [*]i32, numsSize: i32) bool {
    var reach: i32 = 0;
    var i: i32 = 0;
    while (i < numsSize) : (i += 1) {
        if (i > reach) return false;
        const r = i + nums[@intCast(i)];
        if (r > reach) reach = r;
    }
    return true;
}

test "canJump examples" {
    var a = [_]i32{ 2, 3, 1, 1, 4 };
    try std.testing.expect(canJump(&a, 5));

    var b = [_]i32{ 3, 2, 1, 0, 4 };
    try std.testing.expect(!canJump(&b, 5));
}

test "canJump edges" {
    var empty = [_]i32{0};
    try std.testing.expect(canJump(&empty, 0));

    var one = [_]i32{0};
    try std.testing.expect(canJump(&one, 1));

    var zero = [_]i32{ 0, 1 };
    try std.testing.expect(!canJump(&zero, 2));

    var zeroAll = [_]i32{ 0, 0, 0 };
    try std.testing.expect(!canJump(&zeroAll, 3));

    var big = [_]i32{ 5, 0, 0, 0, 0, 0 };
    try std.testing.expect(canJump(&big, 6));
}
