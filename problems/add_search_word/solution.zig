// LeetCode 211. Design Add and Search Words Data Structure
// C signature:
//   WordDictionary* wordDictionaryCreate();
//   void wordDictionaryAddWord(WordDictionary* obj, char* word);
//   bool wordDictionarySearch(WordDictionary* obj, char* word);
//
// A trie over lowercase letters. The 26 children live in a heap-allocated
// `[*]?*TrieNode` array (a fixed array field is avoided on purpose). Searching
// with '.' branches into every non-null child at that depth.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TrieNode = struct {
    children: [*]?*TrieNode,
    isEnd: bool,
};

pub const WordDictionary = struct {
    root: *TrieNode,
};

fn newNode() *TrieNode {
    const node = allocator.create(TrieNode) catch unreachable;
    const kids = allocator.alloc(?*TrieNode, 26) catch unreachable;
    var i: usize = 0;
    while (i < 26) : (i += 1) kids[i] = null;
    node.children = kids.ptr;
    node.isEnd = false;
    return node;
}

pub fn wordDictionaryCreate() ?*WordDictionary {
    const d = allocator.create(WordDictionary) catch unreachable;
    d.root = newNode();
    return d;
}

pub fn wordDictionaryAddWord(obj: *WordDictionary, word: [*]u8) void {
    const s = std.mem.sliceTo(word, 0);
    var cur = obj.root;
    for (s) |ch| {
        const idx: usize = @intCast(ch - 'a');
        if (cur.children[idx] == null) {
            cur.children[idx] = newNode();
        }
        cur = cur.children[idx].?;
    }
    cur.isEnd = true;
}

fn searchFrom(node: *TrieNode, s: []u8, i: usize) bool {
    if (i == s.len) return node.isEnd;
    const ch = s[i];
    if (ch == '.') {
        var k: usize = 0;
        while (k < 26) : (k += 1) {
            if (node.children[k]) |child| {
                if (searchFrom(child, s, i + 1)) return true;
            }
        }
        return false;
    }
    const idx: usize = @intCast(ch - 'a');
    if (node.children[idx] == null) return false;
    return searchFrom(node.children[idx].?, s, i + 1);
}

pub fn wordDictionarySearch(obj: *WordDictionary, word: [*]u8) bool {
    return searchFrom(obj.root, std.mem.sliceTo(word, 0), 0);
}

test "wordDictionary example" {
    const d = wordDictionaryCreate().?;
    wordDictionaryAddWord(d, @constCast("bad"));
    wordDictionaryAddWord(d, @constCast("dad"));
    wordDictionaryAddWord(d, @constCast("mad"));

    try std.testing.expect(!wordDictionarySearch(d, @constCast("pad")));
    try std.testing.expect(wordDictionarySearch(d, @constCast("bad")));
    try std.testing.expect(wordDictionarySearch(d, @constCast(".ad")));
    try std.testing.expect(wordDictionarySearch(d, @constCast("b..")));
}

test "wordDictionary edges" {
    const d = wordDictionaryCreate().?;

    // nothing added yet
    try std.testing.expect(!wordDictionarySearch(d, @constCast("a")));
    try std.testing.expect(!wordDictionarySearch(d, @constCast(".")));

    wordDictionaryAddWord(d, @constCast("a"));
    try std.testing.expect(wordDictionarySearch(d, @constCast("a")));
    try std.testing.expect(wordDictionarySearch(d, @constCast(".")));
    try std.testing.expect(!wordDictionarySearch(d, @constCast("aa")));
    try std.testing.expect(!wordDictionarySearch(d, @constCast("b")));

    // prefixes are not words, but wildcards may still span them
    wordDictionaryAddWord(d, @constCast("apple"));
    try std.testing.expect(!wordDictionarySearch(d, @constCast("app")));
    try std.testing.expect(wordDictionarySearch(d, @constCast("app..")));
    try std.testing.expect(wordDictionarySearch(d, @constCast("ap.le")));
    try std.testing.expect(wordDictionarySearch(d, @constCast(".....")));
    try std.testing.expect(!wordDictionarySearch(d, @constCast("....")));
    try std.testing.expect(!wordDictionarySearch(d, @constCast("......")));

    // a wildcard that matches a dead end must still backtrack to a live branch
    wordDictionaryAddWord(d, @constCast("az"));
    wordDictionaryAddWord(d, @constCast("bz"));
    try std.testing.expect(wordDictionarySearch(d, @constCast(".z")));
    try std.testing.expect(!wordDictionarySearch(d, @constCast(".y")));
    try std.testing.expect(wordDictionarySearch(d, @constCast("..")));
}
