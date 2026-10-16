// LeetCode 54. Spiral Matrix
// C signature:  int* spiralOrder(int** matrix, int matrixSize, int* matrixColSize,
//                                int* returnSize);
//
// Four moving boundaries (top, bottom, left, right). The bottom and left walks
// are guarded so single-row / single-column matrices are not revisited.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn spiralOrder(matrix: [*][*]i32, matrixSize: i32, matrixColSize: [*]i32, returnSize: *i32) ?[*]i32 {
    if (matrixSize <= 0) {
        returnSize.* = 0;
        return null;
    }
    const rows = matrixSize;
    const cols = matrixColSize[0];
    const total: usize = @intCast(rows * cols);
    const out = allocator.alloc(i32, total) catch unreachable;

    var k: usize = 0;
    var top: i32 = 0;
    var bottom: i32 = rows - 1;
    var left: i32 = 0;
    var right: i32 = cols - 1;

    while (top <= bottom and left <= right) {
        var c: i32 = left;
        while (c <= right) : (c += 1) {
            out[k] = matrix[@intCast(top)][@intCast(c)];
            k += 1;
        }
        top += 1;

        var r: i32 = top;
        while (r <= bottom) : (r += 1) {
            out[k] = matrix[@intCast(r)][@intCast(right)];
            k += 1;
        }
        right -= 1;

        if (top <= bottom) {
            c = right;
            while (c >= left) : (c -= 1) {
                out[k] = matrix[@intCast(bottom)][@intCast(c)];
                k += 1;
            }
            bottom -= 1;
        }

        if (left <= right) {
            r = bottom;
            while (r >= top) : (r -= 1) {
                out[k] = matrix[@intCast(r)][@intCast(left)];
                k += 1;
            }
            left += 1;
        }
    }

    returnSize.* = @intCast(k);
    return out.ptr;
}

test "spiralOrder example 1" {
    var r0 = [_]i32{ 1, 2, 3 };
    var r1 = [_]i32{ 4, 5, 6 };
    var r2 = [_]i32{ 7, 8, 9 };
    var m = [_][*]i32{ &r0, &r1, &r2 };
    var cols = [_]i32{ 3, 3, 3 };
    var rs: i32 = 0;
    const out = spiralOrder(&m, 3, &cols, &rs).?;
    try std.testing.expectEqual(@as(i32, 9), rs);
    const want = [_]i32{ 1, 2, 3, 6, 9, 8, 7, 4, 5 };
    var i: usize = 0;
    while (i < 9) : (i += 1) try std.testing.expectEqual(want[i], out[i]);
}

test "spiralOrder example 2" {
    var r0 = [_]i32{ 1, 2, 3, 4 };
    var r1 = [_]i32{ 5, 6, 7, 8 };
    var r2 = [_]i32{ 9, 10, 11, 12 };
    var m = [_][*]i32{ &r0, &r1, &r2 };
    var cols = [_]i32{ 4, 4, 4 };
    var rs: i32 = 0;
    const out = spiralOrder(&m, 3, &cols, &rs).?;
    try std.testing.expectEqual(@as(i32, 12), rs);
    const want = [_]i32{ 1, 2, 3, 4, 8, 12, 11, 10, 9, 5, 6, 7 };
    var i: usize = 0;
    while (i < 12) : (i += 1) try std.testing.expectEqual(want[i], out[i]);
}

test "spiralOrder edges" {
    var s0 = [_]i32{ 1, 2, 3 };
    var sm = [_][*]i32{&s0};
    var scols = [_]i32{3};
    var rs: i32 = 0;
    const out = spiralOrder(&sm, 1, &scols, &rs).?;
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqual(@as(i32, 1), out[0]);
    try std.testing.expectEqual(@as(i32, 2), out[1]);
    try std.testing.expectEqual(@as(i32, 3), out[2]);

    var c0 = [_]i32{1};
    var c1 = [_]i32{2};
    var c2 = [_]i32{3};
    var cm = [_][*]i32{ &c0, &c1, &c2 };
    var ccols = [_]i32{ 1, 1, 1 };
    var rs2: i32 = 0;
    const out2 = spiralOrder(&cm, 3, &ccols, &rs2).?;
    try std.testing.expectEqual(@as(i32, 3), rs2);
    try std.testing.expectEqual(@as(i32, 1), out2[0]);
    try std.testing.expectEqual(@as(i32, 2), out2[1]);
    try std.testing.expectEqual(@as(i32, 3), out2[2]);

    var rs3: i32 = 5;
    const out3 = spiralOrder(undefined, 0, undefined, &rs3);
    try std.testing.expectEqual(@as(i32, 0), rs3);
    try std.testing.expect(out3 == null);
}
