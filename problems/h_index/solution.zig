// LeetCode 274. H-Index
// C signature:  int hIndex(int* citations, int citationsSize);
//
// Sort ascending. With h papers having at least h citations, scanning from the
// front the first index i with citations[i] >= n - i gives the largest such h.

const std = @import("std");

fn lessThan(_: void, a: i32, b: i32) bool {
    return a < b;
}

pub fn hIndex(citations: [*]i32, citationsSize: i32) i32 {
    const n: usize = @intCast(citationsSize);
    std.mem.sort(i32, citations[0..n], {}, lessThan);
    var i: i32 = 0;
    while (i < citationsSize) : (i += 1) {
        const remaining = citationsSize - i;
        if (citations[@intCast(i)] >= remaining) return remaining;
    }
    return 0;
}

test "hIndex examples" {
    var a = [_]i32{ 3, 0, 6, 1, 5 };
    try std.testing.expectEqual(@as(i32, 3), hIndex(&a, 5));

    var b = [_]i32{ 1, 3, 1 };
    try std.testing.expectEqual(@as(i32, 1), hIndex(&b, 3));
}

test "hIndex edges" {
    var empty = [_]i32{0};
    try std.testing.expectEqual(@as(i32, 0), hIndex(&empty, 0));

    var one = [_]i32{0};
    try std.testing.expectEqual(@as(i32, 0), hIndex(&one, 1));

    var all = [_]i32{ 100, 100, 100 };
    try std.testing.expectEqual(@as(i32, 3), hIndex(&all, 3));

    var zeros = [_]i32{ 0, 0, 0 };
    try std.testing.expectEqual(@as(i32, 0), hIndex(&zeros, 3));

    var oneHundred = [_]i32{100};
    try std.testing.expectEqual(@as(i32, 1), hIndex(&oneHundred, 1));
}
