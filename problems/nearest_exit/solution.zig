// LeetCode 1926. Nearest Exit from Entrance in Maze
// C signature:  int nearestExit(char** maze, int mazeSize, int* mazeColSize,
//                              int* entrance, int entranceSize);
//
// Breadth-first search from the entrance. The first border cell (other than the
// entrance itself) that we step onto is a nearest exit.
const std = @import("std");
const allocator = std.heap.c_allocator;

const DR: [4]i32 = .{ -1, 1, 0, 0 };
const DC: [4]i32 = .{ 0, 0, -1, 1 };

pub fn nearestExit(maze: [*][*]u8, mazeSize: i32, mazeColSize: [*]i32, entrance: [*]i32, entranceSize: i32) i32 {
    _ = entranceSize;

    const rows: i32 = mazeSize;
    const cols: i32 = mazeColSize[0];
    const total: usize = @intCast(rows * cols);

    const visited = allocator.alloc(bool, total) catch unreachable;
    defer allocator.free(visited);
    var i: usize = 0;
    while (i < total) : (i += 1) visited[i] = false;

    const qr = allocator.alloc(i32, total) catch unreachable;
    defer allocator.free(qr);
    const qc = allocator.alloc(i32, total) catch unreachable;
    defer allocator.free(qc);

    const er: i32 = entrance[0];
    const ec: i32 = entrance[1];

    var head: i32 = 0;
    var tail: i32 = 1;
    qr[0] = er;
    qc[0] = ec;
    visited[@intCast(er * cols + ec)] = true;

    var steps: i32 = 0;
    while (head < tail) {
        const levelEnd: i32 = tail;
        while (head < levelEnd) {
            const r: i32 = qr[@intCast(head)];
            const c: i32 = qc[@intCast(head)];
            head += 1;

            var d: usize = 0;
            while (d < 4) : (d += 1) {
                const nr: i32 = r + DR[d];
                const nc: i32 = c + DC[d];
                if (nr < 0 or nr >= rows or nc < 0 or nc >= cols) continue;
                if (maze[@intCast(nr)][@intCast(nc)] == '+') continue;
                const idx: usize = @intCast(nr * cols + nc);
                if (visited[idx]) continue;
                if (nr == 0 or nr == rows - 1 or nc == 0 or nc == cols - 1) {
                    return steps + 1;
                }
                visited[idx] = true;
                qr[@intCast(tail)] = nr;
                qc[@intCast(tail)] = nc;
                tail += 1;
            }
        }
        steps += 1;
    }
    return -1;
}

test "nearestExit" {
    var r0 = [_]u8{ '+', '+', '.', '+' };
    var r1 = [_]u8{ '.', '.', '.', '+' };
    var r2 = [_]u8{ '+', '+', '+', '.' };
    var m = [_][*]u8{ &r0, &r1, &r2 };
    var cols = [_]i32{4};
    var e1 = [_]i32{ 1, 2 };
    try std.testing.expectEqual(@as(i32, 1), nearestExit(&m, 3, &cols, &e1, 2));

    var s0 = [_]u8{ '+', '+', '+' };
    var s1 = [_]u8{ '.', '.', '.' };
    var s2 = [_]u8{ '+', '+', '+' };
    var m2 = [_][*]u8{ &s0, &s1, &s2 };
    var cols2 = [_]i32{3};
    var e2 = [_]i32{ 1, 0 };
    try std.testing.expectEqual(@as(i32, 2), nearestExit(&m2, 3, &cols2, &e2, 2));

    var t0 = [_]u8{ '.', '+' };
    var m3 = [_][*]u8{&t0};
    var cols3 = [_]i32{2};
    var e3 = [_]i32{ 0, 0 };
    try std.testing.expectEqual(@as(i32, -1), nearestExit(&m3, 1, &cols3, &e3, 2));

    var v0 = [_]u8{'.'};
    var m5 = [_][*]u8{&v0};
    var cols5 = [_]i32{1};
    var e5 = [_]i32{ 0, 0 };
    try std.testing.expectEqual(@as(i32, -1), nearestExit(&m5, 1, &cols5, &e5, 2));

    var w0 = [_]u8{ '+', '+', '+' };
    var w1 = [_]u8{ '.', '.', '+' };
    var w2 = [_]u8{ '+', '+', '+' };
    var m4 = [_][*]u8{ &w0, &w1, &w2 };
    var cols4 = [_]i32{3};
    var e4 = [_]i32{ 1, 0 };
    try std.testing.expectEqual(@as(i32, -1), nearestExit(&m4, 3, &cols4, &e4, 2));
}
