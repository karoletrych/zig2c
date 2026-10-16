// LeetCode 210. Course Schedule II
// C signature:  int* findOrder(int numCourses, int** prerequisites,
//                              int prerequisitesSize, int* prerequisitesColSize,
//                              int* returnSize);
//
// Kahn's algorithm again, but this time the dequeue order is the answer. If a
// cycle is found the order is incomplete; returnSize is set to 0.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn findOrder(numCourses: i32, prerequisites: [*][*]i32, prerequisitesSize: i32, prerequisitesColSize: [*]i32, returnSize: *i32) ?[*]i32 {
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

    const order = allocator.alloc(i32, nu + 1) catch unreachable;

    var qh: i32 = 0;
    var qt: i32 = 0;
    i = 0;
    while (i < nu) : (i += 1) {
        if (indeg[i] == 0) {
            order[@intCast(qt)] = @intCast(i);
            qt += 1;
        }
    }

    while (qh < qt) {
        const u: i32 = order[@intCast(qh)];
        qh += 1;
        var e: i32 = head[@intCast(u)];
        while (e != -1) {
            const v: i32 = to[@intCast(e)];
            indeg[@intCast(v)] -= 1;
            if (indeg[@intCast(v)] == 0) {
                order[@intCast(qt)] = v;
                qt += 1;
            }
            e = nxt[@intCast(e)];
        }
    }

    if (qt != numCourses) {
        returnSize.* = 0;
        return order.ptr;
    }
    returnSize.* = qt;
    return order.ptr;
}

test "findOrder examples" {
    var a0 = [_]i32{ 1, 0 };
    var p = [_][*]i32{&a0};
    var cols = [_]i32{2};
    var rs: i32 = 0;
    const r = findOrder(2, &p, 1, &cols, &rs).?;
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, 0), r[0]);
    try std.testing.expectEqual(@as(i32, 1), r[1]);

    var b0 = [_]i32{ 1, 0 };
    var b1 = [_]i32{ 2, 0 };
    var b2 = [_]i32{ 3, 1 };
    var b3 = [_]i32{ 3, 2 };
    var p2 = [_][*]i32{ &b0, &b1, &b2, &b3 };
    var cols2 = [_]i32{ 2, 2, 2, 2 };
    var rs2: i32 = 0;
    const r2 = findOrder(4, &p2, 4, &cols2, &rs2).?;
    try std.testing.expectEqual(@as(i32, 4), rs2);
    // 0 first, 3 last, and each prerequisite before its course
    try std.testing.expectEqual(@as(i32, 0), r2[0]);
    try std.testing.expectEqual(@as(i32, 3), r2[3]);

    var c0 = [_]i32{ 1, 0 };
    var c1 = [_]i32{ 0, 1 };
    var p3 = [_][*]i32{ &c0, &c1 };
    var cols3 = [_]i32{ 2, 2 };
    var rs3: i32 = 9;
    _ = findOrder(2, &p3, 2, &cols3, &rs3).?;
    try std.testing.expectEqual(@as(i32, 0), rs3);
}

test "findOrder edges" {
    var empty = [_][*]i32{undefined};
    var cols = [_]i32{0};
    var rs: i32 = 0;
    const r = findOrder(3, &empty, 0, &cols, &rs).?;
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqual(@as(i32, 0), r[0]);
    try std.testing.expectEqual(@as(i32, 1), r[1]);
    try std.testing.expectEqual(@as(i32, 2), r[2]);

    var solo = [_][*]i32{undefined};
    var rs2: i32 = 0;
    const r2 = findOrder(1, &solo, 0, &cols, &rs2).?;
    try std.testing.expectEqual(@as(i32, 1), rs2);
    try std.testing.expectEqual(@as(i32, 0), r2[0]);
}
