// LeetCode 373. Find K Pairs with Smallest Sums
// C signature:  int** kSmallestPairs(int* nums1, int nums1Size, int* nums2,
//                                   int nums2Size, int k, int* returnSize,
//                                   int** returnColumnSizes);
//
// Both arrays are sorted, so for a fixed i the sums grow with j. Seed a
// min-heap with (i, 0) for every i; each pop emits the smallest remaining pair
// and pushes (i, j + 1). Every emitted row has exactly two values.
const std = @import("std");
const allocator = std.heap.c_allocator;

const KP = struct {
    s: i32,
    i: i32,
    j: i32,
};

fn kpLess(a: KP, b: KP) bool {
    if (a.s != b.s) return a.s < b.s;
    return a.i < b.i;
}

fn kpPush(h: [*]KP, sz: *usize, x: KP) void {
    var i: usize = sz.*;
    h[i] = x;
    sz.* = i + 1;
    while (i > 0) {
        const p: usize = (i - 1) / 2;
        if (!kpLess(h[i], h[p])) break;
        const t = h[p];
        h[p] = h[i];
        h[i] = t;
        i = p;
    }
}

fn kpPop(h: [*]KP, sz: *usize) KP {
    const top = h[0];
    sz.* -= 1;
    const n = sz.*;
    h[0] = h[n];
    var i: usize = 0;
    while (true) {
        const l: usize = 2 * i + 1;
        const r: usize = 2 * i + 2;
        var m: usize = i;
        if (l < n and kpLess(h[l], h[m])) m = l;
        if (r < n and kpLess(h[r], h[m])) m = r;
        if (m == i) break;
        const t = h[i];
        h[i] = h[m];
        h[m] = t;
        i = m;
    }
    return top;
}

pub fn kSmallestPairs(nums1: [*]i32, nums1Size: i32, nums2: [*]i32, nums2Size: i32, k: i32, returnSize: *i32, returnColumnSizes: [*][*]i32) ?[*][*]i32 {
    const m: usize = @intCast(nums1Size);
    const nn: usize = @intCast(nums2Size);
    if (m == 0 or nn == 0 or k <= 0) {
        returnSize.* = 0;
        return null;
    }
    const kk: usize = @intCast(k);
    const cap: usize = m * nn;
    const limit: usize = @min(kk, cap);

    const heap = allocator.alloc(KP, m + 1) catch unreachable;
    defer allocator.free(heap);
    const rows = allocator.alloc([*]i32, limit) catch unreachable;
    const cols = allocator.alloc(i32, limit) catch unreachable;

    var hs: usize = 0;
    var i: usize = 0;
    while (i < m) : (i += 1) {
        kpPush(heap.ptr, &hs, KP{ .s = nums1[i] + nums2[0], .i = @intCast(i), .j = 0 });
    }

    var cnt: usize = 0;
    while (cnt < limit and hs > 0) {
        const top = kpPop(heap.ptr, &hs);
        const row = allocator.alloc(i32, 2) catch unreachable;
        row[0] = nums1[@intCast(top.i)];
        row[1] = nums2[@intCast(top.j)];
        rows[cnt] = row.ptr;
        cols[cnt] = 2;
        cnt += 1;

        const nj: i32 = top.j + 1;
        if (nj < nums2Size) {
            kpPush(heap.ptr, &hs, KP{ .s = nums1[@intCast(top.i)] + nums2[@intCast(nj)], .i = top.i, .j = nj });
        }
    }

    if (cnt == 0) {
        returnSize.* = 0;
        return null;
    }
    returnColumnSizes[0] = cols.ptr;
    returnSize.* = @intCast(cnt);
    return rows.ptr;
}

test "kSmallestPairs examples" {
    var a = [_]i32{ 1, 7, 11 };
    var b = [_]i32{ 2, 4, 6 };
    var rs: i32 = 0;
    var cb = [_][*]i32{undefined};
    const r = kSmallestPairs(&a, 3, &b, 3, 3, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqual(@as(i32, 2), cb[0][0]);
    try std.testing.expectEqual(@as(i32, 1), r[0][0]);
    try std.testing.expectEqual(@as(i32, 2), r[0][1]);
    try std.testing.expectEqual(@as(i32, 1), r[1][0]);
    try std.testing.expectEqual(@as(i32, 4), r[1][1]);
    try std.testing.expectEqual(@as(i32, 1), r[2][0]);
    try std.testing.expectEqual(@as(i32, 6), r[2][1]);

    var c = [_]i32{ 1, 1, 2 };
    var d = [_]i32{ 1, 2, 3 };
    var rs2: i32 = 0;
    const r2 = kSmallestPairs(&c, 3, &d, 3, 2, &rs2, &cb).?;
    try std.testing.expectEqual(@as(i32, 2), rs2);
    try std.testing.expectEqual(@as(i32, 1), r2[0][0]);
    try std.testing.expectEqual(@as(i32, 1), r2[0][1]);
    try std.testing.expectEqual(@as(i32, 1), r2[1][0]);
    try std.testing.expectEqual(@as(i32, 1), r2[1][1]);
}

test "kSmallestPairs edges" {
    // k exceeds the number of available pairs
    var a = [_]i32{ 1, 2 };
    var b = [_]i32{3};
    var rs: i32 = 0;
    var cb = [_][*]i32{undefined};
    const r = kSmallestPairs(&a, 2, &b, 1, 5, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, 1), r[0][0]);
    try std.testing.expectEqual(@as(i32, 3), r[0][1]);
    try std.testing.expectEqual(@as(i32, 2), r[1][0]);
    try std.testing.expectEqual(@as(i32, 3), r[1][1]);

    // exactly one pair available
    var one = [_]i32{2};
    var oneb = [_]i32{4};
    var rs2: i32 = 0;
    const r2 = kSmallestPairs(&one, 1, &oneb, 1, 100, &rs2, &cb).?;
    try std.testing.expectEqual(@as(i32, 1), rs2);
    try std.testing.expectEqual(@as(i32, 2), r2[0][0]);
    try std.testing.expectEqual(@as(i32, 4), r2[0][1]);

    // k == 0 -> empty result
    var rs3: i32 = 7;
    const r3 = kSmallestPairs(&a, 2, &b, 1, 0, &rs3, &cb);
    try std.testing.expectEqual(@as(i32, 0), rs3);
    try std.testing.expect(r3 == null);

    // negatives
    var n1 = [_]i32{ -3, -1, 5 };
    var n2 = [_]i32{ -2, 4 };
    var rs4: i32 = 0;
    const r4 = kSmallestPairs(&n1, 3, &n2, 2, 3, &rs4, &cb).?;
    try std.testing.expectEqual(@as(i32, 3), rs4);
    try std.testing.expectEqual(@as(i32, -3), r4[0][0]);
    try std.testing.expectEqual(@as(i32, -2), r4[0][1]);
    try std.testing.expectEqual(@as(i32, -1), r4[1][0]);
    try std.testing.expectEqual(@as(i32, -2), r4[1][1]);
    // sums so far: -5, -3, then 1 (from -3 + 4)
    try std.testing.expectEqual(@as(i32, -3), r4[2][0]);
    try std.testing.expectEqual(@as(i32, 4), r4[2][1]);
}
