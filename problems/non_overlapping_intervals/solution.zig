// LeetCode 435. Non-overlapping Intervals
// C signature:  int eraseOverlapIntervals(int** intervals, int intervalsSize,
//                                        int* intervalsColSize);
//
// Sort by end (then start) and greedily keep the interval that ends earliest.
// Each interval is packed into one i64 key so a plain numeric sort suffices:
//   key = (end << 32) | (start + 2^31)
// Both `end` and the biased `start` stay within 32 bits, so ordering by key is
// ordering by end, then by start.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn lessThanKey(_: void, a: i64, b: i64) bool {
    return a < b;
}

fn encode(st: i32, en: i32) i64 {
    return (@as(i64, en) << 32) | ((@as(i64, st) + 0x80000000) & 0xffffffff);
}

fn decodeStart(key: i64) i64 {
    return (key & 0xffffffff) - 0x80000000;
}

fn decodeEnd(key: i64) i64 {
    return key >> 32;
}

pub fn eraseOverlapIntervals(intervals: [*][*]i32, intervalsSize: i32, intervalsColSize: [*]i32) i32 {
    _ = intervalsColSize;

    const n: usize = @intCast(intervalsSize);
    if (n <= 1) return 0;

    const keys = allocator.alloc(i64, n) catch unreachable;
    defer allocator.free(keys);
    var i: usize = 0;
    while (i < n) : (i += 1) {
        keys[i] = encode(intervals[i][0], intervals[i][1]);
    }
    std.mem.sort(i64, keys, {}, lessThanKey);

    var removed: i32 = 0;
    var lastEnd: i64 = decodeEnd(keys[0]);
    i = 1;
    while (i < n) : (i += 1) {
        const st: i64 = decodeStart(keys[i]);
        if (st < lastEnd) {
            removed += 1;
        } else {
            lastEnd = decodeEnd(keys[i]);
        }
    }
    return removed;
}

test "eraseOverlapIntervals" {
    var a0 = [_]i32{ 1, 2 };
    var a1 = [_]i32{ 2, 3 };
    var a2 = [_]i32{ 3, 4 };
    var a3 = [_]i32{ 1, 3 };
    var iv = [_][*]i32{ &a0, &a1, &a2, &a3 };
    var cols = [_]i32{ 2, 2, 2, 2 };
    try std.testing.expectEqual(@as(i32, 1), eraseOverlapIntervals(&iv, 4, &cols));

    var b0 = [_]i32{ 1, 2 };
    var b1 = [_]i32{ 1, 2 };
    var b2 = [_]i32{ 1, 2 };
    var iv2 = [_][*]i32{ &b0, &b1, &b2 };
    var cols2 = [_]i32{ 2, 2, 2 };
    try std.testing.expectEqual(@as(i32, 2), eraseOverlapIntervals(&iv2, 3, &cols2));

    var c0 = [_]i32{ 1, 2 };
    var c1 = [_]i32{ 2, 3 };
    var iv3 = [_][*]i32{ &c0, &c1 };
    var cols3 = [_]i32{ 2, 2 };
    try std.testing.expectEqual(@as(i32, 0), eraseOverlapIntervals(&iv3, 2, &cols3));

    var d0 = [_]i32{ 1, 100 };
    var d1 = [_]i32{ 11, 22 };
    var d2 = [_]i32{ 1, 11 };
    var d3 = [_]i32{ 2, 12 };
    var iv4 = [_][*]i32{ &d0, &d1, &d2, &d3 };
    var cols4 = [_]i32{ 2, 2, 2, 2 };
    try std.testing.expectEqual(@as(i32, 2), eraseOverlapIntervals(&iv4, 4, &cols4));

    // Negative coordinates exercise the sign-bit handling of the packing.
    var e0 = [_]i32{ -5, -3 };
    var e1 = [_]i32{ -4, -2 };
    var e2 = [_]i32{ -3, -1 };
    var iv5 = [_][*]i32{ &e0, &e1, &e2 };
    var cols5 = [_]i32{ 2, 2, 2 };
    try std.testing.expectEqual(@as(i32, 1), eraseOverlapIntervals(&iv5, 3, &cols5));

    var f0 = [_]i32{ -2, 0 };
    var f1 = [_]i32{ 1, 5 };
    var iv6 = [_][*]i32{ &f0, &f1 };
    var cols6 = [_]i32{ 2, 2 };
    try std.testing.expectEqual(@as(i32, 0), eraseOverlapIntervals(&iv6, 2, &cols6));

    var g0 = [_]i32{ 1, 2 };
    var iv7 = [_][*]i32{&g0};
    var cols7 = [_]i32{2};
    try std.testing.expectEqual(@as(i32, 0), eraseOverlapIntervals(&iv7, 1, &cols7));
}
