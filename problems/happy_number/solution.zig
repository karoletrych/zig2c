// LeetCode 202. Happy Number
// C signature:  bool isHappy(int n);
//
// Repeatedly replace n by the sum of the squares of its digits. After the first
// step the value is below 1000 (the worst 31-bit case is 730), so a 1000-slot
// seen table detects a cycle; reaching 1 means the number is happy.
const std = @import("std");

pub fn isHappy(n: i32) bool {
    var seen: [1000]bool = undefined;
    var i: usize = 0;
    while (i < 1000) : (i += 1) seen[i] = false;

    var x: i64 = n;
    while (x != 1) {
        if (x < 1000) {
            if (seen[@intCast(x)]) return false;
            seen[@intCast(x)] = true;
        }
        var sum: i64 = 0;
        while (x > 0) {
            const d = @mod(x, 10);
            sum += d * d;
            x = @divTrunc(x, 10);
        }
        x = sum;
    }
    return true;
}

test "isHappy examples" {
    try std.testing.expect(isHappy(19));
    try std.testing.expect(!isHappy(2));
    try std.testing.expect(isHappy(1));
    try std.testing.expect(isHappy(7));
    try std.testing.expect(!isHappy(4));
    try std.testing.expect(!isHappy(2147483647));
}
