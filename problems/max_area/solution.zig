// LeetCode 11. Container With Most Water  (LeetCode 75)
// C signature:  int maxArea(int* height, int heightSize);
const std = @import("std");

pub fn maxArea(height: [*]i32, heightSize: i32) i32 {
    var best: i32 = 0;
    var l: i32 = 0;
    var r: i32 = heightSize - 1;
    while (l < r) {
        const hl = height[@intCast(l)];
        const hr = height[@intCast(r)];
        const h = @min(hl, hr);
        const area = h * (r - l);
        best = @max(best, area);
        if (hl < hr) l += 1 else r -= 1;
    }
    return best;
}

test "maxArea" {
    var a = [_]i32{ 1, 8, 6, 2, 5, 4, 8, 3, 7 };
    try std.testing.expectEqual(@as(i32, 49), maxArea(&a, 9));
    var b = [_]i32{ 1, 1 };
    try std.testing.expectEqual(@as(i32, 1), maxArea(&b, 2));
}
