// LeetCode 2462. Total Cost to Hire K Workers
// C signature:  long long totalCost(int* costs, int costsSize, int k, int candidates);
//
// Two min-heaps: `left` holds the first `candidates` workers, `right` the last
// `candidates`. Each of the k rounds takes the cheaper of the two heap tops
// (ties go to the lower index, i.e. the left heap) and refills that side from
// the still-unclaimed middle.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn heapPush(h: [*]i32, size: *usize, val: i32) void {
    var i: usize = size.*;
    h[i] = val;
    size.* = i + 1;
    while (i > 0) {
        const p: usize = (i - 1) / 2;
        if (h[p] <= h[i]) break;
        const t = h[p];
        h[p] = h[i];
        h[i] = t;
        i = p;
    }
}

fn heapPop(h: [*]i32, size: *usize) i32 {
    const top = h[0];
    size.* -= 1;
    const n = size.*;
    h[0] = h[n];
    var i: usize = 0;
    while (true) {
        const l: usize = 2 * i + 1;
        const r: usize = 2 * i + 2;
        var m: usize = i;
        if (l < n and h[l] < h[m]) m = l;
        if (r < n and h[r] < h[m]) m = r;
        if (m == i) break;
        const t = h[i];
        h[i] = h[m];
        h[m] = t;
        i = m;
    }
    return top;
}

pub fn totalCost(costs: [*]i32, costsSize: i32, k: i32, candidates: i32) i64 {
    const n: usize = @intCast(costsSize);
    const c: usize = @intCast(candidates);
    const kk: usize = @intCast(k);

    const left = allocator.alloc(i32, c) catch unreachable;
    defer allocator.free(left);
    const right = allocator.alloc(i32, c) catch unreachable;
    defer allocator.free(right);

    var ls: usize = 0;
    var rs: usize = 0;
    var lo: usize = 0;
    var hi: usize = n;

    var i: usize = 0;
    while (i < c and lo < hi) : (i += 1) {
        heapPush(left.ptr, &ls, costs[lo]);
        lo += 1;
    }
    i = 0;
    while (i < c and lo < hi) : (i += 1) {
        hi -= 1;
        heapPush(right.ptr, &rs, costs[hi]);
    }

    var total: i64 = 0;
    var t: usize = 0;
    while (t < kk) : (t += 1) {
        var takeLeft = true;
        if (ls == 0) {
            takeLeft = false;
        } else if (rs == 0) {
            takeLeft = true;
        } else if (right[0] < left[0]) {
            takeLeft = false;
        }
        if (takeLeft) {
            total += @as(i64, @intCast(heapPop(left.ptr, &ls)));
            if (lo < hi) {
                heapPush(left.ptr, &ls, costs[lo]);
                lo += 1;
            }
        } else {
            total += @as(i64, @intCast(heapPop(right.ptr, &rs)));
            if (lo < hi) {
                hi -= 1;
                heapPush(right.ptr, &rs, costs[hi]);
            }
        }
    }
    return total;
}

test "totalCost examples" {
    var a = [_]i32{ 17, 12, 10, 2, 7, 2, 11, 20, 8 };
    try std.testing.expectEqual(@as(i64, 11), totalCost(&a, 9, 3, 4));

    var b = [_]i32{ 1, 2, 4, 1 };
    try std.testing.expectEqual(@as(i64, 4), totalCost(&b, 4, 3, 3));
}

test "totalCost edges" {
    // candidates covers the whole array: it degrades to picking the k cheapest.
    var a = [_]i32{ 5, 4, 3, 2, 1 };
    try std.testing.expectEqual(@as(i64, 3), totalCost(&a, 5, 2, 5));

    // overlapping windows are allowed (2*candidates > n here).
    var b = [_]i32{ 3, 1, 4, 1, 5, 9, 2, 6 };
    try std.testing.expectEqual(@as(i64, 4), totalCost(&b, 8, 3, 3));

    var c = [_]i32{ 1, 1, 1 };
    try std.testing.expectEqual(@as(i64, 3), totalCost(&c, 3, 3, 1));

    var d = [_]i32{ 10, 2 };
    try std.testing.expectEqual(@as(i64, 2), totalCost(&d, 2, 1, 1));
}
