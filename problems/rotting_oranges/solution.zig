// LeetCode 994. Rotting Oranges
// C signature:  int orangesRotting(int** grid, int gridSize, int* gridColSize);
//
// Multi-source breadth-first search from every initially rotten orange; count
// the number of minute rounds during which the rot spreads.
const std = @import("std");
const allocator = std.heap.c_allocator;

const DR: [4]i32 = .{ -1, 1, 0, 0 };
const DC: [4]i32 = .{ 0, 0, -1, 1 };

pub fn orangesRotting(grid: [*][*]i32, gridSize: i32, gridColSize: [*]i32) i32 {
    const rows: i32 = gridSize;
    const cols: i32 = gridColSize[0];
    const total: usize = @intCast(rows * cols);

    const qr = allocator.alloc(i32, total) catch unreachable;
    defer allocator.free(qr);
    const qc = allocator.alloc(i32, total) catch unreachable;
    defer allocator.free(qc);

    var head: i32 = 0;
    var tail: i32 = 0;
    var fresh: i32 = 0;

    var r: i32 = 0;
    while (r < rows) : (r += 1) {
        var c: i32 = 0;
        while (c < cols) : (c += 1) {
            const v: i32 = grid[@intCast(r)][@intCast(c)];
            if (v == 2) {
                qr[@intCast(tail)] = r;
                qc[@intCast(tail)] = c;
                tail += 1;
            } else if (v == 1) {
                fresh += 1;
            }
        }
    }

    if (fresh == 0) return 0;

    var minutes: i32 = 0;
    while (head < tail) {
        const levelEnd: i32 = tail;
        var spread = false;
        while (head < levelEnd) {
            const cr: i32 = qr[@intCast(head)];
            const cc: i32 = qc[@intCast(head)];
            head += 1;

            var d: usize = 0;
            while (d < 4) : (d += 1) {
                const nr: i32 = cr + DR[d];
                const nc: i32 = cc + DC[d];
                if (nr < 0 or nr >= rows or nc < 0 or nc >= cols) continue;
                if (grid[@intCast(nr)][@intCast(nc)] != 1) continue;
                grid[@intCast(nr)][@intCast(nc)] = 2;
                fresh -= 1;
                spread = true;
                qr[@intCast(tail)] = nr;
                qc[@intCast(tail)] = nc;
                tail += 1;
            }
        }
        if (spread) minutes += 1;
    }

    if (fresh > 0) return -1;
    return minutes;
}

test "orangesRotting" {
    var a0 = [_]i32{ 2, 1, 1 };
    var a1 = [_]i32{ 1, 1, 0 };
    var a2 = [_]i32{ 0, 1, 1 };
    var g = [_][*]i32{ &a0, &a1, &a2 };
    var cols = [_]i32{ 3, 3, 3 };
    try std.testing.expectEqual(@as(i32, 4), orangesRotting(&g, 3, &cols));

    var b0 = [_]i32{ 2, 1, 1 };
    var b1 = [_]i32{ 0, 1, 1 };
    var b2 = [_]i32{ 1, 0, 1 };
    var g2 = [_][*]i32{ &b0, &b1, &b2 };
    var cols2 = [_]i32{ 3, 3, 3 };
    try std.testing.expectEqual(@as(i32, -1), orangesRotting(&g2, 3, &cols2));

    var c0 = [_]i32{ 0, 2 };
    var g3 = [_][*]i32{&c0};
    var cols3 = [_]i32{2};
    try std.testing.expectEqual(@as(i32, 0), orangesRotting(&g3, 1, &cols3));

    var d0 = [_]i32{0};
    var g4 = [_][*]i32{&d0};
    var cols4 = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 0), orangesRotting(&g4, 1, &cols4));

    var e0 = [_]i32{1};
    var g5 = [_][*]i32{&e0};
    var cols5 = [_]i32{1};
    try std.testing.expectEqual(@as(i32, -1), orangesRotting(&g5, 1, &cols5));

    var f0 = [_]i32{2};
    var g6 = [_][*]i32{&f0};
    var cols6 = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 0), orangesRotting(&g6, 1, &cols6));
}
