// LeetCode 875. Koko Eating Bananas
// C signature:  int minEatingSpeed(int* piles, int pilesSize, int h);
//
// Binary-search the answer in [1, max(piles)]. A speed is feasible when the
// total hours (ceil(pile / speed) summed) is at most h.
const std = @import("std");

pub fn minEatingSpeed(piles: [*]i32, pilesSize: i32, h: i32) i32 {
    const n: usize = @intCast(pilesSize);
    var maxP: i32 = 1;
    var i: usize = 0;
    while (i < n) : (i += 1) {
        if (piles[i] > maxP) maxP = piles[i];
    }

    const hh: i64 = @intCast(h);
    var lo: i32 = 1;
    var hi: i32 = maxP;
    while (lo < hi) {
        const mid = lo + @divTrunc(hi - lo, 2);
        const sp: i64 = @intCast(mid);
        var hours: i64 = 0;
        var j: usize = 0;
        while (j < n) : (j += 1) {
            const p: i64 = @intCast(piles[j]);
            hours += @divTrunc(p + sp - 1, sp);
        }
        if (hours <= hh) {
            hi = mid;
        } else {
            lo = mid + 1;
        }
    }
    return lo;
}

test "minEatingSpeed examples" {
    var a = [_]i32{ 3, 6, 7, 11 };
    try std.testing.expectEqual(@as(i32, 4), minEatingSpeed(&a, 4, 8));

    var b = [_]i32{ 30, 11, 23, 4, 20 };
    try std.testing.expectEqual(@as(i32, 30), minEatingSpeed(&b, 5, 5));

    var c = [_]i32{ 30, 11, 23, 4, 20 };
    try std.testing.expectEqual(@as(i32, 23), minEatingSpeed(&c, 5, 6));
}

test "minEatingSpeed edges" {
    // exactly as many hours as piles: one pile per hour forces max speed
    var a = [_]i32{ 1 };
    try std.testing.expectEqual(@as(i32, 1), minEatingSpeed(&a, 1, 1));

    var b = [_]i32{ 1000000000 };
    try std.testing.expectEqual(@as(i32, 1000000000), minEatingSpeed(&b, 1, 1));

    // plenty of hours: speed 1 suffices when sum(piles) <= h
    var c = [_]i32{ 10, 10, 10 };
    try std.testing.expectEqual(@as(i32, 1), minEatingSpeed(&c, 3, 1000));

    // hours equal to number of piles -> must finish the largest pile in one hour
    var d = [_]i32{ 3, 6, 7, 11 };
    try std.testing.expectEqual(@as(i32, 11), minEatingSpeed(&d, 4, 4));
}
