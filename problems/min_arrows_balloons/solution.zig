// LeetCode 452. Minimum Number of Arrows to Burst Balloons
// C signature:  int findMinArrowShots(int** points, int pointsSize, int* pointsColSize);
//
// Sort by right edge (then left edge) and shoot each arrow at the right edge of
// the first not-yet-burst balloon; every balloon whose left edge is at or before
// that point is burst too. Packing into an i64 key makes the sort numeric:
//   key = (end << 32) | (start + 2^31)
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

pub fn findMinArrowShots(points: [*][*]i32, pointsSize: i32, pointsColSize: [*]i32) i32 {
    _ = pointsColSize;

    const n: usize = @intCast(pointsSize);
    if (n == 0) return 0;

    const keys = allocator.alloc(i64, n) catch unreachable;
    defer allocator.free(keys);
    var i: usize = 0;
    while (i < n) : (i += 1) {
        keys[i] = encode(points[i][0], points[i][1]);
    }
    std.mem.sort(i64, keys, {}, lessThanKey);

    var arrows: i32 = 0;
    i = 0;
    while (i < n) {
        arrows += 1;
        const arrow: i64 = decodeEnd(keys[i]);
        while (i < n and decodeStart(keys[i]) <= arrow) : (i += 1) {}
    }
    return arrows;
}

test "findMinArrowShots" {
    var a0 = [_]i32{ 10, 16 };
    var a1 = [_]i32{ 2, 8 };
    var a2 = [_]i32{ 1, 6 };
    var a3 = [_]i32{ 7, 12 };
    var p = [_][*]i32{ &a0, &a1, &a2, &a3 };
    var cols = [_]i32{ 2, 2, 2, 2 };
    try std.testing.expectEqual(@as(i32, 2), findMinArrowShots(&p, 4, &cols));

    var b0 = [_]i32{ 1, 2 };
    var b1 = [_]i32{ 3, 4 };
    var b2 = [_]i32{ 5, 6 };
    var b3 = [_]i32{ 7, 8 };
    var p2 = [_][*]i32{ &b0, &b1, &b2, &b3 };
    var cols2 = [_]i32{ 2, 2, 2, 2 };
    try std.testing.expectEqual(@as(i32, 4), findMinArrowShots(&p2, 4, &cols2));

    var c0 = [_]i32{ 1, 2 };
    var c1 = [_]i32{ 2, 3 };
    var c2 = [_]i32{ 3, 4 };
    var c3 = [_]i32{ 4, 5 };
    var p3 = [_][*]i32{ &c0, &c1, &c2, &c3 };
    var cols3 = [_]i32{ 2, 2, 2, 2 };
    try std.testing.expectEqual(@as(i32, 2), findMinArrowShots(&p3, 4, &cols3));

    var d0 = [_]i32{ 1, 2 };
    var d1 = [_]i32{ 2, 3 };
    var p4 = [_][*]i32{ &d0, &d1 };
    var cols4 = [_]i32{ 2, 2 };
    try std.testing.expectEqual(@as(i32, 1), findMinArrowShots(&p4, 2, &cols4));

    // Negative and extreme int32 coordinates exercise the packing.
    var e0 = [_]i32{ -3, -1 };
    var e1 = [_]i32{ -5, -2 };
    var e2 = [_]i32{ 1, 4 };
    var p5 = [_][*]i32{ &e0, &e1, &e2 };
    var cols5 = [_]i32{ 2, 2, 2 };
    try std.testing.expectEqual(@as(i32, 2), findMinArrowShots(&p5, 3, &cols5));

    var f0 = [_]i32{ -2147483648, 2147483647 };
    var p6 = [_][*]i32{&f0};
    var cols6 = [_]i32{2};
    try std.testing.expectEqual(@as(i32, 1), findMinArrowShots(&p6, 1, &cols6));

    var g0 = [_]i32{ -2147483648, 2147483647 };
    var g1 = [_]i32{ -2147483648, 2147483647 };
    var p7 = [_][*]i32{ &g0, &g1 };
    var cols7 = [_]i32{ 2, 2 };
    try std.testing.expectEqual(@as(i32, 1), findMinArrowShots(&p7, 2, &cols7));

    var cols8 = [_]i32{2};
    try std.testing.expectEqual(@as(i32, 0), findMinArrowShots(undefined, 0, &cols8));
}
