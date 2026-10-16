// LeetCode 42. Trapping Rain Water
// C signature:  int trap(int* height, int heightSize);
//
// Two pointers. Move the side with the smaller current maximum; the water above
// that bar is bounded by that maximum.

const std = @import("std");

pub fn trap(height: [*]i32, heightSize: i32) i32 {
    if (heightSize <= 2) return 0;
    var lo: i32 = 0;
    var hi: i32 = heightSize - 1;
    var leftMax: i32 = height[0];
    var rightMax: i32 = height[@intCast(hi)];
    var water: i32 = 0;
    while (lo < hi) {
        if (leftMax <= rightMax) {
            lo += 1;
            if (height[@intCast(lo)] > leftMax) {
                leftMax = height[@intCast(lo)];
            } else {
                water += leftMax - height[@intCast(lo)];
            }
        } else {
            hi -= 1;
            if (height[@intCast(hi)] > rightMax) {
                rightMax = height[@intCast(hi)];
            } else {
                water += rightMax - height[@intCast(hi)];
            }
        }
    }
    return water;
}

test "trap examples" {
    var a = [_]i32{ 0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1 };
    try std.testing.expectEqual(@as(i32, 6), trap(&a, 12));

    var b = [_]i32{ 4, 2, 0, 3, 2, 5 };
    try std.testing.expectEqual(@as(i32, 9), trap(&b, 6));
}

test "trap edges" {
    var empty = [_]i32{0};
    try std.testing.expectEqual(@as(i32, 0), trap(&empty, 0));

    var one = [_]i32{5};
    try std.testing.expectEqual(@as(i32, 0), trap(&one, 1));

    var two = [_]i32{ 3, 4 };
    try std.testing.expectEqual(@as(i32, 0), trap(&two, 2));

    var flat = [_]i32{ 2, 2, 2 };
    try std.testing.expectEqual(@as(i32, 0), trap(&flat, 3));

    var bowl = [_]i32{ 5, 0, 5 };
    try std.testing.expectEqual(@as(i32, 5), trap(&bowl, 3));
}
