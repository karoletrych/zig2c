// LeetCode 208. Implement Trie (Prefix Tree)
// C signature:
//   Trie* trieCreate();
//   void trieInsert(Trie* obj, char* word);
//   bool trieSearch(Trie* obj, char* word);
//   bool trieStartsWith(Trie* obj, char* prefix);
//
// `Trie` is the handle LeetCode holds; `TrieNode` is one vertex, with a fixed
// 26-slot array of optional child pointers (one per lowercase letter) and an
// end-of-word flag.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TrieNode = struct {
    children: [26]?*TrieNode,
    is_end: bool,
};

pub const Trie = struct {
    root: ?*TrieNode,
};

fn newNode() *TrieNode {
    const n = allocator.create(TrieNode) catch unreachable;
    n.is_end = false;
    var i: usize = 0;
    while (i < 26) : (i += 1) n.children[i] = null;
    return n;
}

fn walk(obj: *Trie, s: []u8) ?*TrieNode {
    var cur = obj.root.?;
    for (s) |ch| {
        const idx: usize = @intCast(ch - 'a');
        if (cur.children[idx] == null) return null;
        cur = cur.children[idx].?;
    }
    return cur;
}

pub fn trieCreate() ?*Trie {
    const t = allocator.create(Trie) catch unreachable;
    t.root = newNode();
    return t;
}

pub fn trieInsert(obj: *Trie, word: [*]u8) void {
    const s = std.mem.sliceTo(word, 0);
    var cur = obj.root.?;
    for (s) |ch| {
        const idx: usize = @intCast(ch - 'a');
        if (cur.children[idx] == null) {
            cur.children[idx] = newNode();
        }
        cur = cur.children[idx].?;
    }
    cur.is_end = true;
}

pub fn trieSearch(obj: *Trie, word: [*]u8) bool {
    const node = walk(obj, std.mem.sliceTo(word, 0));
    if (node == null) return false;
    return node.?.is_end;
}

pub fn trieStartsWith(obj: *Trie, prefix: [*]u8) bool {
    return walk(obj, std.mem.sliceTo(prefix, 0)) != null;
}

fn freeNode(n: *TrieNode) void {
    var i: usize = 0;
    while (i < 26) : (i += 1) {
        if (n.children[i]) |c| freeNode(c);
    }
    allocator.destroy(n);
}

pub fn trieFree(obj: *Trie) void {
    freeNode(obj.root.?);
    allocator.destroy(obj);
}

test "trie example" {
    const t = trieCreate().?;
    trieInsert(t, @constCast("apple"));
    try std.testing.expect(trieSearch(t, @constCast("apple")));
    try std.testing.expect(!trieSearch(t, @constCast("app")));
    try std.testing.expect(trieStartsWith(t, @constCast("app")));
    trieInsert(t, @constCast("app"));
    try std.testing.expect(trieSearch(t, @constCast("app")));
    trieFree(t);
}

test "trie edges" {
    const t = trieCreate().?;
    // Nothing inserted yet.
    try std.testing.expect(!trieSearch(t, @constCast("a")));
    try std.testing.expect(!trieStartsWith(t, @constCast("a")));
    // A prefix of nothing is always present (empty string).
    try std.testing.expect(trieStartsWith(t, @constCast("")));
    // But the empty string is not an inserted word.
    try std.testing.expect(!trieSearch(t, @constCast("")));

    trieInsert(t, @constCast("a"));
    trieInsert(t, @constCast("ab"));
    trieInsert(t, @constCast("zebra"));
    try std.testing.expect(trieSearch(t, @constCast("a")));
    try std.testing.expect(trieSearch(t, @constCast("ab")));
    try std.testing.expect(!trieSearch(t, @constCast("abc")));
    try std.testing.expect(trieStartsWith(t, @constCast("abc")) == false);
    try std.testing.expect(trieStartsWith(t, @constCast("ab")));
    try std.testing.expect(trieSearch(t, @constCast("zebr")) == false);
    try std.testing.expect(trieStartsWith(t, @constCast("zebr")));
    try std.testing.expect(trieSearch(t, @constCast("zebra")));

    // Re-inserting is idempotent.
    trieInsert(t, @constCast("ab"));
    try std.testing.expect(trieSearch(t, @constCast("ab")));
    trieFree(t);
}
