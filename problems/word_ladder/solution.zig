// LeetCode 127. Word Ladder
// C signature:  int ladderLength(char* beginWord, char* endWord,
//                                char** wordList, int wordListSize);
//
// Breadth-first search over single-letter mutations. Instead of comparing every
// pair of words (O(n^2 * L)), each word is hashed to a base-27 integer; for the
// current word all 26*L one-letter variants are hashed and looked up in that
// map, so each word costs 26*L lookups.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn encode(s: []u8) u64 {
    var h: u64 = 0;
    for (s) |c| {
        h = h * 27 + @as(u64, @intCast(c - 'a')) + 1;
    }
    return h;
}

pub fn ladderLength(beginWord: [*]u8, endWord: [*]u8, wordList: [*][*]u8, wordListSize: i32) i32 {
    const n: usize = @intCast(wordListSize);
    const start = std.mem.sliceTo(beginWord, 0);
    const target = std.mem.sliceTo(endWord, 0);
    const lw = start.len;
    if (lw == 0 or target.len != lw) return 0;

    var index = std.AutoHashMap(u64, i32).init(allocator);
    defer index.deinit();

    var i: usize = 0;
    while (i < n) : (i += 1) {
        const w = std.mem.sliceTo(wordList[i], 0);
        if (w.len != lw) continue;
        index.put(encode(w), @intCast(i)) catch unreachable;
    }

    const endKey = encode(target);
    if (!index.contains(endKey)) return 0;

    const visited = allocator.alloc(bool, n) catch unreachable;
    defer allocator.free(visited);
    i = 0;
    while (i < n) : (i += 1) visited[i] = false;

    const buf = allocator.alloc(u8, lw + 1) catch unreachable;
    defer allocator.free(buf);

    var queue: std.ArrayList([*]u8) = .empty;
    defer queue.deinit(allocator);
    queue.append(allocator, beginWord) catch unreachable;

    var depth: i32 = 1;
    var qh: usize = 0;
    var levelEnd: usize = 1;

    while (qh < queue.items.len) {
        if (qh == levelEnd) {
            depth += 1;
            levelEnd = queue.items.len;
        }
        const w = std.mem.sliceTo(queue.items[qh], 0);
        qh += 1;

        var k: usize = 0;
        while (k < lw) : (k += 1) buf[k] = w[k];
        buf[lw] = 0;

        var p: usize = 0;
        while (p < lw) : (p += 1) {
            const orig = buf[p];
            var c: u8 = 'a';
            while (c <= 'z') : (c += 1) {
                if (c == orig) continue;
                buf[p] = c;
                const key = encode(buf[0..lw]);
                if (key == endKey) return depth + 1;
                if (index.get(key)) |idx| {
                    const j: usize = @intCast(idx);
                    if (!visited[j]) {
                        visited[j] = true;
                        queue.append(allocator, wordList[j]) catch unreachable;
                    }
                }
                buf[p] = orig;
            }
        }
    }
    return 0;
}

test "ladderLength examples" {
    var wl = [_][*]u8{
        @constCast("hot"), @constCast("dot"), @constCast("dog"),
        @constCast("lot"), @constCast("log"), @constCast("cog"),
    };
    try std.testing.expectEqual(@as(i32, 5), ladderLength(@constCast("hit"), @constCast("cog"), &wl, 6));

    var wl2 = [_][*]u8{
        @constCast("hot"), @constCast("dot"), @constCast("dog"),
        @constCast("lot"), @constCast("log"),
    };
    try std.testing.expectEqual(@as(i32, 0), ladderLength(@constCast("hit"), @constCast("cog"), &wl2, 5));
}

test "ladderLength edges" {
    // direct mutation, and words of the wrong length are ignored
    var wl = [_][*]u8{ @constCast("cog"), @constCast("toolong") };
    try std.testing.expectEqual(@as(i32, 2), ladderLength(@constCast("dog"), @constCast("cog"), &wl, 2));

    // the direct mutation is two letters away, so the intermediate is required
    var wl2 = [_][*]u8{ @constCast("abe"), @constCast("ade") };
    try std.testing.expectEqual(@as(i32, 3), ladderLength(@constCast("abc"), @constCast("ade"), &wl2, 2));

    // no chain at all
    var wl3 = [_][*]u8{ @constCast("xyz"), @constCast("cog") };
    try std.testing.expectEqual(@as(i32, 0), ladderLength(@constCast("hit"), @constCast("cog"), &wl3, 2));

    // duplicate word in the list
    var wl4 = [_][*]u8{ @constCast("hot"), @constCast("hot"), @constCast("dot"), @constCast("dog") };
    try std.testing.expectEqual(@as(i32, 4), ladderLength(@constCast("hit"), @constCast("dog"), &wl4, 4));
}
