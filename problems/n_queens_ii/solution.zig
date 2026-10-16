// LeetCode 52. N-Queens II
// C signature:  int totalNQueens(int n);
//
// Plain backtracking one row at a time with three occupation arrays: columns,
// `row + col` diagonals and `row - col + n` anti-diagonals.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn place(n: i32, row: i32, cols: [*]bool, diag: [*]bool, anti: [*]bool) i32 {
    if (row == n) return 1;
    var total: i32 = 0;
    var c: i32 = 0;
    while (c < n) : (c += 1) {
        const d1: i32 = row + c;
        const d2: i32 = row - c + n;
        if (cols[@intCast(c)] or diag[@intCast(d1)] or anti[@intCast(d2)]) continue;
        cols[@intCast(c)] = true;
        diag[@intCast(d1)] = true;
        anti[@intCast(d2)] = true;
        total += place(n, row + 1, cols, diag, anti);
        cols[@intCast(c)] = false;
        diag[@intCast(d1)] = false;
        anti[@intCast(d2)] = false;
    }
    return total;
}

pub fn totalNQueens(n: i32) i32 {
    if (n <= 0) return 0;
    const diagSize: usize = @intCast(2 * n + 1);

    const cols = allocator.alloc(bool, @intCast(n)) catch unreachable;
    defer allocator.free(cols);
    const diag = allocator.alloc(bool, diagSize) catch unreachable;
    defer allocator.free(diag);
    const anti = allocator.alloc(bool, diagSize) catch unreachable;
    defer allocator.free(anti);

    var i: usize = 0;
    while (i < cols.len) : (i += 1) cols[i] = false;
    i = 0;
    while (i < diagSize) : (i += 1) {
        diag[i] = false;
        anti[i] = false;
    }
    return place(n, 0, cols.ptr, diag.ptr, anti.ptr);
}

test "totalNQueens examples" {
    try std.testing.expectEqual(@as(i32, 2), totalNQueens(4));
    try std.testing.expectEqual(@as(i32, 1), totalNQueens(1));
}

test "totalNQueens counts" {
    try std.testing.expectEqual(@as(i32, 0), totalNQueens(2));
    try std.testing.expectEqual(@as(i32, 0), totalNQueens(3));
    try std.testing.expectEqual(@as(i32, 10), totalNQueens(5));
    try std.testing.expectEqual(@as(i32, 4), totalNQueens(6));
    try std.testing.expectEqual(@as(i32, 40), totalNQueens(7));
    try std.testing.expectEqual(@as(i32, 92), totalNQueens(8));
    try std.testing.expectEqual(@as(i32, 352), totalNQueens(9));
}
