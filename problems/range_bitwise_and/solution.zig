// LeetCode 201. Bitwise AND of Numbers Range
// C signature:  int rangeBitwiseAnd(int left, int right);
//
// Shift both ends right until they meet; the bits they still share are exactly
// the common high bits, and everything below is cleared by the range.
const std = @import("std");

pub fn rangeBitwiseAnd(left: i32, right: i32) i32 {
    var l = left;
    var r = right;
    var s: i32 = 0;
    while (l < r) {
        l >>= 1;
        r >>= 1;
        s += 1;
    }
    return l << @intCast(s);
}

test "rangeBitwiseAnd examples" {
    try std.testing.expectEqual(@as(i32, 4), rangeBitwiseAnd(5, 7));
    try std.testing.expectEqual(@as(i32, 0), rangeBitwiseAnd(0, 0));
    try std.testing.expectEqual(@as(i32, 0), rangeBitwiseAnd(1, 2147483647));
}

test "rangeBitwiseAnd edges" {
    try std.testing.expectEqual(@as(i32, 5), rangeBitwiseAnd(5, 5));
    try std.testing.expectEqual(@as(i32, 6), rangeBitwiseAnd(6, 7));
    try std.testing.expectEqual(@as(i32, 0), rangeBitwiseAnd(0, 1));
    try std.testing.expectEqual(@as(i32, 8), rangeBitwiseAnd(8, 15));
    try std.testing.expectEqual(@as(i32, 2147483646), rangeBitwiseAnd(2147483646, 2147483647));
    try std.testing.expectEqual(@as(i32, 0), rangeBitwiseAnd(0, 2147483647));
    try std.testing.expectEqual(@as(i32, 12), rangeBitwiseAnd(12, 13));
}
