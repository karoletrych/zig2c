// LeetCode 1268. Search Suggestions System
// C signature:
//   char*** suggestedProducts(char** products, int productsSize, char* searchWord,
//                             int* returnSize, int** returnColumnSizes);
//
// For each prefix of searchWord, gather the (at most 3) lexicographically
// smallest matching products. Rather than sorting the whole list up front, each
// prefix scans the products once while keeping a small sorted insertion buffer
// of the three best candidates. Matches are returned as fresh NUL-terminated
// copies because the judge owns (and frees) every returned string.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn startsWithWord(word: [*]u8, prefix: [*]u8, plen: usize) bool {
    const w = std.mem.sliceTo(word, 0);
    if (w.len < plen) return false;
    var i: usize = 0;
    while (i < plen) : (i += 1) {
        if (w[i] != prefix[i]) return false;
    }
    return true;
}

fn strLess(a: [*]u8, b: [*]u8) bool {
    const sa = std.mem.sliceTo(a, 0);
    const sb = std.mem.sliceTo(b, 0);
    const n = @min(sa.len, sb.len);
    var i: usize = 0;
    while (i < n) : (i += 1) {
        if (sa[i] < sb[i]) return true;
        if (sa[i] > sb[i]) return false;
    }
    return sa.len < sb.len;
}

fn dupeString(src: [*]u8) [*]u8 {
    const s = std.mem.sliceTo(src, 0);
    const buf = allocator.alloc(u8, s.len + 1) catch unreachable;
    var i: usize = 0;
    while (i < s.len) : (i += 1) buf[i] = s[i];
    buf[s.len] = 0;
    return buf.ptr;
}

pub fn suggestedProducts(products: [*][*]u8, productsSize: i32, searchWord: [*]u8, returnSize: *i32, returnColumnSizes: [*][*]i32) ?[*][*][*]u8 {
    const sw = std.mem.sliceTo(searchWord, 0);
    const total: usize = sw.len;

    const outer = allocator.alloc([*][*]u8, total) catch unreachable;
    const cols = allocator.alloc(i32, total) catch unreachable;
    returnColumnSizes[0] = cols.ptr;

    var li: usize = 0;
    while (li < total) : (li += 1) {
        const plen = li + 1;

        // The up-to-three smallest matching product indices, kept sorted.
        var chosen: [3]i32 = undefined;
        var nchosen: usize = 0;

        var pi: i32 = 0;
        while (pi < productsSize) : (pi += 1) {
            if (!startsWithWord(products[@intCast(pi)], searchWord, plen)) continue;

            // Find where this product belongs among the current best three.
            var q: usize = 0;
            while (q < nchosen) : (q += 1) {
                if (strLess(products[@intCast(pi)], products[@intCast(chosen[q])])) break;
            }
            const pos = q;

            if (nchosen < 3) {
                var r: usize = nchosen;
                while (r > pos) : (r -= 1) chosen[r] = chosen[r - 1];
                chosen[pos] = pi;
                nchosen += 1;
            } else if (pos < 3) {
                var r: usize = 2;
                while (r > pos) : (r -= 1) chosen[r] = chosen[r - 1];
                chosen[pos] = pi;
            }
        }

        const row = allocator.alloc([*]u8, nchosen) catch unreachable;
        var j: usize = 0;
        while (j < nchosen) : (j += 1) {
            row[j] = dupeString(products[@intCast(chosen[j])]);
        }
        outer[li] = row.ptr;
        cols[li] = @intCast(nchosen);
    }

    returnSize.* = @intCast(total);
    return outer.ptr;
}

test "suggestedProducts example 1" {
    var products = [_][*]u8{
        @constCast("mobile"),
        @constCast("mouse"),
        @constCast("moneypot"),
        @constCast("monitor"),
        @constCast("mousepad"),
    };
    var cb: [5][*]i32 = undefined;
    var rs: i32 = 0;
    const r = suggestedProducts(&products, 5, @constCast("mouse"), &rs, &cb).?;

    try std.testing.expectEqual(@as(i32, 5), rs);
    try std.testing.expectEqual(@as(i32, 3), cb[0][0]);
    try std.testing.expectEqualStrings("mobile", std.mem.sliceTo(r[0][0], 0));
    try std.testing.expectEqualStrings("moneypot", std.mem.sliceTo(r[0][1], 0));
    try std.testing.expectEqualStrings("monitor", std.mem.sliceTo(r[0][2], 0));

    try std.testing.expectEqual(@as(i32, 3), cb[0][1]);
    try std.testing.expectEqualStrings("mobile", std.mem.sliceTo(r[1][0], 0));
    try std.testing.expectEqualStrings("moneypot", std.mem.sliceTo(r[1][1], 0));
    try std.testing.expectEqualStrings("monitor", std.mem.sliceTo(r[1][2], 0));

    try std.testing.expectEqual(@as(i32, 2), cb[0][2]);
    try std.testing.expectEqualStrings("mouse", std.mem.sliceTo(r[2][0], 0));
    try std.testing.expectEqualStrings("mousepad", std.mem.sliceTo(r[2][1], 0));

    try std.testing.expectEqual(@as(i32, 2), cb[0][3]);
    try std.testing.expectEqualStrings("mouse", std.mem.sliceTo(r[3][0], 0));
    try std.testing.expectEqual(@as(i32, 2), cb[0][4]);
    try std.testing.expectEqualStrings("mousepad", std.mem.sliceTo(r[4][1], 0));
}

