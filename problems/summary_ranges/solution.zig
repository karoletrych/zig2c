// LeetCode 228. Summary Ranges
// C signature:  char** summaryRanges(int* nums, int numsSize, int* returnSize);
//
// Walk sorted runs of consecutive values and format each run as "a" or "a->b".
// Numbers are rendered by hand because std.fmt is outside the supported subset.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn writeInt(buf: [*]u8, pos_in: usize, v: i32) usize {
    var pos = pos_in;
    var x: i64 = v;
    if (x < 0) {
        buf[pos] = '-';
        pos += 1;
        x = -x;
    }
    var digits: [12]u8 = undefined;
    var d: usize = 0;
    if (x == 0) {
        digits[0] = '0';
        d = 1;
    } else {
        while (x > 0) {
            digits[d] = @as(u8, @intCast(@mod(x, 10))) + '0';
            d += 1;
            x = @divTrunc(x, 10);
        }
    }
    while (d > 0) {
        d -= 1;
        buf[pos] = digits[d];
        pos += 1;
    }
    return pos;
}

pub fn summaryRanges(nums: [*]i32, numsSize: i32, returnSize: *i32) ?[*][*]u8 {
    const n: usize = @intCast(numsSize);
    const outer = allocator.alloc([*]u8, n + 1) catch unreachable;

    var count: usize = 0;
    var i: usize = 0;
    while (i < n) {
        const start = nums[i];
        var j = i;
        while (j + 1 < n and @as(i64, nums[j + 1]) - @as(i64, nums[j]) == 1) j += 1;
        const end = nums[j];

        const buf = allocator.alloc(u8, 32) catch unreachable;
        var w: usize = 0;
        w = writeInt(buf.ptr, w, start);
        if (end != start) {
            buf[w] = '-';
            w += 1;
            buf[w] = '>';
            w += 1;
            w = writeInt(buf.ptr, w, end);
        }
        buf[w] = 0;
        outer[count] = buf.ptr;
        count += 1;
        i = j + 1;
    }

    returnSize.* = @intCast(count);
    return outer.ptr;
}

test "summaryRanges examples" {
    var a = [_]i32{ 0, 1, 2, 4, 5, 7 };
    var rs: i32 = 0;
    const r = summaryRanges(&a, 6, &rs).?;
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqualStrings("0->2", std.mem.span(@as([*:0]u8, @ptrCast(r[0]))));
    try std.testing.expectEqualStrings("4->5", std.mem.span(@as([*:0]u8, @ptrCast(r[1]))));
    try std.testing.expectEqualStrings("7", std.mem.span(@as([*:0]u8, @ptrCast(r[2]))));

    var b = [_]i32{ 0, 2, 3, 4, 6, 8, 9 };
    var rs2: i32 = 0;
    const r2 = summaryRanges(&b, 7, &rs2).?;
    try std.testing.expectEqual(@as(i32, 4), rs2);
    try std.testing.expectEqualStrings("0", std.mem.span(@as([*:0]u8, @ptrCast(r2[0]))));
    try std.testing.expectEqualStrings("2->4", std.mem.span(@as([*:0]u8, @ptrCast(r2[1]))));
    try std.testing.expectEqualStrings("6", std.mem.span(@as([*:0]u8, @ptrCast(r2[2]))));
    try std.testing.expectEqualStrings("8->9", std.mem.span(@as([*:0]u8, @ptrCast(r2[3]))));
}

test "summaryRanges edges" {
    var rs: i32 = 0;
    const r = summaryRanges(undefined, 0, &rs).?;
    try std.testing.expectEqual(@as(i32, 0), rs);
    _ = r;

    // Negative numbers and full-width runs.
    var neg = [_]i32{ -3, -2, -1, 1, 2 };
    var rs2: i32 = 0;
    const r2 = summaryRanges(&neg, 5, &rs2).?;
    try std.testing.expectEqual(@as(i32, 2), rs2);
    try std.testing.expectEqualStrings("-3->-1", std.mem.span(@as([*:0]u8, @ptrCast(r2[0]))));
    try std.testing.expectEqualStrings("1->2", std.mem.span(@as([*:0]u8, @ptrCast(r2[1]))));

    var big = [_]i32{ -2147483648, 2147483647 };
    var rs3: i32 = 0;
    const r3 = summaryRanges(&big, 2, &rs3).?;
    try std.testing.expectEqual(@as(i32, 2), rs3);
    try std.testing.expectEqualStrings("-2147483648", std.mem.span(@as([*:0]u8, @ptrCast(r3[0]))));
    try std.testing.expectEqualStrings("2147483647", std.mem.span(@as([*:0]u8, @ptrCast(r3[1]))));
}
