// LeetCode 22. Generate Parentheses
// C signature:  char** generateParenthesis(int n, int* returnSize);
//
// Catalan(n) is the exact row count, so the output array is allocated once. The
// DFS keeps two counters: it may always open while `open < n`, and may close
// while `close < open`, which enumerates every balanced string exactly once.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn catalanCount(n: i32) usize {
    var r: u64 = 1;
    var i: i32 = 1;
    while (i <= n) : (i += 1) {
        r = r * @as(u64, @intCast(4 * i - 2)) / @as(u64, @intCast(i + 1));
    }
    return @intCast(r);
}

fn gen(n: i32, open: i32, close: i32, buf: [*]u8, depth: i32, out: [*][*]u8, count: *i32) void {
    if (depth == 2 * n) {
        const len: usize = @intCast(2 * n + 1);
        const s = allocator.alloc(u8, len) catch unreachable;
        var i: usize = 0;
        while (i < len - 1) : (i += 1) s[i] = buf[i];
        s[len - 1] = 0;
        out[@intCast(count.*)] = s.ptr;
        count.* += 1;
        return;
    }
    if (open < n) {
        buf[@intCast(depth)] = '(';
        gen(n, open + 1, close, buf, depth + 1, out, count);
    }
    if (close < open) {
        buf[@intCast(depth)] = ')';
        gen(n, open, close + 1, buf, depth + 1, out, count);
    }
}

pub fn generateParenthesis(n: i32, returnSize: *i32) ?[*][*]u8 {
    const total: usize = catalanCount(n);
    const out = allocator.alloc([*]u8, total) catch unreachable;

    var bcap: usize = 1;
    if (2 * n > 0) bcap = @intCast(2 * n);
    const buf = allocator.alloc(u8, bcap) catch unreachable;
    defer allocator.free(buf);

    var count: i32 = 0;
    gen(n, 0, 0, buf.ptr, 0, out.ptr, &count);

    returnSize.* = count;
    return out.ptr;
}

test "generateParenthesis examples" {
    var rs: i32 = 0;
    const r = generateParenthesis(1, &rs).?;
    try std.testing.expectEqual(@as(i32, 1), rs);
    try std.testing.expectEqualStrings("()", std.mem.sliceTo(r[0], 0));

    var rs2: i32 = 0;
    const r2 = generateParenthesis(2, &rs2).?;
    try std.testing.expectEqual(@as(i32, 2), rs2);
    try std.testing.expectEqualStrings("(())", std.mem.sliceTo(r2[0], 0));
    try std.testing.expectEqualStrings("()()", std.mem.sliceTo(r2[1], 0));

    var rs3: i32 = 0;
    const r3 = generateParenthesis(3, &rs3).?;
    try std.testing.expectEqual(@as(i32, 5), rs3);
    try std.testing.expectEqualStrings("((()))", std.mem.sliceTo(r3[0], 0));
    try std.testing.expectEqualStrings("(()())", std.mem.sliceTo(r3[1], 0));
    try std.testing.expectEqualStrings("(())()", std.mem.sliceTo(r3[2], 0));
    try std.testing.expectEqualStrings("()(())", std.mem.sliceTo(r3[3], 0));
    try std.testing.expectEqualStrings("()()()", std.mem.sliceTo(r3[4], 0));
}

test "generateParenthesis edges" {
    // Catalan numbers grow fast: 8 -> 1430
    var rs: i32 = 0;
    const r = generateParenthesis(8, &rs).?;
    try std.testing.expectEqual(@as(i32, 1430), rs);
    try std.testing.expectEqualStrings("(((((((())))))))", std.mem.sliceTo(r[0], 0));
    try std.testing.expectEqual(@as(usize, 16), std.mem.sliceTo(r[0], 0).len);
    // the last string is fully interleaved
    try std.testing.expectEqualStrings("()()()()()()()()", std.mem.sliceTo(r[@intCast(rs - 1)], 0));

    var rs2: i32 = 0;
    const r2 = generateParenthesis(4, &rs2).?;
    try std.testing.expectEqual(@as(i32, 14), rs2);
    try std.testing.expectEqual(@as(usize, 8), std.mem.sliceTo(r2[0], 0).len);
    try std.testing.expectEqualStrings("(((())))", std.mem.sliceTo(r2[0], 0));
}
