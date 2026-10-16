// LeetCode 190. Reverse Bits
// C signature:  uint32_t reverseBits(uint32_t n);
//
// Shift the result left while shifting the input right, moving the low bit of
// the input into the low bit of the result. Thirty-two iterations handle every
// bit, including the leading zeros.
const std = @import("std");

pub fn reverseBits(n: u32) u32 {
    var x = n;
    var r: u32 = 0;
    var i: u32 = 0;
    while (i < 32) : (i += 1) {
        r = (r << 1) | (x & 1);
        x = x >> 1;
    }
    return r;
}

test "reverseBits examples" {
    try std.testing.expectEqual(@as(u32, 964176192), reverseBits(43261596));
}

test "reverseBits edges" {
    // all zeros and all ones are fixed points
    try std.testing.expectEqual(@as(u32, 0), reverseBits(0));
    try std.testing.expectEqual(@as(u32, 4294967295), reverseBits(4294967295));

    // a single low bit becomes a single high bit and vice versa
    try std.testing.expectEqual(@as(u32, 2147483648), reverseBits(1));
    try std.testing.expectEqual(@as(u32, 1), reverseBits(2147483648));

    // reversing twice is the identity
    try std.testing.expectEqual(@as(u32, 123456789), reverseBits(reverseBits(123456789)));
}
