// LeetCode 9. Palindrome Number
// C signature:  bool isPalindrome(int x);
//
// Reverse the number in a 64-bit accumulator (so it cannot overflow) and
// compare with the original.
const std = @import("std");

pub fn isPalindrome(x: i32) bool {
    if (x < 0) return false;
    var rev: i64 = 0;
    var y: i64 = x;
    while (y > 0) {
        rev = rev * 10 + @mod(y, 10);
        y = @divTrunc(y, 10);
    }
    return rev == @as(i64, x);
}

test "isPalindrome examples" {
    try std.testing.expect(isPalindrome(121));
    try std.testing.expect(!isPalindrome(-121));
    try std.testing.expect(!isPalindrome(10));
}

test "isPalindrome edges" {
    try std.testing.expect(isPalindrome(0));
    try std.testing.expect(isPalindrome(1));
    try std.testing.expect(isPalindrome(11));
    try std.testing.expect(isPalindrome(12321));
    try std.testing.expect(isPalindrome(2147447412));
    try std.testing.expect(!isPalindrome(100));
    try std.testing.expect(!isPalindrome(1234));
    try std.testing.expect(!isPalindrome(2147483647));
}
