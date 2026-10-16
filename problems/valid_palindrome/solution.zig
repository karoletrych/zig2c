// LeetCode 125. Valid Palindrome
// C signature:  bool isPalindrome(char* s);
//
// Two pointers: skip everything that is not alphanumeric, then compare the
// lowercased characters. The classification/lowercasing is written by hand so
// the generated C does not depend on the std.ascii helper chain.
const std = @import("std");

fn isAlnum(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9');
}

fn toLower(c: u8) u8 {
    if (c >= 'A' and c <= 'Z') return c + 32;
    return c;
}

pub fn isPalindrome(s: [*]u8) bool {
    const a = std.mem.sliceTo(s, 0);
    var i: usize = 0;
    var j: usize = a.len;
    while (i < j) {
        while (i < j and !isAlnum(a[i])) i += 1;
        while (i < j and !isAlnum(a[j - 1])) j -= 1;
        if (i >= j) break;
        if (toLower(a[i]) != toLower(a[j - 1])) return false;
        i += 1;
        j -= 1;
    }
    return true;
}

test "isPalindrome examples" {
    try std.testing.expect(isPalindrome(@constCast("A man, a plan, a canal: Panama")));
    try std.testing.expect(!isPalindrome(@constCast("race a car")));
}

test "isPalindrome edges" {
    try std.testing.expect(isPalindrome(@constCast(" ")));
    try std.testing.expect(isPalindrome(@constCast("")));
    try std.testing.expect(isPalindrome(@constCast("a")));
    try std.testing.expect(isPalindrome(@constCast(".,")));
    try std.testing.expect(!isPalindrome(@constCast("0P")));
    try std.testing.expect(isPalindrome(@constCast("ab_a")));
    try std.testing.expect(isPalindrome(@constCast("A1b2B1a")));
    try std.testing.expect(isPalindrome(@constCast("12321")));
    try std.testing.expect(!isPalindrome(@constCast("1231")));
}
