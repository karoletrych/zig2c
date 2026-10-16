// LeetCode 1466. Reorder Routes to Make All Paths Lead to the City Zero
// C signature:  int minReorder(int n, int** connections, int connectionsSize,
//                            int* connectionsColSize);
//
// Build an undirected adjacency (compressed-sparse-row layout) alongside each
// entry's original direction. A breadth-first walk from city 0 then counts the
// edges that point away from the root: exactly those must be reversed.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn minReorder(n: i32, connections: [*][*]i32, connectionsSize: i32, connectionsColSize: [*]i32) i32 {
    _ = connectionsColSize;

    const nu: usize = @intCast(n);
    const m: usize = @intCast(connectionsSize);

    const deg = allocator.alloc(i32, nu) catch unreachable;
    defer allocator.free(deg);
    var i: usize = 0;
    while (i < nu) : (i += 1) deg[i] = 0;

    i = 0;
    while (i < m) : (i += 1) {
        const a: usize = @intCast(connections[i][0]);
        const b: usize = @intCast(connections[i][1]);
        deg[a] += 1;
        deg[b] += 1;
    }

    const off = allocator.alloc(i32, nu + 1) catch unreachable;
    defer allocator.free(off);
    off[0] = 0;
    i = 0;
    while (i < nu) : (i += 1) off[i + 1] = off[i] + deg[i];

    const adjTo = allocator.alloc(i32, 2 * m) catch unreachable;
    defer allocator.free(adjTo);
    const adjAway = allocator.alloc(i32, 2 * m) catch unreachable;
    defer allocator.free(adjAway);

    const cursor = allocator.alloc(i32, nu) catch unreachable;
    defer allocator.free(cursor);
    i = 0;
    while (i < nu) : (i += 1) cursor[i] = off[i];

    i = 0;
    while (i < m) : (i += 1) {
        const a: usize = @intCast(connections[i][0]);
        const b: usize = @intCast(connections[i][1]);

        adjTo[@intCast(cursor[a])] = @intCast(b);
        adjAway[@intCast(cursor[a])] = 1; // a -> b, points away from the root
        cursor[a] += 1;

        adjTo[@intCast(cursor[b])] = @intCast(a);
        adjAway[@intCast(cursor[b])] = 0; // b -> a, already points at the root
        cursor[b] += 1;
    }

    const seen = allocator.alloc(bool, nu) catch unreachable;
    defer allocator.free(seen);
    i = 0;
    while (i < nu) : (i += 1) seen[i] = false;

    const queue = allocator.alloc(i32, nu) catch unreachable;
    defer allocator.free(queue);
    var head: i32 = 0;
    var tail: i32 = 1;
    queue[0] = 0;
    seen[0] = true;

    var changed: i32 = 0;
    while (head < tail) {
        const u: usize = @intCast(queue[@intCast(head)]);
        head += 1;
        var k: i32 = off[u];
        while (k < off[u + 1]) : (k += 1) {
            const v: usize = @intCast(adjTo[@intCast(k)]);
            if (!seen[v]) {
                seen[v] = true;
                if (adjAway[@intCast(k)] == 1) changed += 1;
                queue[@intCast(tail)] = adjTo[@intCast(k)];
                tail += 1;
            }
        }
    }
    return changed;
}

test "minReorder" {
    var c0 = [_]i32{ 0, 1 };
    var c1 = [_]i32{ 1, 3 };
    var c2 = [_]i32{ 2, 3 };
    var c3 = [_]i32{ 4, 0 };
    var c4 = [_]i32{ 4, 5 };
    var conn = [_][*]i32{ &c0, &c1, &c2, &c3, &c4 };
    var cols = [_]i32{ 2, 2, 2, 2, 2 };
    try std.testing.expectEqual(@as(i32, 3), minReorder(6, &conn, 5, &cols));

    var d0 = [_]i32{ 1, 0 };
    var d1 = [_]i32{ 1, 2 };
    var d2 = [_]i32{ 3, 2 };
    var d3 = [_]i32{ 3, 4 };
    var conn2 = [_][*]i32{ &d0, &d1, &d2, &d3 };
    var cols2 = [_]i32{ 2, 2, 2, 2 };
    try std.testing.expectEqual(@as(i32, 2), minReorder(5, &conn2, 4, &cols2));

    var e0 = [_]i32{ 1, 0 };
    var e1 = [_]i32{ 2, 0 };
    var conn3 = [_][*]i32{ &e0, &e1 };
    var cols3 = [_]i32{ 2, 2 };
    try std.testing.expectEqual(@as(i32, 0), minReorder(3, &conn3, 2, &cols3));

    var cols4 = [_]i32{2};
    try std.testing.expectEqual(@as(i32, 0), minReorder(1, undefined, 0, &cols4));
}
