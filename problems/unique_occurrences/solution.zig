// LeetCode 1207. Unique Number of Occurrences
// C signature:  bool uniqueOccurrences(int* arr, int arrSize);
// Values are in [-1000, 1000]; counts are at most arrSize (<= 1000).
const std = @import("std");

pub fn uniqueOccurrences(arr: [*]i32, arrSize: i32) bool {
    var cnt: [2001]i32 = undefined;
    var i: usize = 0;
    while (i < 2001) : (i += 1) cnt[i] = 0;

    var j: i32 = 0;
    while (j < arrSize) : (j += 1) {
        cnt[@intCast(arr[@intCast(j)] + 1000)] += 1;
    }

    var seen: [1001]bool = undefined;
    i = 0;
    while (i < 1001) : (i += 1) seen[i] = false;

    i = 0;
    while (i < 2001) : (i += 1) {
        const c: i32 = cnt[i];
        if (c > 0) {
            const idx: usize = @intCast(c);
            if (seen[idx]) return false;
            seen[idx] = true;
        }
    }
    return true;
}

test "uniqueOccurrences" {
    var a = [_]i32{ 1, 2, 2, 1, 1, 3 };
    try std.testing.expect(uniqueOccurrences(&a, 6));

    var b = [_]i32{ 1, 2 };
    try std.testing.expect(!uniqueOccurrences(&b, 2));

    var c = [_]i32{ -3, 0, 1, -3, 1, 1, 1, -3, 10, 0 };
    try std.testing.expect(uniqueOccurrences(&c, 10));

    var d = [_]i32{3};
    try std.testing.expect(uniqueOccurrences(&d, 1));
}
