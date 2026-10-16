// LeetCode 207. Course Schedule
// C signature:  bool canFinish(int numCourses, int** prerequisites,
//                            int prerequisitesSize, int* prerequisitesColSize);
//
// Kahn's algorithm. The prerequisites are loaded into a forward adjacency list
// stored as three flat arrays (head/next/to); courses with in-degree 0 seed the
// queue and each popped course decrements its successors. Acyclicity is exactly
// `seen == numCourses`.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn canFinish(numCourses: i32, prerequisites: [*][*]i32, prerequisitesSize: i32, prerequisitesColSize: [*]i32) bool {
    _ = prerequisitesColSize;

    const nu: usize = @intCast(numCourses);
    const m: usize = @intCast(prerequisitesSize);

    const head = allocator.alloc(i32, nu) catch unreachable;
    defer allocator.free(head);
    const nxt = allocator.alloc(i32, m + 1) catch unreachable;
    defer allocator.free(nxt);
    const to = allocator.alloc(i32, m + 1) catch unreachable;
    defer allocator.free(to);
    const indeg = allocator.alloc(i32, nu) catch unreachable;
    defer allocator.free(indeg);

    var i: usize = 0;
    while (i < nu) : (i += 1) {
        head[i] = -1;
        indeg[i] = 0;
    }
    i = 0;
    while (i < m) : (i += 1) {
        const course: i32 = prerequisites[i][0];
        const pre: i32 = prerequisites[i][1];
        nxt[i] = head[@intCast(pre)];
        head[@intCast(pre)] = @intCast(i);
        to[i] = course;
        indeg[@intCast(course)] += 1;
    }

    const q = allocator.alloc(i32, nu) catch unreachable;
    defer allocator.free(q);

    var qh: i32 = 0;
    var qt: i32 = 0;
    i = 0;
    while (i < nu) : (i += 1) {
        if (indeg[i] == 0) {
            q[@intCast(qt)] = @intCast(i);
            qt += 1;
        }
    }

    var seen: i32 = 0;
    while (qh < qt) {
        const u: i32 = q[@intCast(qh)];
        qh += 1;
        seen += 1;
        var e: i32 = head[@intCast(u)];
        while (e != -1) {
            const v: i32 = to[@intCast(e)];
            indeg[@intCast(v)] -= 1;
            if (indeg[@intCast(v)] == 0) {
                q[@intCast(qt)] = v;
                qt += 1;
            }
            e = nxt[@intCast(e)];
        }
    }
    return seen == numCourses;
}

test "canFinish examples" {
    var a0 = [_]i32{ 1, 0 };
    var p = [_][*]i32{&a0};
    var cols = [_]i32{2};
    try std.testing.expect(canFinish(2, &p, 1, &cols));

    var b0 = [_]i32{ 1, 0 };
    var b1 = [_]i32{ 0, 1 };
    var p2 = [_][*]i32{ &b0, &b1 };
    var cols2 = [_]i32{ 2, 2 };
    try std.testing.expect(!canFinish(2, &p2, 2, &cols2));
}

test "canFinish edges" {
    // no prerequisites at all
    var empty = [_][*]i32{undefined};
    var cols = [_]i32{0};
    try std.testing.expect(canFinish(1, &empty, 0, &cols));
    try std.testing.expect(canFinish(5, &empty, 0, &cols));

    // a longer chain 0 -> 1 -> 2 -> 3
    var e0 = [_]i32{ 1, 0 };
    var e1 = [_]i32{ 2, 1 };
    var e2 = [_]i32{ 3, 2 };
    var p = [_][*]i32{ &e0, &e1, &e2 };
    var c = [_]i32{ 2, 2, 2 };
    try std.testing.expect(canFinish(4, &p, 3, &c));

    // diamond, still acyclic
    var f0 = [_]i32{ 1, 0 };
    var f1 = [_]i32{ 2, 0 };
    var f2 = [_]i32{ 3, 1 };
    var f3 = [_]i32{ 3, 2 };
    var p2 = [_][*]i32{ &f0, &f1, &f2, &f3 };
    var c2 = [_]i32{ 2, 2, 2, 2 };
    try std.testing.expect(canFinish(4, &p2, 4, &c2));

    // self loop is a cycle
    var g0 = [_]i32{ 0, 0 };
    var p3 = [_][*]i32{&g0};
    var c3 = [_]i32{2};
    try std.testing.expect(!canFinish(1, &p3, 1, &c3));

    // a disconnected cyclic component still fails
    var h0 = [_]i32{ 1, 0 };
    var h1 = [_]i32{ 3, 2 };
    var h2 = [_]i32{ 2, 3 };
    var p4 = [_][*]i32{ &h0, &h1, &h2 };
    var c4 = [_]i32{ 2, 2, 2 };
    try std.testing.expect(!canFinish(4, &p4, 3, &c4));
}
