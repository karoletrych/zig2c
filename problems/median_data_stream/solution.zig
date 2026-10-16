// LeetCode 295. Find Median from Data Stream
// C signatures:
//   MedianFinder* medianFinderCreate();
//   void medianFinderAddNum(MedianFinder* obj, int num);
//   double medianFinderFindMedian(MedianFinder* obj);
//
// Two heaps: `low` is a max-heap holding the smaller half, `high` is a min-heap
// holding the larger half. Keeping nlow == nhigh or nlow == nhigh + 1 makes the
// median the top of `low` (odd) or the mean of both tops (even).
const std = @import("std");
const allocator = std.heap.c_allocator;

const CAP: usize = 100005;

pub const MedianFinder = struct {
    low: [*]i32,
    high: [*]i32,
    nlow: usize,
    nhigh: usize,
};

fn hpPush(h: [*]i32, sz: *usize, v: i32, isMax: bool) void {
    var i: usize = sz.*;
    h[i] = v;
    sz.* = i + 1;
    while (i > 0) {
        const p: usize = (i - 1) / 2;
        var wrong = h[p] > h[i];
        if (isMax) wrong = h[p] < h[i];
        if (!wrong) break;
        const t = h[p];
        h[p] = h[i];
        h[i] = t;
        i = p;
    }
}

fn hpPop(h: [*]i32, sz: *usize, isMax: bool) i32 {
    const top = h[0];
    sz.* -= 1;
    const n = sz.*;
    h[0] = h[n];
    var i: usize = 0;
    while (true) {
        const l: usize = 2 * i + 1;
        const r: usize = 2 * i + 2;
        var m: usize = i;
        if (l < n) {
            var better = h[l] < h[m];
            if (isMax) better = h[l] > h[m];
            if (better) m = l;
        }
        if (r < n) {
            var better = h[r] < h[m];
            if (isMax) better = h[r] > h[m];
            if (better) m = r;
        }
        if (m == i) break;
        const t = h[i];
        h[i] = h[m];
        h[m] = t;
        i = m;
    }
    return top;
}

pub fn medianFinderCreate() ?*MedianFinder {
    const obj = allocator.create(MedianFinder) catch unreachable;
    const lo = allocator.alloc(i32, CAP) catch unreachable;
    const hi = allocator.alloc(i32, CAP) catch unreachable;
    obj.low = lo.ptr;
    obj.high = hi.ptr;
    obj.nlow = 0;
    obj.nhigh = 0;
    return obj;
}

pub fn medianFinderAddNum(obj: *MedianFinder, num: i32) void {
    hpPush(obj.low, &obj.nlow, num, true);
    const moved = hpPop(obj.low, &obj.nlow, true);
    hpPush(obj.high, &obj.nhigh, moved, false);
    if (obj.nhigh > obj.nlow) {
        const back = hpPop(obj.high, &obj.nhigh, false);
        hpPush(obj.low, &obj.nlow, back, true);
    }
}

pub fn medianFinderFindMedian(obj: *MedianFinder) f64 {
    if (obj.nlow > obj.nhigh) {
        return @floatFromInt(obj.low[0]);
    }
    const a: f64 = @floatFromInt(obj.low[0]);
    const b: f64 = @floatFromInt(obj.high[0]);
    return (a + b) / 2.0;
}

test "medianFinder example" {
    const mf = medianFinderCreate().?;
    medianFinderAddNum(mf, 1);
    medianFinderAddNum(mf, 2);
    try std.testing.expectApproxEqAbs(@as(f64, 1.5), medianFinderFindMedian(mf), 1e-9);
    medianFinderAddNum(mf, 3);
    try std.testing.expectApproxEqAbs(@as(f64, 2.0), medianFinderFindMedian(mf), 1e-9);
}

test "medianFinder sorted and reversed streams" {
    const mf = medianFinderCreate().?;
    var i: i32 = 1;
    while (i <= 6) : (i += 1) {
        medianFinderAddNum(mf, i);
    }
    // 1 2 3 4 5 6 -> 3.5
    try std.testing.expectApproxEqAbs(@as(f64, 3.5), medianFinderFindMedian(mf), 1e-9);
    medianFinderAddNum(mf, 7);
    try std.testing.expectApproxEqAbs(@as(f64, 4.0), medianFinderFindMedian(mf), 1e-9);

    const rev = medianFinderCreate().?;
    i = 6;
    while (i >= 1) : (i -= 1) {
        medianFinderAddNum(rev, i);
    }
    try std.testing.expectApproxEqAbs(@as(f64, 3.5), medianFinderFindMedian(rev), 1e-9);
}

test "medianFinder edges" {
    // single value
    const one = medianFinderCreate().?;
    medianFinderAddNum(one, 42);
    try std.testing.expectApproxEqAbs(@as(f64, 42.0), medianFinderFindMedian(one), 1e-9);

    // negatives interleaved
    const mf = medianFinderCreate().?;
    medianFinderAddNum(mf, -1);
    try std.testing.expectApproxEqAbs(@as(f64, -1.0), medianFinderFindMedian(mf), 1e-9);
    medianFinderAddNum(mf, -2);
    try std.testing.expectApproxEqAbs(@as(f64, -1.5), medianFinderFindMedian(mf), 1e-9);
    medianFinderAddNum(mf, -3);
    try std.testing.expectApproxEqAbs(@as(f64, -2.0), medianFinderFindMedian(mf), 1e-9);

    // all equal
    const eq = medianFinderCreate().?;
    var i: i32 = 0;
    while (i < 5) : (i += 1) medianFinderAddNum(eq, 7);
    try std.testing.expectApproxEqAbs(@as(f64, 7.0), medianFinderFindMedian(eq), 1e-9);

    // extremes do not overflow the even-case average
    const big = medianFinderCreate().?;
    medianFinderAddNum(big, 2147483647);
    medianFinderAddNum(big, 2147483647);
    try std.testing.expectApproxEqAbs(@as(f64, 2147483647.0), medianFinderFindMedian(big), 1.0);
}
