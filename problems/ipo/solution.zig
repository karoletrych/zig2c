// LeetCode 502. IPO
// C signature:  int findMaximizedCapital(int k, int w, int* profits, int profitsSize,
//                                          int* capital, int capitalSize);
//
// Sort projects by capital. At each of the k rounds, push every affordable
// project (capital <= w) into a max-heap keyed by profit, then take the most
// profitable one and add its profit to w. Stop early when nothing is affordable.
const std = @import("std");
const allocator = std.heap.c_allocator;

const Proj = struct {
    cap: i32,
    prof: i32,
};

fn byCap(_: void, a: Proj, b: Proj) bool {
    return a.cap < b.cap;
}

fn maxPush(h: [*]i32, sz: *usize, v: i32) void {
    var i: usize = sz.*;
    h[i] = v;
    sz.* = i + 1;
    while (i > 0) {
        const p: usize = (i - 1) / 2;
        if (h[p] >= h[i]) break;
        const t = h[p];
        h[p] = h[i];
        h[i] = t;
        i = p;
    }
}

fn maxPop(h: [*]i32, sz: *usize) i32 {
    const top = h[0];
    sz.* -= 1;
    const n = sz.*;
    h[0] = h[n];
    var i: usize = 0;
    while (true) {
        const l: usize = 2 * i + 1;
        const r: usize = 2 * i + 2;
        var m: usize = i;
        if (l < n and h[l] > h[m]) m = l;
        if (r < n and h[r] > h[m]) m = r;
        if (m == i) break;
        const t = h[i];
        h[i] = h[m];
        h[m] = t;
        i = m;
    }
    return top;
}

pub fn findMaximizedCapital(k: i32, w: i32, profits: [*]i32, profitsSize: i32, capital: [*]i32, capitalSize: i32) i32 {
    const n: usize = @intCast(@min(profitsSize, capitalSize));
    if (n == 0 or k <= 0) return w;

    const projs = allocator.alloc(Proj, n) catch unreachable;
    defer allocator.free(projs);
    var i: usize = 0;
    while (i < n) : (i += 1) projs[i] = .{ .cap = capital[i], .prof = profits[i] };
    std.mem.sort(Proj, projs, {}, byCap);

    const heap = allocator.alloc(i32, n) catch unreachable;
    defer allocator.free(heap);

    var hs: usize = 0;
    var cur: i64 = @intCast(w);
    var idx: usize = 0;
    var t: usize = 0;
    const kk: usize = @intCast(k);
    while (t < kk) : (t += 1) {
        while (idx < n and @as(i64, @intCast(projs[idx].cap)) <= cur) {
            maxPush(heap.ptr, &hs, projs[idx].prof);
            idx += 1;
        }
        if (hs == 0) break;
        cur += @as(i64, @intCast(maxPop(heap.ptr, &hs)));
    }
    return @intCast(cur);
}

test "findMaximizedCapital examples" {
    var p = [_]i32{ 1, 2, 3 };
    var c = [_]i32{ 0, 1, 1 };
    try std.testing.expectEqual(@as(i32, 4), findMaximizedCapital(2, 0, &p, 3, &c, 3));

    var p2 = [_]i32{ 1, 2, 3 };
    var c2 = [_]i32{ 0, 1, 2 };
    try std.testing.expectEqual(@as(i32, 6), findMaximizedCapital(3, 0, &p2, 3, &c2, 3));
}

test "findMaximizedCapital edges" {
    // k == 0: no project may be started
    var p = [_]i32{ 1, 2, 3 };
    var c = [_]i32{ 0, 0, 0 };
    try std.testing.expectEqual(@as(i32, 5), findMaximizedCapital(0, 5, &p, 3, &c, 3));

    // nothing affordable
    var p2 = [_]i32{5};
    var c2 = [_]i32{10};
    try std.testing.expectEqual(@as(i32, 0), findMaximizedCapital(1, 0, &p2, 1, &c2, 1));

    // k larger than the number of projects
    var p3 = [_]i32{ 1, 2 };
    var c3 = [_]i32{ 0, 0 };
    try std.testing.expectEqual(@as(i32, 3), findMaximizedCapital(5, 0, &p3, 2, &c3, 2));

    // same project pool as the example, but three rounds: greedy keeps growing
    var p4 = [_]i32{ 1, 2, 3 };
    var c4 = [_]i32{ 0, 1, 1 };
    try std.testing.expectEqual(@as(i32, 7), findMaximizedCapital(3, 1, &p4, 3, &c4, 3));

    // capital unlock is progressive
    var p5 = [_]i32{ 1, 2, 3 };
    var c5 = [_]i32{ 0, 1, 2 };
    try std.testing.expectEqual(@as(i32, 1), findMaximizedCapital(1, 0, &p5, 3, &c5, 3));

    // single project
    var p6 = [_]i32{4};
    var c6 = [_]i32{0};
    try std.testing.expectEqual(@as(i32, 4), findMaximizedCapital(3, 0, &p6, 1, &c6, 1));

    // profit of zero is still a valid choice
    var p7 = [_]i32{ 0, 0 };
    var c7 = [_]i32{ 0, 0 };
    try std.testing.expectEqual(@as(i32, 5), findMaximizedCapital(2, 5, &p7, 2, &c7, 2));
}
