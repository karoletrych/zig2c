// LeetCode 130. Surrounded Regions
// C signature:  void solve(char** board, int boardSize, int* boardColSize);
//
// A region of 'O' survives iff it touches the border. Flood-fill every
// border-touching 'O' to a temporary '#', then sweep: the remaining 'O' cells
// are enclosed, and every '#' goes back to 'O'.
const std = @import("std");
const allocator = std.heap.c_allocator;

const DR: [4]i32 = .{ -1, 1, 0, 0 };
const DC: [4]i32 = .{ 0, 0, -1, 1 };

fn flood(board: [*][*]u8, rows: i32, cols: i32, stack: [*]i32, sr: i32, sc: i32) void {
    var top: i32 = 0;
    stack[0] = sr * cols + sc;
    board[@intCast(sr)][@intCast(sc)] = '#';
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
            if (board[@intCast(nr)][@intCast(nc)] != 'O') continue;
            board[@intCast(nr)][@intCast(nc)] = '#';
            top += 1;
            stack[@intCast(top)] = nr * cols + nc;
        }
    }
}

pub fn solve(board: [*][*]u8, boardSize: i32, boardColSize: [*]i32) void {
    const rows: i32 = boardSize;
    if (rows == 0) return;
    const cols: i32 = boardColSize[0];

    const stack = allocator.alloc(i32, @intCast(rows * cols)) catch unreachable;
    defer allocator.free(stack);

    // 1. every 'O' reachable from the border is safe
    var c: i32 = 0;
    while (c < cols) : (c += 1) {
        if (board[0][@intCast(c)] == 'O') flood(board, rows, cols, stack.ptr, 0, c);
        if (board[@intCast(rows - 1)][@intCast(c)] == 'O') flood(board, rows, cols, stack.ptr, rows - 1, c);
    }
    var r: i32 = 0;
    while (r < rows) : (r += 1) {
        if (board[@intCast(r)][0] == 'O') flood(board, rows, cols, stack.ptr, r, 0);
        if (board[@intCast(r)][@intCast(cols - 1)] == 'O') flood(board, rows, cols, stack.ptr, r, cols - 1);
    }

    // 2. enclosed 'O' -> 'X', temporary '#' -> 'O'
    r = 0;
    while (r < rows) : (r += 1) {
        c = 0;
        while (c < cols) : (c += 1) {
            const ch = board[@intCast(r)][@intCast(c)];
            if (ch == 'O') {
                board[@intCast(r)][@intCast(c)] = 'X';
            } else if (ch == '#') {
                board[@intCast(r)][@intCast(c)] = 'O';
            }
        }
    }
}

test "solve example" {
    var r0 = [_]u8{ 'X', 'X', 'X', 'X' };
    var r1 = [_]u8{ 'X', 'O', 'O', 'X' };
    var r2 = [_]u8{ 'X', 'X', 'O', 'X' };
    var r3 = [_]u8{ 'X', 'O', 'X', 'X' };
    var b = [_][*]u8{ &r0, &r1, &r2, &r3 };
    var cols = [_]i32{ 4, 4, 4, 4 };
    solve(&b, 4, &cols);

    const want = [4][4]u8{
        .{ 'X', 'X', 'X', 'X' },
        .{ 'X', 'X', 'X', 'X' },
        .{ 'X', 'X', 'X', 'X' },
        .{ 'X', 'O', 'X', 'X' },
    };
    var i: usize = 0;
    while (i < 4) : (i += 1) {
        var j: usize = 0;
        while (j < 4) : (j += 1) try std.testing.expectEqual(want[i][j], b[i][j]);
    }
}

test "solve edges" {
    // 1x1: a lone border cell can never be captured
    var a0 = [_]u8{'O'};
    var b1 = [_][*]u8{&a0};
    var cols1 = [_]i32{1};
    solve(&b1, 1, &cols1);
    try std.testing.expectEqual(@as(u8, 'O'), a0[0]);

    // a ring touching the border survives, the hole is filled
    var c0 = [_]u8{ 'O', 'O', 'O' };
    var c1 = [_]u8{ 'O', 'X', 'O' };
    var c2 = [_]u8{ 'O', 'O', 'O' };
    var b2 = [_][*]u8{ &c0, &c1, &c2 };
    var cols2 = [_]i32{ 3, 3, 3 };
    solve(&b2, 3, &cols2);
    try std.testing.expectEqual(@as(u8, 'O'), c0[0]);
    try std.testing.expectEqual(@as(u8, 'X'), c1[1]);
    try std.testing.expectEqual(@as(u8, 'O'), c2[2]);

    // interior block with no border contact is captured
    var d0 = [_]u8{ 'X', 'X', 'X', 'X', 'X' };
    var d1 = [_]u8{ 'X', 'O', 'O', 'O', 'X' };
    var d2 = [_]u8{ 'X', 'O', 'O', 'O', 'X' };
    var d3 = [_]u8{ 'X', 'O', 'O', 'O', 'X' };
    var d4 = [_]u8{ 'X', 'X', 'X', 'X', 'X' };
    var b3 = [_][*]u8{ &d0, &d1, &d2, &d3, &d4 };
    var cols3 = [_]i32{ 5, 5, 5, 5, 5 };
    solve(&b3, 5, &cols3);
    try std.testing.expectEqual(@as(u8, 'X'), d1[1]);
    try std.testing.expectEqual(@as(u8, 'X'), d2[2]);
    try std.testing.expectEqual(@as(u8, 'X'), d3[3]);
    try std.testing.expectEqual(@as(u8, 'X'), d0[0]);
    try std.testing.expectEqual(@as(u8, 'X'), d4[4]);
}
