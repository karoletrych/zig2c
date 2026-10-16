// LeetCode 2352. Equal Row and Column Pairs
// C signature:  int equalPairs(int** grid, int gridSize, int* gridColSize);
const std = @import("std");

pub fn equalPairs(grid: [*][*]i32, gridSize: i32, gridColSize: [*]i32) i32 {
    const n: i32 = gridSize;
    const m: i32 = gridColSize[0];
    if (n != m) return 0;

    var count: i32 = 0;
    var r: i32 = 0;
    while (r < n) : (r += 1) {
        var c: i32 = 0;
        while (c < m) : (c += 1) {
            var k: i32 = 0;
            var same = true;
            while (k < n) : (k += 1) {
                if (grid[@intCast(r)][@intCast(k)] != grid[@intCast(k)][@intCast(c)]) {
                    same = false;
                    break;
                }
            }
            if (same) count += 1;
        }
    }
    return count;
}

test "equalPairs" {
    var r0 = [_]i32{ 3, 2, 1 };
    var r1 = [_]i32{ 1, 7, 6 };
    var r2 = [_]i32{ 2, 7, 7 };
    var grid = [_][*]i32{ &r0, &r1, &r2 };
    var cols = [_]i32{3};
    try std.testing.expectEqual(@as(i32, 1), equalPairs(&grid, 3, &cols));

    var a0 = [_]i32{ 11, 1 };
    var a1 = [_]i32{ 1, 11 };
    var g2 = [_][*]i32{ &a0, &a1 };
    var c2 = [_]i32{2};
    try std.testing.expectEqual(@as(i32, 2), equalPairs(&g2, 2, &c2));

    var b0 = [_]i32{ 4, 4 };
    var b1 = [_]i32{ 4, 4 };
    var g3 = [_][*]i32{ &b0, &b1 };
    var c3 = [_]i32{2};
    try std.testing.expectEqual(@as(i32, 4), equalPairs(&g3, 2, &c3));

    var d0 = [_]i32{5};
    var g4 = [_][*]i32{&d0};
    var c4 = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 1), equalPairs(&g4, 1, &c4));
}
