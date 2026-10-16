// LeetCode 200. Number of Islands
// C signature:  int numIslands(char** grid, int gridSize, int* gridColSize);
//
// Flood fill. Every time an unvisited '1' is seen a new island starts; an
// explicit stack (one entry per cell, so it can never overflow) visits the whole
// component in place by flipping cells to '0'.
const std = @import("std");
const allocator = std.heap.c_allocator;

const DR: [4]i32 = .{ -1, 1, 0, 0 };
const DC: [4]i32 = .{ 0, 0, -1, 1 };

pub fn numIslands(grid: [*][*]u8, gridSize: i32, gridColSize: [*]i32) i32 {
    const rows: i32 = gridSize;
    if (rows == 0) return 0;
    const cols: i32 = gridColSize[0];
    const total: usize = @intCast(rows * cols);

    const stack = allocator.alloc(i32, total) catch unreachable;
    defer allocator.free(stack);

    var count: i32 = 0;
    var r: i32 = 0;
    while (r < rows) : (r += 1) {
        var c: i32 = 0;
        while (c < cols) : (c += 1) {
            if (grid[@intCast(r)][@intCast(c)] != '1') continue;
            count += 1;
            var top: i32 = 0;
            stack[0] = r * cols + c;
            grid[@intCast(r)][@intCast(c)] = '0';

            while (top >= 0) {
                const pos: i32 = stack[@intCast(top)];
                top -= 1;
                const cr: i32 = @divTrunc(pos, cols);
                const cc: i32 = @mod(pos, cols);
                var d: usize = 0;
                while (d < 4) : (d += 1) {
                    const nr: i32 = cr + DR[d];
                    const nc: i32 = cc + DC[d];
                    if (nr < 0 or nr >= rows or nc < 0 or nc >= cols) continue;
                    if (grid[@intCast(nr)][@intCast(nc)] != '1') continue;
                    grid[@intCast(nr)][@intCast(nc)] = '0';
                    top += 1;
                    stack[@intCast(top)] = nr * cols + nc;
                }
            }
        }
    }
    return count;
}

test "numIslands examples" {
    var r0 = [_]u8{ '1', '1', '1', '1', '0' };
    var r1 = [_]u8{ '1', '1', '0', '1', '0' };
    var r2 = [_]u8{ '1', '1', '0', '0', '0' };
    var r3 = [_]u8{ '0', '0', '0', '0', '0' };
    var g = [_][*]u8{ &r0, &r1, &r2, &r3 };
    var cols = [_]i32{ 5, 5, 5, 5 };
    try std.testing.expectEqual(@as(i32, 1), numIslands(&g, 4, &cols));

    var s0 = [_]u8{ '1', '1', '0', '0', '0' };
    var s1 = [_]u8{ '1', '1', '0', '0', '0' };
    var s2 = [_]u8{ '0', '0', '1', '0', '0' };
    var s3 = [_]u8{ '0', '0', '0', '1', '1' };
    var g2 = [_][*]u8{ &s0, &s1, &s2, &s3 };
    var cols2 = [_]i32{ 5, 5, 5, 5 };
    try std.testing.expectEqual(@as(i32, 3), numIslands(&g2, 4, &cols2));
}

test "numIslands edges" {
    // all water
    var a0 = [_]u8{ '0', '0' };
    var a1 = [_]u8{ '0', '0' };
    var g = [_][*]u8{ &a0, &a1 };
    var cols = [_]i32{ 2, 2 };
    try std.testing.expectEqual(@as(i32, 0), numIslands(&g, 2, &cols));

    // single land cell
    var b0 = [_]u8{'1'};
    var g2 = [_][*]u8{&b0};
    var cols2 = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 1), numIslands(&g2, 1, &cols2));

    // diagonal cells are not connected
    var c0 = [_]u8{ '1', '0' };
    var c1 = [_]u8{ '0', '1' };
    var g3 = [_][*]u8{ &c0, &c1 };
    var cols3 = [_]i32{ 2, 2 };
    try std.testing.expectEqual(@as(i32, 2), numIslands(&g3, 2, &cols3));

    // one long snake using an explicit stack instead of recursion
    var d0 = [_]u8{ '1', '0', '0' };
    var d1 = [_]u8{ '1', '0', '0' };
    var d2 = [_]u8{ '1', '1', '1' };
    var g4 = [_][*]u8{ &d0, &d1, &d2 };
    var cols4 = [_]i32{ 3, 3, 3 };
    try std.testing.expectEqual(@as(i32, 1), numIslands(&g4, 3, &cols4));
}
