// LeetCode 383. Ransom Note
// C signature:  bool canConstruct(char* ransomNote, char* magazine);
//
// A fixed 256-slot letter count of the magazine; every note letter consumes one.
const std = @import("std");

pub fn canConstruct(ransomNote: [*]u8, magazine: [*]u8) bool {
    const note = std.mem.sliceTo(ransomNote, 0);
    const mag = std.mem.sliceTo(magazine, 0);

    var counts: [256]i32 = undefined;
    var i: usize = 0;
    while (i < 256) : (i += 1) counts[i] = 0;

    for (mag) |c| {
        const ci: usize = @intCast(c);
        counts[ci] += 1;
    }

    for (note) |c| {
        const ci: usize = @intCast(c);
        if (counts[ci] == 0) return false;
        counts[ci] -= 1;
    }
    return true;
}

test "canConstruct examples" {
    try std.testing.expect(!canConstruct(@constCast("a"), @constCast("b")));
    try std.testing.expect(!canConstruct(@constCast("aa"), @constCast("ab")));
    try std.testing.expect(canConstruct(@constCast("aa"), @constCast("aab")));
    try std.testing.expect(canConstruct(@constCast(""), @constCast("anything")));
    try std.testing.expect(!canConstruct(@constCast("x"), @constCast("")));
    try std.testing.expect(canConstruct(@constCast("abc"), @constCast("cbad")));
}
