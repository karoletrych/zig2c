// LeetCode 212. Word Search II
// C signature:  char** findWords(char** board, int boardSize, int* boardColSize,
//                               char** words, int wordsSize, int* returnSize);
//
// All the words are put into a trie; the board is then searched once with a DFS
// that walks the trie in lockstep. A trie node holds the index of the word that
// ends there (or -1), so no per-word rescan is needed. Found words are emitted
// by pointer into `words` and the terminal marker is cleared, which also removes
// duplicates.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TrieNode = struct {
    children: [*]?*TrieNode,
    wordIdx: i32,
};

fn newNode() *TrieNode {
    const node = allocator.create(TrieNode) catch unreachable;
    const kids = allocator.alloc(?*TrieNode, 26) catch unreachable;
    var i: usize = 0;
    while (i < 26) : (i += 1) kids[i] = null;
    node.children = kids.ptr;
    node.wordIdx = -1;
    return node;
}

fn dfs(board: [*][*]u8, rows: i32, cols: i32, visited: [*]bool, r: i32, c: i32, node: *TrieNode, words: [*][*]u8, out: [*][*]u8, count: *i32) void {
    if (r < 0 or r >= rows or c < 0 or c >= cols) return;
    const pos: usize = @intCast(r * cols + c);
    if (visited[pos]) return;

    const ch = board[@intCast(r)][@intCast(c)];
    const ci: usize = @intCast(ch - 'a');
    if (node.children[ci] == null) return;
    const child = node.children[ci].?;

    if (child.wordIdx >= 0) {
        out[@intCast(count.*)] = words[@intCast(child.wordIdx)];
        count.* += 1;
        child.wordIdx = -1;
    }

    visited[pos] = true;
    dfs(board, rows, cols, visited, r - 1, c, child, words, out, count);
    dfs(board, rows, cols, visited, r + 1, c, child, words, out, count);
    dfs(board, rows, cols, visited, r, c - 1, child, words, out, count);
    dfs(board, rows, cols, visited, r, c + 1, child, words, out, count);
    visited[pos] = false;
}

pub fn findWords(board: [*][*]u8, boardSize: i32, boardColSize: [*]i32, words: [*][*]u8, wordsSize: i32, returnSize: *i32) ?[*][*]u8 {
    const n: usize = @intCast(wordsSize);
    const root = newNode();

    var i: usize = 0;
    while (i < n) : (i += 1) {
        const s = std.mem.sliceTo(words[i], 0);
        var cur = root;
        for (s) |ch| {
            const idx: usize = @intCast(ch - 'a');
            if (cur.children[idx] == null) cur.children[idx] = newNode();
            cur = cur.children[idx].?;
        }
        cur.wordIdx = @intCast(i);
    }

    const rows: i32 = boardSize;
    const cols: i32 = boardColSize[0];
    const total: usize = @intCast(rows * cols);

    const visited = allocator.alloc(bool, total) catch unreachable;
    defer allocator.free(visited);
    i = 0;
    while (i < total) : (i += 1) visited[i] = false;

    const out = allocator.alloc([*]u8, n + 1) catch unreachable;

    var count: i32 = 0;
    var r: i32 = 0;
    while (r < rows) : (r += 1) {
        var c: i32 = 0;
        while (c < cols) : (c += 1) {
            dfs(board, rows, cols, visited.ptr, r, c, root, words, out.ptr, &count);
        }
    }

    returnSize.* = count;
    return out.ptr;
}

fn hasResult(res: [*][*]u8, count: i32, s: [*]u8) bool {
    var i: i32 = 0;
    while (i < count) : (i += 1) {
        if (std.mem.eql(u8, std.mem.sliceTo(res[@intCast(i)], 0), std.mem.sliceTo(s, 0))) return true;
    }
    return false;
}

test "findWords example" {
    var r0 = [_]u8{ 'o', 'a', 'a', 'n' };
    var r1 = [_]u8{ 'e', 't', 'a', 'e' };
    var r2 = [_]u8{ 'i', 'h', 'k', 'r' };
    var r3 = [_]u8{ 'i', 'f', 'l', 'v' };
    var b = [_][*]u8{ &r0, &r1, &r2, &r3 };
    var cols = [_]i32{ 4, 4, 4, 4 };
    var words = [_][*]u8{ @constCast("oath"), @constCast("pea"), @constCast("eat"), @constCast("rain") };

    var rs: i32 = 0;
    const res = findWords(&b, 4, &cols, &words, 4, &rs).?;
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expect(hasResult(res, rs, @constCast("oath")));
    try std.testing.expect(hasResult(res, rs, @constCast("eat")));
}

test "findWords edges" {
    // nothing matches
    var a0 = [_]u8{ 'a', 'b' };
    var a1 = [_]u8{ 'c', 'd' };
    var b = [_][*]u8{ &a0, &a1 };
    var cols = [_]i32{ 2, 2 };
    var words = [_][*]u8{@constCast("abcb")};
    var rs: i32 = 0;
    _ = findWords(&b, 2, &cols, &words, 1, &rs).?;
    try std.testing.expectEqual(@as(i32, 0), rs);

    // duplicates in the input are reported once; prefix words both count
    var c0 = [_]u8{ 'a', 'a' };
    var b2 = [_][*]u8{&c0};
    var cols2 = [_]i32{2};
    var words2 = [_][*]u8{ @constCast("a"), @constCast("aa"), @constCast("aa"), @constCast("aaa") };
    var rs2: i32 = 0;
    const res2 = findWords(&b2, 1, &cols2, &words2, 4, &rs2).?;
    try std.testing.expectEqual(@as(i32, 2), rs2);
    try std.testing.expect(hasResult(res2, rs2, @constCast("a")));
    try std.testing.expect(hasResult(res2, rs2, @constCast("aa")));
    try std.testing.expect(!hasResult(res2, rs2, @constCast("aaa")));

    // a cell cannot be reused within a word
    var d0 = [_]u8{ 'a', 'b' };
    var b3 = [_][*]u8{&d0};
    var cols3 = [_]i32{2};
    var words3 = [_][*]u8{ @constCast("ab"), @constCast("ba"), @constCast("aba") };
    var rs3: i32 = 0;
    const res3 = findWords(&b3, 1, &cols3, &words3, 3, &rs3).?;
    try std.testing.expectEqual(@as(i32, 2), rs3);
    try std.testing.expect(hasResult(res3, rs3, @constCast("ab")));
    try std.testing.expect(hasResult(res3, rs3, @constCast("ba")));
    try std.testing.expect(!hasResult(res3, rs3, @constCast("aba")));
}
