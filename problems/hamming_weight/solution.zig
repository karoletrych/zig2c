// LeetCode 191. Number of 1 Bits
// C signature:  int hammingWeight(uint32_t n);
//
// Clear the lowest set bit repeatedly with n & (n - 1); the number of times the
// loop runs is the popcount.
const std = @import("std");

pub fn hammingWeight(n: u32) i32 {
    var x = n;
    var c: i32 = 0;
    while (x != 0) {
        x = x & (x - 1);
        c += 1;
    }
    return c;
}

test "hammingWeight examples" {
    try std.testing.expectEqual(@as(i32, 3), hammingWeight(11));
    try std.testing.expectEqual(@as(i32, 1), hammingWeight(128));
    try std.testing.expectEqual(@as(i32, 31), hammingWeight(4294967293));
}

test "hammingWeight edges" {
    try std.testing.expectEqual(@as(i32, 0), hammingWeight(0));
    try std.testing.expectEqual(@as(i32, 32), hammingWeight(4294967295));
    try std.testing.expectEqual(@as(i32, 1), hammingWeight(1));
    try std.testing.expectEqual(@as(i32, 16), hammingWeight(0x55555555));
    try std.testing.expectEqual(@as(i32, 16), hammingWeight(0xAAAAAAAA));
}
