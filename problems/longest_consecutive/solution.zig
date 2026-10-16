// LeetCode 128. Longest Consecutive Sequence
// C signature:  int longestConsecutive(int* nums, int numsSize);
//
// Sort a private copy, skip duplicates, and count runs of adjacent values. The
// differences are computed in i64 so extreme int32 inputs cannot overflow.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn lessI32(_: void, a: i32, b: i32) bool {
    return a < b;
}

pub fn longestConsecutive(nums: [*]i32, numsSize: i32) i32 {
    const n: usize = @intCast(numsSize);
    if (n == 0) return 0;

    const buf = allocator.alloc(i32, n) catch unreachable;
    defer allocator.free(buf);

    var i: usize = 0;
    while (i < n) : (i += 1) buf[i] = nums[i];
    std.mem.sort(i32, buf, {}, lessI32);

    var best: i32 = 1;
    var cur: i32 = 1;
    i = 1;
    while (i < n) : (i += 1) {
        const diff = @as(i64, buf[i]) - @as(i64, buf[i - 1]);
        if (diff == 0) continue;
        if (diff == 1) {
            cur += 1;
        } else {
            cur = 1;
        }
        if (cur > best) best = cur;
    }
    return best;
}

test "longestConsecutive examples" {
    var a = [_]i32{ 100, 4, 200, 1, 3, 2 };
    try std.testing.expectEqual(@as(i32, 4), longestConsecutive(&a, 6));

    var b = [_]i32{ 0, 3, 7, 2, 5, 8, 4, 6, 0, 1 };
    try std.testing.expectEqual(@as(i32, 9), longestConsecutive(&b, 10));

    var c = [_]i32{0};
    try std.testing.expectEqual(@as(i32, 1), longestConsecutive(&c, 1));

    var zeros = [_]i32{ 0, 0, 0 };
    try std.testing.expectEqual(@as(i32, 1), longestConsecutive(&zeros, 3));

    try std.testing.expectEqual(@as(i32, 0), longestConsecutive(undefined, 0));

    // Extremes must not overflow when differences are taken.
    var ext = [_]i32{ -2147483648, 2147483647 };
    try std.testing.expectEqual(@as(i32, 1), longestConsecutive(&ext, 2));

    var near = [_]i32{ 2147483646, 2147483647 };
    try std.testing.expectEqual(@as(i32, 2), longestConsecutive(&near, 2));
}
