// LeetCode 289. Game of Life
// C signature:  void gameOfLife(int** board, int boardSize, int* boardColSize);
//
// The next state is accumulated in the second bit of every cell: bit 0 is the
// current state and bit 1 is the next state. Once every cell has been decided
// (each uses only bit 0 of its neighbours) the whole board is shifted right.
const std = @import("std");

fn liveCell(cell: i32) i32 {
    return cell & 1;
}

pub fn gameOfLife(board: [*][*]i32, boardSize: i32, boardColSize: [*]i32) void {
    const rows: i32 = boardSize;
    if (rows == 0) return;
    const cols: i32 = boardColSize[0];

    var r: i32 = 0;
    while (r < rows) : (r += 1) {
        var c: i32 = 0;
        while (c < cols) : (c += 1) {
            var n: i32 = 0;
            var dr: i32 = -1;
            while (dr <= 1) : (dr += 1) {
                var dc: i32 = -1;
                while (dc <= 1) : (dc += 1) {
                    if (dr == 0 and dc == 0) continue;
                    const nr = r + dr;
                    const nc = c + dc;
                    if (nr < 0 or nr >= rows or nc < 0 or nc >= cols) continue;
                    n += liveCell(board[@intCast(nr)][@intCast(nc)]);
                }
            }
            const cur = liveCell(board[@intCast(r)][@intCast(c)]);
            var nxt: i32 = 0;
            if (cur == 1) {
                if (n == 2 or n == 3) nxt = 1;
            } else {
                if (n == 3) nxt = 1;
            }
            board[@intCast(r)][@intCast(c)] += nxt << 1;
        }
    }

    r = 0;
    while (r < rows) : (r += 1) {
        var c: i32 = 0;
        while (c < cols) : (c += 1) {
            board[@intCast(r)][@intCast(c)] >>= 1;
        }
    }
}

test "gameOfLife example" {
    var r0 = [_]i32{ 0, 1, 0 };
    var r1 = [_]i32{ 0, 0, 1 };
    var r2 = [_]i32{ 1, 1, 1 };
    var r3 = [_]i32{ 0, 0, 0 };
    var b = [_][*]i32{ &r0, &r1, &r2, &r3 };
    var cols = [_]i32{3};
    gameOfLife(&b, 4, &cols);

    const want = [4][3]i32{
        .{ 0, 0, 0 },
        .{ 1, 0, 1 },
        .{ 0, 1, 1 },
        .{ 0, 1, 0 },
    };
    var i: usize = 0;
    while (i < 4) : (i += 1) {
        var j: usize = 0;
        while (j < 3) : (j += 1) {
            try std.testing.expectEqual(want[i][j], b[i][j]);
        }
    }
}

test "gameOfLife blinker and still life" {
    // Blinker: horizontal -> vertical.
    var a0 = [_]i32{ 0, 0, 0, 0, 0 };
    var a1 = [_]i32{ 0, 0, 0, 0, 0 };
    var a2 = [_]i32{ 0, 1, 1, 1, 0 };
    var a3 = [_]i32{ 0, 0, 0, 0, 0 };
    var a4 = [_]i32{ 0, 0, 0, 0, 0 };
    var b = [_][*]i32{ &a0, &a1, &a2, &a3, &a4 };
    var cols = [_]i32{5};
    gameOfLife(&b, 5, &cols);
    const want = [5][5]i32{
        .{ 0, 0, 0, 0, 0 },
        .{ 0, 0, 1, 0, 0 },
        .{ 0, 0, 1, 0, 0 },
        .{ 0, 0, 1, 0, 0 },
        .{ 0, 0, 0, 0, 0 },
    };
    var i: usize = 0;
    while (i < 5) : (i += 1) {
        var j: usize = 0;
        while (j < 5) : (j += 1) try std.testing.expectEqual(want[i][j], b[i][j]);
    }

    // Single cell dies.
    var c0 = [_]i32{1};
    var c = [_][*]i32{&c0};
    var cols1 = [_]i32{1};
    gameOfLife(&c, 1, &cols1);
    try std.testing.expectEqual(@as(i32, 0), c0[0]);
}
