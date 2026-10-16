// LeetCode 2542. Maximum Subsequence Score
// C signature:  long long maxScore(int* nums1, int nums1Size,
//                                 int* nums2, int nums2Size, int k);
//
// Process (nums1[i], nums2[i]) in decreasing nums2 order and keep a min-heap of
// the chosen nums1 values. When k values are held, score = sum(nums1) * nums2[i]
// because nums2[i] is the smallest nums2 seen so far in the chosen set.
const std = @import("std");
const allocator = std.heap.c_allocator;

const Pair = struct {
    a: i32,
    v: i32,
};

fn byScoreDesc(_: void, x: Pair, y: Pair) bool {
    return x.v > y.v;
}

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

pub fn maxScore(nums1: [*]i32, nums1Size: i32, nums2: [*]i32, nums2Size: i32, k: i32) i64 {
    const n1: usize = @intCast(nums1Size);
    const n2: usize = @intCast(nums2Size);
    const n: usize = @min(n1, n2);
    const kk: usize = @intCast(k);

    const pairs = allocator.alloc(Pair, n) catch unreachable;
    defer allocator.free(pairs);
    var i: usize = 0;
    while (i < n) : (i += 1) pairs[i] = .{ .a = nums1[i], .v = nums2[i] };
    std.mem.sort(Pair, pairs, {}, byScoreDesc);

    const heap = allocator.alloc(i32, kk) catch unreachable;
    defer allocator.free(heap);

    var size: usize = 0;
    var sum: i64 = 0;
    var best: i64 = -1000000000000000000;
    i = 0;
    while (i < n) : (i += 1) {
        heapPush(heap.ptr, &size, pairs[i].a);
        sum += @as(i64, @intCast(pairs[i].a));
        if (size > kk) {
            const removed = heapPop(heap.ptr, &size);
            sum -= @as(i64, @intCast(removed));
        }
        if (size == kk) {
            const cand = sum * @as(i64, @intCast(pairs[i].v));
            if (cand > best) best = cand;
        }
    }
    return best;
}

test "maxScore examples" {
    var a = [_]i32{ 1, 3, 3, 2 };
    var b = [_]i32{ 2, 1, 3, 4 };
    try std.testing.expectEqual(@as(i64, 12), maxScore(&a, 4, &b, 4, 3));

    var c = [_]i32{ 4, 2, 3, 1, 1 };
    var d = [_]i32{ 7, 5, 10, 9, 6 };
    try std.testing.expectEqual(@as(i64, 30), maxScore(&c, 5, &d, 5, 1));

    var e = [_]i32{ 2, 1, 14, 12 };
    var f = [_]i32{ 11, 7, 13, 6 };
    try std.testing.expectEqual(@as(i64, 168), maxScore(&e, 4, &f, 4, 3));
}

test "maxScore edges" {
    // k == n: every element is used, product of sums and the global min nums2.
    var a = [_]i32{ 5, 6, 7 };
    var b = [_]i32{ 3, 9, 4 };
    try std.testing.expectEqual(@as(i64, 54), maxScore(&a, 3, &b, 3, 3));

    // single element
    var c = [_]i32{10};
    var d = [_]i32{2};
    try std.testing.expectEqual(@as(i64, 20), maxScore(&c, 1, &d, 1, 1));
}
