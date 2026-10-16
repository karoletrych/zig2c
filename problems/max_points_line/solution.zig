// LeetCode 149. Max Points on a Line
// C signature:  int maxPoints(int** points, int pointsSize, int* pointsColSize);
//
// For each anchor point count how many later points share the same reduced
// slope (dx, dy divided by their gcd, sign normalised so the pair is
// canonical). Duplicate anchor points are counted separately and added.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn gcd(a0: i64, b0: i64) i64 {
    var a = if (a0 < 0) -a0 else a0;
    var b = if (b0 < 0) -b0 else b0;
    while (b != 0) {
        const t = @mod(a, b);
        a = b;
        b = t;
    }
    return a;
}

pub fn maxPoints(points: [*][*]i32, pointsSize: i32, pointsColSize: [*]i32) i32 {
    _ = pointsColSize;
    if (pointsSize <= 2) return pointsSize;

    var best: i32 = 0;
    var i: i32 = 0;
    while (i < pointsSize) : (i += 1) {
        var slopes = std.AutoHashMap(i64, i32).init(allocator);
        defer slopes.deinit();

        var dup: i32 = 0;
        var localBest: i32 = 0;
        const xi = points[@intCast(i)][0];
        const yi = points[@intCast(i)][1];

        var j: i32 = i + 1;
        while (j < pointsSize) : (j += 1) {
            var dx: i64 = @as(i64, points[@intCast(j)][0]) - @as(i64, xi);
            var dy: i64 = @as(i64, points[@intCast(j)][1]) - @as(i64, yi);
            if (dx == 0 and dy == 0) {
                dup += 1;
                continue;
            }
            const g = gcd(dx, dy);
            if (g != 0) {
                dx = @divTrunc(dx, g);
                dy = @divTrunc(dy, g);
            }
            if (dy < 0 or (dy == 0 and dx < 0)) {
                dx = -dx;
                dy = -dy;
            }
            const key = dx * 100003 + dy;
            const gop = slopes.getOrPut(key) catch unreachable;
            if (!gop.found_existing) gop.value_ptr.* = 0;
            gop.value_ptr.* += 1;
            if (gop.value_ptr.* > localBest) localBest = gop.value_ptr.*;
        }

        const cand = localBest + dup + 1;
        if (cand > best) best = cand;
    }
    return best;
}

test "maxPoints examples" {
    var p0 = [_]i32{ 1, 1 };
    var p1 = [_]i32{ 2, 2 };
    var p2 = [_]i32{ 3, 3 };
    var a = [_][*]i32{ &p0, &p1, &p2 };
    var cols = [_]i32{2};
    try std.testing.expectEqual(@as(i32, 3), maxPoints(&a, 3, &cols));

    var q0 = [_]i32{ 1, 1 };
    var q1 = [_]i32{ 3, 2 };
    var q2 = [_]i32{ 5, 3 };
    var q3 = [_]i32{ 4, 1 };
    var q4 = [_]i32{ 2, 3 };
    var q5 = [_]i32{ 1, 4 };
    var b = [_][*]i32{ &q0, &q1, &q2, &q3, &q4, &q5 };
    try std.testing.expectEqual(@as(i32, 4), maxPoints(&b, 6, &cols));
}

test "maxPoints edges" {
    var p0 = [_]i32{ 0, 0 };
    var one = [_][*]i32{&p0};
    var cols = [_]i32{2};
    try std.testing.expectEqual(@as(i32, 1), maxPoints(&one, 1, &cols));

    var r0 = [_]i32{ 1, 1 };
    var r1 = [_]i32{ 1, 1 };
    var r2 = [_]i32{ 2, 2 };
    var dup = [_][*]i32{ &r0, &r1, &r2 };
    try std.testing.expectEqual(@as(i32, 3), maxPoints(&dup, 3, &cols));

    var s0 = [_]i32{ 0, 0 };
    var s1 = [_]i32{ 0, 0 };
    var s2 = [_]i32{ 0, 0 };
    var allsame = [_][*]i32{ &s0, &s1, &s2 };
    try std.testing.expectEqual(@as(i32, 3), maxPoints(&allsame, 3, &cols));

    var t0 = [_]i32{ 0, 0 };
    var t1 = [_]i32{ 1, 0 };
    var t2 = [_]i32{ 2, 0 };
    var t3 = [_]i32{ 0, 1 };
    var horiz = [_][*]i32{ &t0, &t1, &t2, &t3 };
    try std.testing.expectEqual(@as(i32, 3), maxPoints(&horiz, 4, &cols));

    var k0 = [_]i32{ 0, 0 };
    var k1 = [_]i32{ 0, 1 };
    var k2 = [_]i32{ 0, 2 };
    var k3 = [_]i32{ 1, 0 };
    var vert = [_][*]i32{ &k0, &k1, &k2, &k3 };
    try std.testing.expectEqual(@as(i32, 3), maxPoints(&vert, 4, &cols));

    var v0 = [_]i32{ 0, 0 };
    var v1 = [_]i32{ 1, 0 };
    var two = [_][*]i32{ &v0, &v1 };
    try std.testing.expectEqual(@as(i32, 2), maxPoints(&two, 2, &cols));
}
