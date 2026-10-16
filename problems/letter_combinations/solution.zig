// LeetCode 17. Letter Combinations of a Phone Number
// C signature:  char** letterCombinations(char* digits, int* returnSize);
//
// The alphabet is stored as one flat table plus per-digit (start, length).
// A DFS fills a shared buffer and materialises one heap string per combination.
const std = @import("std");
const allocator = std.heap.c_allocator;

const ALPHA: [26]u8 = .{
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
};
// index by digit: 2 -> abc, 3 -> def, ... 7 -> pqrs, 8 -> tuv, 9 -> wxyz
const KSTART: [10]i32 = .{ 0, 0, 0, 3, 6, 9, 12, 15, 19, 22 };
const KLEN: [10]i32 = .{ 0, 0, 3, 3, 3, 3, 3, 4, 3, 4 };

fn countCombos(digits: []u8) usize {
    var total: usize = 1;
    var i: usize = 0;
    while (i < digits.len) : (i += 1) {
        const di: i32 = @intCast(digits[i] - '0');
        total *= @intCast(KLEN[@intCast(di)]);
    }
    return total;
}

fn buildCombos(digits: []u8, pos: usize, buf: [*]u8, out: [*][*]u8, idx: *usize) void {
    if (pos == digits.len) {
        buf[pos] = 0;
        const s = allocator.alloc(u8, pos + 1) catch unreachable;
        var k: usize = 0;
        while (k <= pos) : (k += 1) s[k] = buf[k];
        out[idx.*] = s.ptr;
        idx.* += 1;
        return;
    }
    const di: i32 = @intCast(digits[pos] - '0');
    const start = KSTART[@intCast(di)];
    const len = KLEN[@intCast(di)];
    var j: i32 = 0;
    while (j < len) : (j += 1) {
        buf[pos] = ALPHA[@intCast(start + j)];
        buildCombos(digits, pos + 1, buf, out, idx);
    }
}

pub fn letterCombinations(digits: [*]u8, returnSize: *i32) ?[*][*]u8 {
    const s = std.mem.sliceTo(digits, 0);
    if (s.len == 0) {
        returnSize.* = 0;
        return null;
    }

    const total = countCombos(s);
    const out = allocator.alloc([*]u8, total) catch unreachable;
    const buf = allocator.alloc(u8, 8) catch unreachable;

    var idx: usize = 0;
    buildCombos(s, 0, buf.ptr, out.ptr, &idx);

    returnSize.* = @intCast(idx);
    return out.ptr;
}

test "letterCombinations examples" {
    var rs: i32 = 0;
    const r = letterCombinations(@constCast("23"), &rs).?;
    try std.testing.expectEqual(@as(i32, 9), rs);
    try std.testing.expectEqualStrings("ad", std.mem.sliceTo(r[0], 0));
    try std.testing.expectEqualStrings("ae", std.mem.sliceTo(r[1], 0));
    try std.testing.expectEqualStrings("af", std.mem.sliceTo(r[2], 0));
    try std.testing.expectEqualStrings("bd", std.mem.sliceTo(r[3], 0));
    try std.testing.expectEqualStrings("be", std.mem.sliceTo(r[4], 0));
    try std.testing.expectEqualStrings("bf", std.mem.sliceTo(r[5], 0));
    try std.testing.expectEqualStrings("cd", std.mem.sliceTo(r[6], 0));
    try std.testing.expectEqualStrings("ce", std.mem.sliceTo(r[7], 0));
    try std.testing.expectEqualStrings("cf", std.mem.sliceTo(r[8], 0));
}

test "letterCombinations edges" {
    var rs: i32 = 0;
    const r = letterCombinations(@constCast("9"), &rs).?;
    try std.testing.expectEqual(@as(i32, 4), rs);
    try std.testing.expectEqualStrings("w", std.mem.sliceTo(r[0], 0));
    try std.testing.expectEqualStrings("x", std.mem.sliceTo(r[1], 0));
    try std.testing.expectEqualStrings("y", std.mem.sliceTo(r[2], 0));
    try std.testing.expectEqualStrings("z", std.mem.sliceTo(r[3], 0));

    var rs2: i32 = 0;
    const r2 = letterCombinations(@constCast("7"), &rs2).?;
    try std.testing.expectEqual(@as(i32, 4), rs2);
    try std.testing.expectEqualStrings("p", std.mem.sliceTo(r2[0], 0));
    try std.testing.expectEqualStrings("s", std.mem.sliceTo(r2[3], 0));

    var empty = [_]u8{0};
    var rs3: i32 = 1;
    const r3 = letterCombinations(&empty, &rs3);
    try std.testing.expectEqual(@as(i32, 0), rs3);
    try std.testing.expect(r3 == null);

    // 4 digits -> 3 * 3 * 3 * 3 = 81 combinations
    var rs4: i32 = 0;
    _ = letterCombinations(@constCast("2345"), &rs4).?;
    try std.testing.expectEqual(@as(i32, 81), rs4);
}
