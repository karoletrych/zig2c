// LeetCode 48. Rotate Image
// C signature:  void rotate(int** matrix, int matrixSize, int* matrixColSize);
//
// Transpose across the main diagonal, then reverse every row.
const std = @import("std");

pub fn rotate(matrix: [*][*]i32, matrixSize: i32, matrixColSize: [*]i32) void {
    _ = matrixColSize;
    const n = matrixSize;

    var i: i32 = 0;
    while (i < n) : (i += 1) {
        var j: i32 = i + 1;
        while (j < n) : (j += 1) {
            const t = matrix[@intCast(i)][@intCast(j)];
            matrix[@intCast(i)][@intCast(j)] = matrix[@intCast(j)][@intCast(i)];
            matrix[@intCast(j)][@intCast(i)] = t;
        }
    }

    i = 0;
    while (i < n) : (i += 1) {
        var a: i32 = 0;
        var b: i32 = n - 1;
        while (a < b) {
            const t = matrix[@intCast(i)][@intCast(a)];
            matrix[@intCast(i)][@intCast(a)] = matrix[@intCast(i)][@intCast(b)];
            matrix[@intCast(i)][@intCast(b)] = t;
            a += 1;
            b -= 1;
        }
    }
}

test "rotate example 3x3" {
    var r0 = [_]i32{ 1, 2, 3 };
    var r1 = [_]i32{ 4, 5, 6 };
    var r2 = [_]i32{ 7, 8, 9 };
    var m = [_][*]i32{ &r0, &r1, &r2 };
    var cols = [_]i32{ 3, 3, 3 };
    rotate(&m, 3, &cols);
    try std.testing.expectEqual(@as(i32, 7), r0[0]);
    try std.testing.expectEqual(@as(i32, 4), r0[1]);
    try std.testing.expectEqual(@as(i32, 1), r0[2]);
    try std.testing.expectEqual(@as(i32, 8), r1[0]);
    try std.testing.expectEqual(@as(i32, 5), r1[1]);
    try std.testing.expectEqual(@as(i32, 2), r1[2]);
    try std.testing.expectEqual(@as(i32, 9), r2[0]);
    try std.testing.expectEqual(@as(i32, 6), r2[1]);
    try std.testing.expectEqual(@as(i32, 3), r2[2]);
}

test "rotate example 4x4" {
    var r0 = [_]i32{ 5, 1, 9, 11 };
    var r1 = [_]i32{ 2, 4, 8, 10 };
    var r2 = [_]i32{ 13, 3, 6, 7 };
    var r3 = [_]i32{ 15, 14, 12, 16 };
    var m = [_][*]i32{ &r0, &r1, &r2, &r3 };
    var cols = [_]i32{ 4, 4, 4, 4 };
    rotate(&m, 4, &cols);
    try std.testing.expectEqual(@as(i32, 15), r0[0]);
    try std.testing.expectEqual(@as(i32, 13), r0[1]);
    try std.testing.expectEqual(@as(i32, 2), r0[2]);
    try std.testing.expectEqual(@as(i32, 5), r0[3]);
    try std.testing.expectEqual(@as(i32, 14), r1[0]);
    try std.testing.expectEqual(@as(i32, 3), r1[1]);
    try std.testing.expectEqual(@as(i32, 4), r1[2]);
    try std.testing.expectEqual(@as(i32, 1), r1[3]);
    try std.testing.expectEqual(@as(i32, 12), r2[0]);
    try std.testing.expectEqual(@as(i32, 6), r2[1]);
    try std.testing.expectEqual(@as(i32, 8), r2[2]);
    try std.testing.expectEqual(@as(i32, 9), r2[3]);
    try std.testing.expectEqual(@as(i32, 16), r3[0]);
    try std.testing.expectEqual(@as(i32, 7), r3[1]);
    try std.testing.expectEqual(@as(i32, 10), r3[2]);
    try std.testing.expectEqual(@as(i32, 11), r3[3]);
}

test "rotate edge 1x1" {
    var r0 = [_]i32{42};
    var m = [_][*]i32{&r0};
    var cols = [_]i32{1};
    rotate(&m, 1, &cols);
    try std.testing.expectEqual(@as(i32, 42), r0[0]);
}
