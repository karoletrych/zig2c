// LeetCode 45. Jump Game II
// C signature:  int jump(int* nums, int numsSize);
//
// Greedy BFS over jump "levels": within the current level, remember how far the
// next level can reach; when the level is exhausted, take one more jump.

const std = @import("std");

pub fn jump(nums: [*]i32, numsSize: i32) i32 {
    if (numsSize <= 1) return 0;
    var jumps: i32 = 0;
    var curEnd: i32 = 0;
    var farthest: i32 = 0;
    var i: i32 = 0;
    while (i < numsSize - 1) : (i += 1) {
        const r = i + nums[@intCast(i)];
        if (r > farthest) farthest = r;
        if (i == curEnd) {
            jumps += 1;
            curEnd = farthest;
        }
    }
    return jumps;
}

test "jump examples" {
    var a = [_]i32{ 2, 3, 1, 1, 4 };
    try std.testing.expectEqual(@as(i32, 2), jump(&a, 5));

    var b = [_]i32{ 2, 3, 0, 1, 4 };
    try std.testing.expectEqual(@as(i32, 2), jump(&b, 5));
}

test "jump edges" {
    var empty = [_]i32{0};
    try std.testing.expectEqual(@as(i32, 0), jump(&empty, 0));

    var one = [_]i32{0};
    try std.testing.expectEqual(@as(i32, 0), jump(&one, 1));

    var two = [_]i32{ 1, 1 };
    try std.testing.expectEqual(@as(i32, 1), jump(&two, 2));

    var allOnes = [_]i32{ 1, 1, 1, 1 };
    try std.testing.expectEqual(@as(i32, 3), jump(&allOnes, 4));

    var big = [_]i32{ 9, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    try std.testing.expectEqual(@as(i32, 1), jump(&big, 10));
}
