// LeetCode 27. Remove Element
// C signature:  int removeElement(int* nums, int numsSize, int val);
//
// Write pointer moves only over values that differ from `val`.

const std = @import("std");

pub fn removeElement(nums: [*]i32, numsSize: i32, val: i32) i32 {
    var k: i32 = 0;
    var i: i32 = 0;
    while (i < numsSize) : (i += 1) {
        if (nums[@intCast(i)] != val) {
            nums[@intCast(k)] = nums[@intCast(i)];
            k += 1;
        }
    }
    return k;
}

test "removeElement examples" {
    var a = [_]i32{ 3, 2, 2, 3 };
    try std.testing.expectEqual(@as(i32, 2), removeElement(&a, 4, 3));
    try std.testing.expectEqual(@as(i32, 2), a[0]);
    try std.testing.expectEqual(@as(i32, 2), a[1]);

    var b = [_]i32{ 0, 1, 2, 2, 3, 0, 4, 2 };
    try std.testing.expectEqual(@as(i32, 5), removeElement(&b, 8, 2));
    try std.testing.expectEqual(@as(i32, 0), b[0]);
    try std.testing.expectEqual(@as(i32, 1), b[1]);
    try std.testing.expectEqual(@as(i32, 3), b[2]);
    try std.testing.expectEqual(@as(i32, 0), b[3]);
    try std.testing.expectEqual(@as(i32, 4), b[4]);
}

test "removeElement edges" {
    var empty = [_]i32{0};
    try std.testing.expectEqual(@as(i32, 0), removeElement(&empty, 0, 5));

    var all = [_]i32{ 7, 7, 7 };
    try std.testing.expectEqual(@as(i32, 0), removeElement(&all, 3, 7));

    var none = [_]i32{ 1, 2, 3 };
    try std.testing.expectEqual(@as(i32, 3), removeElement(&none, 3, 9));

    var one = [_]i32{4};
    try std.testing.expectEqual(@as(i32, 1), removeElement(&one, 1, 5));
}