test "suggestedProducts example 2" {
    var products = [_][*]u8{@constCast("havana")};
    var cb: [6][*]i32 = undefined;
    var rs: i32 = 0;
    const r = suggestedProducts(&products, 1, @constCast("havana"), &rs, &cb).?;

    try std.testing.expectEqual(@as(i32, 6), rs);
    var i: usize = 0;
    while (i < 6) : (i += 1) {
        try std.testing.expectEqual(@as(i32, 1), cb[0][i]);
        try std.testing.expectEqualStrings("havana", std.mem.sliceTo(r[i][0], 0));
    }
}

test "suggestedProducts example 3" {
    var products = [_][*]u8{
        @constCast("bags"),
        @constCast("baggage"),
        @constCast("banner"),
        @constCast("box"),
        @constCast("cloths"),
    };
    var cb: [4][*]i32 = undefined;
    var rs: i32 = 0;
    const r = suggestedProducts(&products, 5, @constCast("bags"), &rs, &cb).?;

    try std.testing.expectEqual(@as(i32, 4), rs);
    try std.testing.expectEqual(@as(i32, 3), cb[0][0]);
    try std.testing.expectEqualStrings("baggage", std.mem.sliceTo(r[0][0], 0));
    try std.testing.expectEqualStrings("bags", std.mem.sliceTo(r[0][1], 0));
    try std.testing.expectEqualStrings("banner", std.mem.sliceTo(r[0][2], 0));

    try std.testing.expectEqual(@as(i32, 3), cb[0][1]);
    try std.testing.expectEqualStrings("baggage", std.mem.sliceTo(r[1][0], 0));
    try std.testing.expectEqualStrings("bags", std.mem.sliceTo(r[1][1], 0));
    try std.testing.expectEqualStrings("banner", std.mem.sliceTo(r[1][2], 0));

    try std.testing.expectEqual(@as(i32, 2), cb[0][2]);
    try std.testing.expectEqualStrings("baggage", std.mem.sliceTo(r[2][0], 0));
    try std.testing.expectEqualStrings("bags", std.mem.sliceTo(r[2][1], 0));

    try std.testing.expectEqual(@as(i32, 1), cb[0][3]);
    try std.testing.expectEqualStrings("bags", std.mem.sliceTo(r[3][0], 0));
}

test "suggestedProducts duplicates" {
    var products = [_][*]u8{
        @constCast("abc"),
        @constCast("abc"),
        @constCast("abd"),
        @constCast("abe"),
    };
    var cb: [2][*]i32 = undefined;
    var rs: i32 = 0;
    const r = suggestedProducts(&products, 4, @constCast("ab"), &rs, &cb).?;

    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, 3), cb[0][0]);
    try std.testing.expectEqualStrings("abc", std.mem.sliceTo(r[0][0], 0));
    try std.testing.expectEqualStrings("abc", std.mem.sliceTo(r[0][1], 0));
    try std.testing.expectEqualStrings("abd", std.mem.sliceTo(r[0][2], 0));

    try std.testing.expectEqual(@as(i32, 3), cb[0][1]);
    try std.testing.expectEqualStrings("abc", std.mem.sliceTo(r[1][0], 0));
    try std.testing.expectEqualStrings("abc", std.mem.sliceTo(r[1][1], 0));
    try std.testing.expectEqualStrings("abd", std.mem.sliceTo(r[1][2], 0));
}

test "suggestedProducts no matches" {
    var products = [_][*]u8{@constCast("xyz")};
    var cb: [1][*]i32 = undefined;
    var rs: i32 = 0;
    const r = suggestedProducts(&products, 1, @constCast("a"), &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 1), rs);
    try std.testing.expectEqual(@as(i32, 0), cb[0][0]);
    // No strings were produced for this prefix, so only the count is checked.
    _ = r;
}
