// LeetCode 79. Word Search
// C signature:  bool exist(char** board, int boardSize, int* boardColSize,
//                         char* word);
//
// Depth-first search over the grid, one `visited` flag per cell. Each step must
// take the next letter of `word`; a run of `word.len` letters wins.
const std = @import("std");
const allocator = std.heap.c_allocator;

const DR: [4]i32 = .{ -1, 1, 0, 0 };
const DC: [4]i32 = .{ 0, 0, -1, 1 };

fn dfs(board: [*][*]u8, rows: i32, cols: i32, visited: [*]bool, r: i32, c: i32, w: []u8, k: usize) bool {
    if (k == w.len) return true;
    if (r < 0 or r >= rows or c < 0 or c >= cols) return false;
    const idx: usize = @intCast(r * cols + c);
    if (visited[idx]) return false;
    if (board[@intCast(r)][@intCast(c)] != w[k]) return false;

    visited[idx] = true;
    var d: usize = 0;
    while (d < 4) : (d += 1) {
        if (dfs(board, rows, cols, visited, r + DR[d], c + DC[d], w, k + 1)) {
            visited[idx] = false;
            return true;
        }
    }
    visited[idx] = false;
    return false;
}

pub fn exist(board: [*][*]u8, boardSize: i32, boardColSize: [*]i32, word: [*]u8) bool {
    const w = std.mem.sliceTo(word, 0);
    const rows: i32 = boardSize;
    if (rows == 0) return false;
    const cols: i32 = boardColSize[0];
    if (w.len == 0) return false;

    const visited = allocator.alloc(bool, @intCast(rows * cols)) catch unreachable;
    defer allocator.free(visited);
    var i: usize = 0;
    while (i < visited.len) : (i += 1) visited[i] = false;

    var r: i32 = 0;
    while (r < rows) : (r += 1) {
        var c: i32 = 0;
        while (c < cols) : (c += 1) {
            if (dfs(board, rows, cols, visited.ptr, r, c, w, 0)) return true;
        }
    }
    return false;
}

test "exist examples" {
    var r0 = [_]u8{ 'A', 'B', 'C', 'E' };
    var r1 = [_]u8{ 'S', 'F', 'C', 'S' };
    var r2 = [_]u8{ 'A', 'D', 'E', 'E' };
    var b = [_][*]u8{ &r0, &r1, &r2 };
    var cols = [_]i32{ 4, 4, 4 };

    try std.testing.expect(exist(&b, 3, &cols, @constCast("ABCCED")));
    try std.testing.expect(exist(&b, 3, &cols, @constCast("SEE")));
    try std.testing.expect(!exist(&b, 3, &cols, @constCast("ABCB")));
}

test "exist edges" {
    var r0 = [_]u8{'a'};
    var b = [_][*]u8{&r0};
    var cols = [_]i32{1};
    try std.testing.expect(exist(&b, 1, &cols, @constCast("a")));
    try std.testing.expect(!exist(&b, 1, &cols, @constCast("b")));
    try std.testing.expect(!exist(&b, 1, &cols, @constCast("aa")));

    // a cell may not be reused within one word
    var s0 = [_]u8{ 'a', 'b' };
    var s1 = [_]u8{ 'c', 'd' };
    var b2 = [_][*]u8{ &s0, &s1 };
    var cols2 = [_]i32{ 2, 2 };
    try std.testing.expect(exist(&b2, 2, &cols2, @constCast("ab")));
    try std.testing.expect(exist(&b2, 2, &cols2, @constCast("abd")));
    try std.testing.expect(exist(&b2, 2, &cols2, @constCast("abdc")));
    try std.testing.expect(!exist(&b2, 2, &cols2, @constCast("aba")));

    // backtracking must undo the visited marks
    var t0 = [_]u8{ 'a', 'a' };
    var b3 = [_][*]u8{&t0};
    var cols3 = [_]i32{2};
    try std.testing.expect(!exist(&b3, 1, &cols3, @constCast("aaa")));
    try std.testing.expect(exist(&b3, 1, &cols3, @constCast("aa")));

    // word longer than the board is impossible
    var p0 = [_]u8{ 'a', 'a' };
    var b4 = [_][*]u8{&p0};
    var cols4 = [_]i32{2};
    try std.testing.expect(!exist(&b4, 1, &cols4, @constCast("aaaa")));
}
