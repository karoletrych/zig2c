// LeetCode 36. Valid Sudoku
// C signature:  bool isValidSudoku(char** board, int boardSize, int* boardColSize);
//
// Three flattened 9x9 seen-tables (rows, columns, 3x3 boxes); each digit is
// stored at offset (line index) * 9 + (digit - '1').
const std = @import("std");

pub fn isValidSudoku(board: [*][*]u8, boardSize: i32, boardColSize: [*]i32) bool {
    _ = boardSize;
    _ = boardColSize;

    var rows: [81]bool = undefined;
    var cols: [81]bool = undefined;
    var boxes: [81]bool = undefined;
    var i: usize = 0;
    while (i < 81) : (i += 1) {
        rows[i] = false;
        cols[i] = false;
        boxes[i] = false;
    }

    var r: usize = 0;
    while (r < 9) : (r += 1) {
        var c: usize = 0;
        while (c < 9) : (c += 1) {
            const ch = board[r][c];
            if (ch == '.') continue;
            const d: usize = @intCast(ch - '1');
            const bi: usize = (r / 3) * 3 + c / 3;
            if (rows[r * 9 + d]) return false;
            rows[r * 9 + d] = true;
            if (cols[c * 9 + d]) return false;
            cols[c * 9 + d] = true;
            if (boxes[bi * 9 + d]) return false;
            boxes[bi * 9 + d] = true;
        }
    }
    return true;
}

test "isValidSudoku valid example" {
    var board = [_][*]u8{
        @constCast("53..7...."),
        @constCast("6..195..."),
        @constCast(".98....6."),
        @constCast("8...6...3"),
        @constCast("4..8.3..1"),
        @constCast("7...2...6"),
        @constCast(".6....28."),
        @constCast("...419..5"),
        @constCast("....8..79"),
    };
    var cols = [_]i32{ 9, 9, 9, 9, 9, 9, 9, 9, 9 };
    try std.testing.expect(isValidSudoku(&board, 9, &cols));
}

test "isValidSudoku invalid examples" {
    // duplicate 8 in the top-left box (r1c1 clashes with r2c2)
    var bad1 = [_][*]u8{
        @constCast("53..7...."),
        @constCast("68.195..."),
        @constCast(".98....6."),
        @constCast("8...6...3"),
        @constCast("4..8.3..1"),
        @constCast("7...2...6"),
        @constCast(".6....28."),
        @constCast("...419..5"),
        @constCast("....8..79"),
    };
    var cols = [_]i32{ 9, 9, 9, 9, 9, 9, 9, 9, 9 };
    try std.testing.expect(!isValidSudoku(&bad1, 9, &cols));

    // duplicate 8 in the first column (rows 0 and 3, different boxes)
    var bad2 = [_][*]u8{
        @constCast("8........"),
        @constCast("........."),
        @constCast("........."),
        @constCast("8........"),
        @constCast("........."),
        @constCast("........."),
        @constCast("........."),
        @constCast("........."),
        @constCast("........."),
    };
    try std.testing.expect(!isValidSudoku(&bad2, 9, &cols));

    // duplicate 2 in the last row
    var bad3 = [_][*]u8{
        @constCast("........."),
        @constCast("........."),
        @constCast("........."),
        @constCast("........."),
        @constCast("........."),
        @constCast("........."),
        @constCast("........."),
        @constCast("........."),
        @constCast("2.......2"),
    };
    try std.testing.expect(!isValidSudoku(&bad3, 9, &cols));
}

test "isValidSudoku empty" {
    var board = [_][*]u8{
        @constCast("........."),
        @constCast("........."),
        @constCast("........."),
        @constCast("........."),
        @constCast("........."),
        @constCast("........."),
        @constCast("........."),
        @constCast("........."),
        @constCast("........."),
    };
    var cols = [_]i32{ 9, 9, 9, 9, 9, 9, 9, 9, 9 };
    try std.testing.expect(isValidSudoku(&board, 9, &cols));
}
