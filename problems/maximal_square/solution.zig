// LeetCode 221. Maximal Square
// C signature:  int maximalSquare(char** matrix, int matrixSize, int* matrixColSize);
//
// dp[j] is the side of the largest all-'1' square ending at the current cell.
// A '1' extends min(above, left, above-left) + 1; a '0' resets to 0. The input
// is a matrix of the characters '0' and '1'.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn maximalSquare(matrix: [*][*]u8, matrixSize: i32, matrixColSize: [*]i32) i32 {
    if (matrixSize == 0) return 0;
    const m: usize = @intCast(matrixSize);
    const n: usize = @intCast(matrixColSize[0]);
    if (n == 0) return 0;

    const dp = allocator.alloc(i32, n + 1) catch unreachable;
    var j: usize = 0;
    while (j <= n) : (j += 1) dp[j] = 0;

    var best: i32 = 0;
    var i: usize = 1;
    while (i <= m) : (i += 1) {
        var prev: i32 = 0;
        j = 1;
        while (j <= n) : (j += 1) {
            const cur = dp[j];
            if (matrix[i - 1][j - 1] == '1') {
                const v = @min(@min(dp[j], dp[j - 1]), prev) + 1;
                dp[j] = v;
                if (v > best) best = v;
            } else {
                dp[j] = 0;
            }
            prev = cur;
        }
    }

    allocator.free(dp);
    return best * best;
}

test "maximalSquare examples" {
    var r0 = [_]u8{ '1', '0', '1', '0', '0' };
    var r1 = [_]u8{ '1', '0', '1', '1', '1' };
    var r2 = [_]u8{ '1', '1', '1', '1', '1' };
    var r3 = [_]u8{ '1', '0', '0', '1', '0' };
    var g = [_][*]u8{ &r0, &r1, &r2, &r3 };
    var cols = [_]i32{ 5, 5, 5, 5 };
    try std.testing.expectEqual(@as(i32, 4), maximalSquare(&g, 4, &cols));

    var s0 = [_]u8{ '0', '1' };
    var s1 = [_]u8{ '1', '0' };
    var g2 = [_][*]u8{ &s0, &s1 };
    var c2 = [_]i32{ 2, 2 };
    try std.testing.expectEqual(@as(i32, 1), maximalSquare(&g2, 2, &c2));
}

test "maximalSquare edges" {
    var a0 = [_]u8{'0'};
    var g1 = [_][*]u8{&a0};
    var c1 = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 0), maximalSquare(&g1, 1, &c1));

    var b0 = [_]u8{ '1', '1' };
    var b1 = [_]u8{ '1', '1' };
    var g2 = [_][*]u8{ &b0, &b1 };
    var c2 = [_]i32{ 2, 2 };
    try std.testing.expectEqual(@as(i32, 4), maximalSquare(&g2, 2, &c2));

    var d0 = [_]u8{'1'};
    var g3 = [_][*]u8{&d0};
    var c3 = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 1), maximalSquare(&g3, 1, &c3));

    var e0 = [_]u8{ '1', '0', '1' };
    var g4 = [_][*]u8{&e0};
    var c4 = [_]i32{3};
    try std.testing.expectEqual(@as(i32, 1), maximalSquare(&g4, 1, &c4));

    var f0 = [_]u8{ '1', '1', '1' };
    var f1 = [_]u8{ '1', '1', '1' };
    var f2 = [_]u8{ '1', '1', '1' };
    var g5 = [_][*]u8{ &f0, &f1, &f2 };
    var c5 = [_]i32{ 3, 3, 3 };
    try std.testing.expectEqual(@as(i32, 9), maximalSquare(&g5, 3, &c5));
}
