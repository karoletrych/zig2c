// LeetCode 57. Insert Interval
// C signature:
//   int** insert(int** intervals, int intervalsSize, int* intervalsColSize,
//                int* newInterval, int newIntervalSize, int* returnSize,
//                int** returnColumnSizes);
//
// intervals is already sorted and disjoint. Copy every interval that ends
// strictly before the new one, merge everything that overlaps the new one into
// a single run, then copy the rest. The merge bounds are kept in i64 to avoid
// int32 overflow at the extremes.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn addRow(outer: [*][*]i32, cols: [*]i32, idx: usize, a: i32, b: i32) void {
    const row = allocator.alloc(i32, 2) catch unreachable;
    row[0] = a;
    row[1] = b;
    outer[idx] = row.ptr;
    cols[idx] = 2;
}

pub fn insert(intervals: [*][*]i32, intervalsSize: i32, intervalsColSize: [*]i32, newInterval: [*]i32, newIntervalSize: i32, returnSize: *i32, returnColumnSizes: [*][*]i32) ?[*][*]i32 {
    _ = intervalsColSize;
    _ = newIntervalSize;

    const n: usize = @intCast(intervalsSize);
    const outer = allocator.alloc([*]i32, n + 1) catch unreachable;
    const cols = allocator.alloc(i32, n + 1) catch unreachable;
    returnColumnSizes[0] = cols.ptr;

    var count: usize = 0;
    var ns: i64 = newInterval[0];
    var ne: i64 = newInterval[1];

    var i: usize = 0;
    // Intervals entirely before the new one.
    while (i < n and @as(i64, intervals[i][1]) < ns) : (i += 1) {
        addRow(outer.ptr, cols.ptr, count, intervals[i][0], intervals[i][1]);
        count += 1;
    }
    // Everything overlapping the new interval.
    while (i < n and @as(i64, intervals[i][0]) <= ne) : (i += 1) {
        ns = @min(ns, @as(i64, intervals[i][0]));
        ne = @max(ne, @as(i64, intervals[i][1]));
    }
    addRow(outer.ptr, cols.ptr, count, @as(i32, @intCast(ns)), @as(i32, @intCast(ne)));
    count += 1;
    // The remaining intervals.
    while (i < n) : (i += 1) {
        addRow(outer.ptr, cols.ptr, count, intervals[i][0], intervals[i][1]);
        count += 1;
    }

    returnSize.* = @intCast(count);
    return outer.ptr;
}

test "insert examples" {
    var a0 = [_]i32{ 1, 3 };
    var a1 = [_]i32{ 6, 9 };
    var iv = [_][*]i32{ &a0, &a1 };
    var cols = [_]i32{ 2, 2 };
    var ni = [_]i32{ 2, 5 };
    var rs: i32 = 0;
    var cb: [1][*]i32 = undefined;
    const r = insert(&iv, 2, &cols, &ni, 2, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, 1), r[0][0]);
    try std.testing.expectEqual(@as(i32, 5), r[0][1]);
    try std.testing.expectEqual(@as(i32, 6), r[1][0]);
    try std.testing.expectEqual(@as(i32, 9), r[1][1]);
}

test "insert edges" {
    // New interval spans several existing ones.
    var a0 = [_]i32{ 1, 2 };
    var a1 = [_]i32{ 3, 5 };
    var a2 = [_]i32{ 6, 7 };
    var a3 = [_]i32{ 8, 10 };
    var a4 = [_]i32{ 12, 16 };
    var iv = [_][*]i32{ &a0, &a1, &a2, &a3, &a4 };
    var cols = [_]i32{ 2, 2, 2, 2, 2 };
    var ni = [_]i32{ 4, 8 };
    var rs: i32 = 0;
    var cb: [1][*]i32 = undefined;
    const r = insert(&iv, 5, &cols, &ni, 2, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqual(@as(i32, 1), r[0][0]);
    try std.testing.expectEqual(@as(i32, 2), r[0][1]);
    try std.testing.expectEqual(@as(i32, 3), r[1][0]);
    try std.testing.expectEqual(@as(i32, 10), r[1][1]);
    try std.testing.expectEqual(@as(i32, 12), r[2][0]);
    try std.testing.expectEqual(@as(i32, 16), r[2][1]);

    // Empty input.
    var cols2 = [_]i32{2};
    var ni2 = [_]i32{ 5, 7 };
    var rs2: i32 = 0;
    var cb2: [1][*]i32 = undefined;
    const r2 = insert(undefined, 0, &cols2, &ni2, 2, &rs2, &cb2).?;
    try std.testing.expectEqual(@as(i32, 1), rs2);
    try std.testing.expectEqual(@as(i32, 5), r2[0][0]);
    try std.testing.expectEqual(@as(i32, 7), r2[0][1]);

    // New interval is swallowed by an existing one.
    var b0 = [_]i32{ 1, 5 };
    var iv3 = [_][*]i32{&b0};
    var cols3 = [_]i32{2};
    var ni3 = [_]i32{ 2, 3 };
    var rs3: i32 = 0;
    var cb3: [1][*]i32 = undefined;
    const r3 = insert(&iv3, 1, &cols3, &ni3, 2, &rs3, &cb3).?;
    try std.testing.expectEqual(@as(i32, 1), rs3);
    try std.testing.expectEqual(@as(i32, 1), r3[0][0]);
    try std.testing.expectEqual(@as(i32, 5), r3[0][1]);

    // New interval goes after everything.
    var c0 = [_]i32{ 1, 5 };
    var iv4 = [_][*]i32{&c0};
    var cols4 = [_]i32{2};
    var ni4 = [_]i32{ 6, 8 };
    var rs4: i32 = 0;
    var cb4: [1][*]i32 = undefined;
    const r4 = insert(&iv4, 1, &cols4, &ni4, 2, &rs4, &cb4).?;
    try std.testing.expectEqual(@as(i32, 2), rs4);
    try std.testing.expectEqual(@as(i32, 1), r4[0][0]);
    try std.testing.expectEqual(@as(i32, 5), r4[0][1]);
    try std.testing.expectEqual(@as(i32, 6), r4[1][0]);
    try std.testing.expectEqual(@as(i32, 8), r4[1][1]);

    // Extreme new interval must not overflow.
    var ni5 = [_]i32{ -2147483648, 2147483647 };
    var cols5 = [_]i32{2};
    var rs5: i32 = 0;
    var cb5: [1][*]i32 = undefined;
    const r5 = insert(undefined, 0, &cols5, &ni5, 2, &rs5, &cb5).?;
    try std.testing.expectEqual(@as(i32, 1), rs5);
    try std.testing.expectEqual(@as(i32, -2147483648), r5[0][0]);
    try std.testing.expectEqual(@as(i32, 2147483647), r5[0][1]);
}
