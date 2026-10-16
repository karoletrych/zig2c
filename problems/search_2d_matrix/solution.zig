// LeetCode 74. Search a 2D Matrix
// C signature:  bool searchMatrix(int** matrix, int matrixSize, int* matrixColSize,
//                                int target);
//
// Rows are sorted and the first value of each row is greater than the last value
// of the previous row, so the matrix is one sorted sequence. Binary search the
// flattened range and map the index back to (row, col).
const std = @import("std");

pub fn searchMatrix(matrix: [*][*]i32, matrixSize: i32, matrixColSize: [*]i32, target: i32) bool {
    if (matrixSize <= 0) return false;
    const n = matrixColSize[0];
    if (n <= 0) return false;
    const total: i32 = matrixSize * n;
    var lo: i32 = 0;
    var hi: i32 = total;
    while (lo < hi) {
        const mid = lo + @divTrunc(hi - lo, 2);
        const v = matrix[@intCast(@divTrunc(mid, n))][@intCast(@mod(mid, n))];
        if (v < target) {
            lo = mid + 1;
        } else {
            hi = mid;
        }
    }
    if (lo >= total) return false;
    const v2 = matrix[@intCast(@divTrunc(lo, n))][@intCast(@mod(lo, n))];
    return v2 == target;
}

test "searchMatrix examples" {
    var r0 = [_]i32{ 1, 3, 5, 7 };
    var r1 = [_]i32{ 10, 11, 16, 20 };
    var r2 = [_]i32{ 23, 30, 34, 60 };
    var m = [_][*]i32{ &r0, &r1, &r2 };
    var cols = [_]i32{ 4, 4, 4 };
    try std.testing.expect(searchMatrix(&m, 3, &cols, 3));
    try std.testing.expect(!searchMatrix(&m, 3, &cols, 13));
}

test "searchMatrix edges" {
    var r0 = [_]i32{ 1, 3, 5, 7 };
    var r1 = [_]i32{ 10, 11, 16, 20 };
    var r2 = [_]i32{ 23, 30, 34, 60 };
    var m = [_][*]i32{ &r0, &r1, &r2 };
    var cols = [_]i32{ 4, 4, 4 };
    // first and last cells
    try std.testing.expect(searchMatrix(&m, 3, &cols, 1));
    try std.testing.expect(searchMatrix(&m, 3, &cols, 60));
    // just outside both ends
    try std.testing.expect(!searchMatrix(&m, 3, &cols, 0));
    try std.testing.expect(!searchMatrix(&m, 3, &cols, 61));
    // a value sitting on a row boundary
    try std.testing.expect(searchMatrix(&m, 3, &cols, 10));
    try std.testing.expect(searchMatrix(&m, 3, &cols, 23));

    // single row
    var s0 = [_]i32{ 1, 2, 3 };
    var sm = [_][*]i32{&s0};
    var scols = [_]i32{3};
    try std.testing.expect(searchMatrix(&sm, 1, &scols, 2));
    try std.testing.expect(!searchMatrix(&sm, 1, &scols, 4));

    // single column
    var c0 = [_]i32{1};
    var c1 = [_]i32{3};
    var c2 = [_]i32{5};
    var cm = [_][*]i32{ &c0, &c1, &c2 };
    var ccols = [_]i32{ 1, 1, 1 };
    try std.testing.expect(searchMatrix(&cm, 3, &ccols, 3));
    try std.testing.expect(!searchMatrix(&cm, 3, &ccols, 4));

    // 1x1
    var one = [_]i32{5};
    var om = [_][*]i32{&one};
    var ocols = [_]i32{1};
    try std.testing.expect(searchMatrix(&om, 1, &ocols, 5));
    try std.testing.expect(!searchMatrix(&om, 1, &ocols, -5));
}
