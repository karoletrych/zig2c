// LeetCode 73. Set Matrix Zeroes
// C signature:  void setZeroes(int** matrix, int matrixSize, int* matrixColSize);
//
// Use the first row and first column as the zero markers (plus two booleans for
// the first row/column themselves) so the extra space is O(1).
const std = @import("std");

pub fn setZeroes(matrix: [*][*]i32, matrixSize: i32, matrixColSize: [*]i32) void {
    const m = matrixSize;
    const n = matrixColSize[0];

    var firstRowZero = false;
    var c: i32 = 0;
    while (c < n) : (c += 1) {
        if (matrix[0][@intCast(c)] == 0) firstRowZero = true;
    }

    var firstColZero = false;
    var r: i32 = 0;
    while (r < m) : (r += 1) {
        if (matrix[@intCast(r)][0] == 0) firstColZero = true;
    }

    r = 1;
    while (r < m) : (r += 1) {
        c = 1;
        while (c < n) : (c += 1) {
            if (matrix[@intCast(r)][@intCast(c)] == 0) {
                matrix[@intCast(r)][0] = 0;
                matrix[0][@intCast(c)] = 0;
            }
        }
    }

    r = 1;
    while (r < m) : (r += 1) {
        c = 1;
        while (c < n) : (c += 1) {
            if (matrix[@intCast(r)][0] == 0 or matrix[0][@intCast(c)] == 0) {
                matrix[@intCast(r)][@intCast(c)] = 0;
            }
        }
    }

    if (firstRowZero) {
        c = 0;
        while (c < n) : (c += 1) matrix[0][@intCast(c)] = 0;
    }
    if (firstColZero) {
        r = 0;
        while (r < m) : (r += 1) matrix[@intCast(r)][0] = 0;
    }
}

test "setZeroes example 1" {
    var r0 = [_]i32{ 1, 1, 1 };
    var r1 = [_]i32{ 1, 0, 1 };
    var r2 = [_]i32{ 1, 1, 1 };
    var m = [_][*]i32{ &r0, &r1, &r2 };
    var cols = [_]i32{ 3, 3, 3 };
    setZeroes(&m, 3, &cols);
    try std.testing.expectEqual(@as(i32, 1), r0[0]);
    try std.testing.expectEqual(@as(i32, 0), r0[1]);
    try std.testing.expectEqual(@as(i32, 1), r0[2]);
    try std.testing.expectEqual(@as(i32, 0), r1[0]);
    try std.testing.expectEqual(@as(i32, 0), r1[1]);
    try std.testing.expectEqual(@as(i32, 0), r1[2]);
    try std.testing.expectEqual(@as(i32, 1), r2[0]);
    try std.testing.expectEqual(@as(i32, 0), r2[1]);
    try std.testing.expectEqual(@as(i32, 1), r2[2]);
}

test "setZeroes example 2" {
    var r0 = [_]i32{ 0, 1, 2, 0 };
    var r1 = [_]i32{ 3, 4, 5, 2 };
    var r2 = [_]i32{ 1, 3, 1, 5 };
    var m = [_][*]i32{ &r0, &r1, &r2 };
    var cols = [_]i32{ 4, 4, 4 };
    setZeroes(&m, 3, &cols);
    try std.testing.expectEqual(@as(i32, 0), r0[0]);
    try std.testing.expectEqual(@as(i32, 0), r0[1]);
    try std.testing.expectEqual(@as(i32, 0), r0[2]);
    try std.testing.expectEqual(@as(i32, 0), r0[3]);
    try std.testing.expectEqual(@as(i32, 0), r1[0]);
    try std.testing.expectEqual(@as(i32, 4), r1[1]);
    try std.testing.expectEqual(@as(i32, 5), r1[2]);
    try std.testing.expectEqual(@as(i32, 0), r1[3]);
    try std.testing.expectEqual(@as(i32, 0), r2[0]);
    try std.testing.expectEqual(@as(i32, 3), r2[1]);
    try std.testing.expectEqual(@as(i32, 1), r2[2]);
    try std.testing.expectEqual(@as(i32, 0), r2[3]);
}

test "setZeroes edges" {
    // zero in the first cell only
    var r0 = [_]i32{ 0, 2 };
    var r1 = [_]i32{ 3, 4 };
    var m = [_][*]i32{ &r0, &r1 };
    var cols = [_]i32{ 2, 2 };
    setZeroes(&m, 2, &cols);
    try std.testing.expectEqual(@as(i32, 0), r0[0]);
    try std.testing.expectEqual(@as(i32, 0), r0[1]);
    try std.testing.expectEqual(@as(i32, 0), r1[0]);
    try std.testing.expectEqual(@as(i32, 4), r1[1]);

    // single row
    var s0 = [_]i32{ 1, 0, 3 };
    var sm = [_][*]i32{&s0};
    var scols = [_]i32{3};
    setZeroes(&sm, 1, &scols);
    try std.testing.expectEqual(@as(i32, 0), s0[0]);
    try std.testing.expectEqual(@as(i32, 0), s0[1]);
    try std.testing.expectEqual(@as(i32, 0), s0[2]);
}
