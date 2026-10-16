// LeetCode 30. Substring with Concatenation of All Words
// C signature:  int* findSubstring(char* s, char** words, int wordsSize,
//                                int* returnSize);
//
// Every word has the same length wl, so a candidate start position tiles the
// string into consecutive wl-sized chunks. For each start we greedily assign
// chunks to unused words (a small used[] table, reset per start).
const std = @import("std");
const allocator = std.heap.c_allocator;

fn chunkEq(word: [*]u8, wl: usize, str: []u8, start: usize) bool {
    const w = std.mem.sliceTo(word, 0);
    if (w.len != wl) return false;
    var t: usize = 0;
    while (t < wl) : (t += 1) {
        if (w[t] != str[start + t]) return false;
    }
    return true;
}

pub fn findSubstring(s: [*]u8, words: [*][*]u8, wordsSize: i32, returnSize: *i32) ?[*]i32 {
    const str = std.mem.sliceTo(s, 0);
    const n = str.len;
    const out = allocator.alloc(i32, n + 1) catch unreachable;
    var count: i32 = 0;

    if (wordsSize <= 0) {
        returnSize.* = 0;
        return out.ptr;
    }
    const wc: usize = @intCast(wordsSize);
    const wl = std.mem.sliceTo(words[0], 0).len;

    // Degenerate empty words: every position matches.
    if (wl == 0) {
        var p: usize = 0;
        while (p <= n) : (p += 1) {
            out[@intCast(count)] = @intCast(p);
            count += 1;
        }
        returnSize.* = count;
        return out.ptr;
    }

    const total = wl * wc;
    const used = allocator.alloc(bool, wc) catch unreachable;

    var i: usize = 0;
    while (i + total <= n) : (i += 1) {
        var t: usize = 0;
        while (t < wc) : (t += 1) used[t] = false;

        var ok = true;
        var j: usize = 0;
        while (j < wc) : (j += 1) {
            const start = i + j * wl;
            var found = false;
            var w: usize = 0;
            while (w < wc) : (w += 1) {
                if (!used[w] and chunkEq(words[w], wl, str, start)) {
                    used[w] = true;
                    found = true;
                    break;
                }
            }
            if (!found) {
                ok = false;
                break;
            }
        }
        if (ok) {
            out[@intCast(count)] = @intCast(i);
            count += 1;
        }
    }

    returnSize.* = count;
    return out.ptr;
}

test "findSubstring examples" {
    var w1 = [_][*]u8{ @constCast("foo"), @constCast("bar") };
    var rs: i32 = 0;
    const r = findSubstring(@constCast("barfoothefoobarman"), &w1, 2, &rs).?;
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, 0), r[0]);
    try std.testing.expectEqual(@as(i32, 9), r[1]);

    var w2 = [_][*]u8{ @constCast("word"), @constCast("good"), @constCast("best"), @constCast("word") };
    var rs2: i32 = 0;
    const r2 = findSubstring(@constCast("wordgoodgoodgoodbestword"), &w2, 4, &rs2).?;
    _ = r2;
    try std.testing.expectEqual(@as(i32, 0), rs2);

    var w3 = [_][*]u8{ @constCast("bar"), @constCast("foo"), @constCast("the") };
    var rs3: i32 = 0;
    const r3 = findSubstring(@constCast("barfoofoobarthefoobarman"), &w3, 3, &rs3).?;
    try std.testing.expectEqual(@as(i32, 3), rs3);
    try std.testing.expectEqual(@as(i32, 6), r3[0]);
    try std.testing.expectEqual(@as(i32, 9), r3[1]);
    try std.testing.expectEqual(@as(i32, 12), r3[2]);
}

test "findSubstring edges" {
    // overlapping duplicates need an exact multiset match
    var w = [_][*]u8{ @constCast("ab"), @constCast("ab"), @constCast("ba") };
    var rs: i32 = 0;
    const r = findSubstring(@constCast("abababba"), &w, 3, &rs).?;
    try std.testing.expectEqual(@as(i32, 1), rs);
    try std.testing.expectEqual(@as(i32, 2), r[0]);

    // single word, multiple occurrences
    var w2 = [_][*]u8{@constCast("a")};
    var rs2: i32 = 0;
    const r2 = findSubstring(@constCast("aaaa"), &w2, 1, &rs2).?;
    try std.testing.expectEqual(@as(i32, 4), rs2);
    try std.testing.expectEqual(@as(i32, 0), r2[0]);
    try std.testing.expectEqual(@as(i32, 1), r2[1]);
    try std.testing.expectEqual(@as(i32, 2), r2[2]);
    try std.testing.expectEqual(@as(i32, 3), r2[3]);

    // no match
    var w3 = [_][*]u8{ @constCast("xy"), @constCast("zz") };
    var rs3: i32 = 0;
    _ = findSubstring(@constCast("abcdef"), &w3, 2, &rs3);
    try std.testing.expectEqual(@as(i32, 0), rs3);
}
