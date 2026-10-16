// LeetCode 198. House Robber
// C signature:  int rob(int* nums, int numsSize);
const std = @import("std");

pub fn rob(nums: [*]i32, numsSize: i32) i32 {
    var take: i32 = 0; // best using houses up to i-2, rob i
    var skip: i32 = 0; // best using houses up to i-1
    var i: i32 = 0;
    while (i < numsSize) : (i += 1) {
        const cur = @max(skip, take + nums[@intCast(i)]);
        take = skip;
        skip = cur;
    }
    return skip;
}

test "rob examples" {
    var a = [_]i32{ 1, 2, 3, 1 };
    try std.testing.expectEqual(@as(i32, 4), rob(&a, 4));

    var b = [_]i32{ 2, 7, 9, 3, 1 };
    try std.testing.expectEqual(@as(i32, 12), rob(&b, 5));
}

test "rob edges" {
    var one = [_]i32{5};
    try std.testing.expectEqual(@as(i32, 5), rob(&one, 1));

    var two = [_]i32{ 2, 1 };
    try std.testing.expectEqual(@as(i32, 2), rob(&two, 2));

    var same = [_]i32{ 4, 4, 4, 4 };
    try std.testing.expectEqual(@as(i32, 8), rob(&same, 4));

    var z = [_]i32{ 0, 0, 0 };
    try std.testing.expectEqual(@as(i32, 0), rob(&z, 3));
}
