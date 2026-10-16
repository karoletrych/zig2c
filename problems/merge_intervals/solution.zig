// LeetCode 56. Merge Intervals
// C signature:
//   int** merge(int** intervals, int intervalsSize, int* intervalsColSize,
//               int* returnSize, int** returnColumnSizes);
//
// Sort intervals by (start, end) by packing each one into a biased i64 key, then
// sweep once: while the next interval starts at or before the running end it is
// absorbed (the end is extended if needed), otherwise the run is emitted.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn lessKey(_: void, a: i64, b: i64) bool {
    return a < b;
}

fn bias(x: i32) i64 {
    return @as(i64, x) + 0x80000000;
}

// Sort key: high 32 bits are the (signed) start, low 32 the biased end, so a
// plain i64 comparison orders by start and then by end.
fn keyOf(st: i32, en: i32) i64 {
    return (@as(i64, st) << 32) | (bias(en) & 0xffffffff);
}

fn emit(outer: [*][*]i32, cols: [*]i32, idx: usize, a: i32, b: i32) void {
    const row = allocator.alloc(i32, 2) catch unreachable;
    row[0] = a;
    row[1] = b;
    outer[idx] = row.ptr;
    cols[idx] = 2;
}

pub fn merge(intervals: [*][*]i32, intervalsSize: i32, intervalsColSize: [*]i32, returnSize: *i32, returnColumnSizes: [*][*]i32) ?[*][*]i32 {
    _ = intervalsColSize;

    const n: usize = @intCast(intervalsSize);
    const outer = allocator.alloc([*]i32, n + 1) catch unreachable;
    const cols = allocator.alloc(i32, n + 1) catch unreachable;
    returnColumnSizes[0] = cols.ptr;

    if (n == 0) {
        returnSize.* = 0;
        return outer.ptr;
    }

    const keys = allocator.alloc(i64, n) catch unreachable;
    defer allocator.free(keys);
    var i: usize = 0;
    while (i < n) : (i += 1) {
        keys[i] = keyOf(intervals[i][0], intervals[i][1]);
    }
    std.mem.sort(i64, keys, {}, lessKey);

    var count: usize = 0;
    var cur_start: i64 = keys[0] >> 32;
    var cur_end: i64 = (keys[0] & 0xffffffff) - 0x80000000;
    i = 1;
    while (i < n) : (i += 1) {
        const st = keys[i] >> 32;
        const en = (keys[i] & 0xffffffff) - 0x80000000;
        if (st <= cur_end) {
            if (en > cur_end) cur_end = en;
        } else {
            emit(outer.ptr, cols.ptr, count, @as(i32, @intCast(cur_start)), @as(i32, @intCast(cur_end)));
            count += 1;
            cur_start = st;
            cur_end = en;
        }
    }
    emit(outer.ptr, cols.ptr, count, @as(i32, @intCast(cur_start)), @as(i32, @intCast(cur_end)));
    count += 1;

    returnSize.* = @intCast(count);
    return outer.ptr;
}

test "merge examples" {
    var a0 = [_]i32{ 1, 3 };
    var a1 = [_]i32{ 2, 6 };
    var a2 = [_]i32{ 8, 10 };
    var a3 = [_]i32{ 15, 18 };
    var iv = [_][*]i32{ &a0, &a1, &a2, &a3 };
    var cols = [_]i32{ 2, 2, 2, 2 };
    var rs: i32 = 0;
    var cb: [1][*]i32 = undefined;
    const r = merge(&iv, 4, &cols, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqual(@as(i32, 2), cb[0][0]);
    try std.testing.expectEqual(@as(i32, 1), r[0][0]);
    try std.testing.expectEqual(@as(i32, 6), r[0][1]);
    try std.testing.expectEqual(@as(i32, 8), r[1][0]);
    try std.testing.expectEqual(@as(i32, 10), r[1][1]);
    try std.testing.expectEqual(@as(i32, 15), r[2][0]);
    try std.testing.expectEqual(@as(i32, 18), r[2][1]);
}

test "merge edges" {
    var b0 = [_]i32{ 1, 4 };
    var b1 = [_]i32{ 4, 5 };
    var iv = [_][*]i32{ &b0, &b1 };
    var cols = [_]i32{ 2, 2 };
    var rs: i32 = 0;
    var cb: [1][*]i32 = undefined;
    const r = merge(&iv, 2, &cols, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 1), rs);
    try std.testing.expectEqual(@as(i32, 1), r[0][0]);
    try std.testing.expectEqual(@as(i32, 5), r[0][1]);

    // Sorting handles a later interval that swallows an earlier one.
    var c0 = [_]i32{ 1, 4 };
    var c1 = [_]i32{ 0, 4 };
    var iv2 = [_][*]i32{ &c0, &c1 };
    var cols2 = [_]i32{ 2, 2 };
    var rs2: i32 = 0;
    var cb2: [1][*]i32 = undefined;
    const r2 = merge(&iv2, 2, &cols2, &rs2, &cb2).?;
    try std.testing.expectEqual(@as(i32, 1), rs2);
    try std.testing.expectEqual(@as(i32, 0), r2[0][0]);
    try std.testing.expectEqual(@as(i32, 4), r2[0][1]);

    // Empty input.
    var cols3 = [_]i32{2};
    var rs3: i32 = 0;
    var cb3: [1][*]i32 = undefined;
    _ = merge(undefined, 0, &cols3, &rs3, &cb3).?;
    try std.testing.expectEqual(@as(i32, 0), rs3);

    // Extreme coordinates must not overflow the packing.
    var d0 = [_]i32{ -2147483648, 2147483647 };
    var d1 = [_]i32{ 0, 5 };
    var iv3 = [_][*]i32{ &d0, &d1 };
    var cols4 = [_]i32{ 2, 2 };
    var rs4: i32 = 0;
    var cb4: [1][*]i32 = undefined;
    const r4 = merge(&iv3, 2, &cols4, &rs4, &cb4).?;
    try std.testing.expectEqual(@as(i32, 1), rs4);
    try std.testing.expectEqual(@as(i32, -2147483648), r4[0][0]);
    try std.testing.expectEqual(@as(i32, 2147483647), r4[0][1]);
}
