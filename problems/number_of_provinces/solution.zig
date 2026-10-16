// LeetCode 547. Number of Provinces
// C signature:  int findCircleNum(int** isConnected, int isConnectedSize, int* isConnectedColSize);
//
// Count connected components of the (symmetrical) adjacency matrix using an
// explicit stack.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn findCircleNum(isConnected: [*][*]i32, isConnectedSize: i32, isConnectedColSize: [*]i32) i32 {
    const n: i32 = isConnectedSize;
    const nu: usize = @intCast(n);

    const visited = allocator.alloc(bool, nu) catch unreachable;
    defer allocator.free(visited);
    var i: usize = 0;
    while (i < nu) : (i += 1) visited[i] = false;

    const stack = allocator.alloc(i32, nu) catch unreachable;
    defer allocator.free(stack);

    var provinces: i32 = 0;
    var start: i32 = 0;
    while (start < n) : (start += 1) {
        if (visited[@intCast(start)]) continue;
        provinces += 1;
        visited[@intCast(start)] = true;
        var top: i32 = 0;
        stack[0] = start;

        while (top >= 0) {
            const u: i32 = stack[@intCast(top)];
            top -= 1;
            var v: i32 = 0;
            while (v < n) : (v += 1) {
                if (isConnected[@intCast(u)][@intCast(v)] == 1 and !visited[@intCast(v)]) {
                    visited[@intCast(v)] = true;
                    top += 1;
                    stack[@intCast(top)] = v;
                }
            }
        }
    }
    _ = isConnectedColSize;
    return provinces;
}

test "findCircleNum" {
    var r0 = [_]i32{ 1, 1, 0 };
    var r1 = [_]i32{ 1, 1, 0 };
    var r2 = [_]i32{ 0, 0, 1 };
    var m = [_][*]i32{ &r0, &r1, &r2 };
    var cols = [_]i32{ 3, 3, 3 };
    try std.testing.expectEqual(@as(i32, 2), findCircleNum(&m, 3, &cols));

    var a0 = [_]i32{ 1, 0, 0 };
    var a1 = [_]i32{ 0, 1, 0 };
    var a2 = [_]i32{ 0, 0, 1 };
    var m2 = [_][*]i32{ &a0, &a1, &a2 };
    var cols2 = [_]i32{ 3, 3, 3 };
    try std.testing.expectEqual(@as(i32, 3), findCircleNum(&m2, 3, &cols2));

    var b0 = [_]i32{1};
    var m3 = [_][*]i32{&b0};
    var cols3 = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 1), findCircleNum(&m3, 1, &cols3));

    var c0 = [_]i32{ 1, 0 };
    var c1 = [_]i32{ 0, 1 };
    var m4 = [_][*]i32{ &c0, &c1 };
    var cols4 = [_]i32{ 2, 2 };
    try std.testing.expectEqual(@as(i32, 2), findCircleNum(&m4, 2, &cols4));
}
