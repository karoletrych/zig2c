// Regression coverage for translator fixes:
//  - fixed-array struct fields and `for (array) |v|`
//  - ArrayList(u8) pop/getLast (which needs an optional-value typedef)
//  - passing a *std.AutoHashMap to a helper
//  - a top-level helper with an error-union return type
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const Box = struct {
    buf: [8]i32,
    list: std.ArrayList(i32),
};

pub fn sumArrayField(returnSize: *i32) i32 {
    var b: Box = undefined;
    b.list = .empty;
    defer b.list.deinit(allocator);

    var i: usize = 0;
    while (i < 8) : (i += 1) b.buf[i] = @intCast(i);

    var total: i32 = 0;
    for (b.buf) |v| total += v;

    b.list.append(allocator, 5) catch unreachable;
    b.list.append(allocator, 6) catch unreachable;
    total += b.list.getLast();

    returnSize.* = @intCast(b.list.items.len);
    return total;
}

pub fn useListPop(returnSize: *i32) i32 {
    var l: std.ArrayList(u8) = .empty;
    defer l.deinit(allocator);
    l.append(allocator, 'a') catch unreachable;
    l.append(allocator, 'b') catch unreachable;

    var total: i32 = 0;
    const p = l.pop();
    if (p) |c| total += @intCast(c);

    returnSize.* = @intCast(l.items.len);
    return total;
}

fn mapper(m: *std.AutoHashMap(i32, i32)) i32 {
    m.put(1, 2) catch unreachable;
    return m.get(1) orelse 0;
}

pub fn useMapPtr(returnSize: *i32) i32 {
    var m = std.AutoHashMap(i32, i32).init(allocator);
    defer m.deinit();
    returnSize.* = 0;
    return mapper(&m);
}

fn noop() !void {}

pub fn errUnionHelper() bool {
    noop() catch return false;
    return true;
}

// A value read out of a buffer that is freed by a `defer` must still be correct.
pub fn deferReturn() i32 {
    const buf = allocator.alloc(i32, 3) catch unreachable;
    defer allocator.free(buf);
    buf[0] = 10;
    buf[1] = 20;
    buf[2] = 30;
    return buf[0] + buf[1] + buf[2];
}

const SMALL = [_]i32{ 7, 8 };
const SIZED: [2]i32 = .{ 5, 6 };

pub fn useConstArrays(returnSize: *i32) i32 {
    var total: i32 = 0;
    for (SMALL) |v| total += v;
    for (SIZED) |v| total += v;
    returnSize.* = SMALL.len;
    return total;
}

// Sentinel-terminated pointers/slices/arrays must parse:  [*:0]T  [:0]T  [N:0]T
pub fn sentinelSmoke(s: [*:0]const u8, returnSize: *i32) i32 {
    const sl: [:0]const u8 = std.mem.span(s);
    var buf: [8:0]u8 = undefined;
    var i: usize = 0;
    while (i < sl.len and i < 8) : (i += 1) buf[i] = sl[i];
    buf[i] = 0;
    returnSize.* = @intCast(sl.len);
    return @intCast(buf[0]);
}

test "fixes" {
    var rs: i32 = 0;
    // 0..7 sum = 28, + getLast (6) = 34, list len 2
    try std.testing.expectEqual(@as(i32, 34), sumArrayField(&rs));
    try std.testing.expectEqual(@as(i32, 2), rs);
    // pop returns 'b' (98), len becomes 1
    try std.testing.expectEqual(@as(i32, 98), useListPop(&rs));
    try std.testing.expectEqual(@as(i32, 1), rs);
    try std.testing.expectEqual(@as(i32, 2), useMapPtr(&rs));
    try std.testing.expect(errUnionHelper());
    try std.testing.expectEqual(@as(i32, 60), deferReturn());
    try std.testing.expectEqual(@as(i32, 26), useConstArrays(&rs));
    try std.testing.expectEqual(@as(i32, 2), rs);
    // 'h' == 104, len 5
    try std.testing.expectEqual(@as(i32, 104), sentinelSmoke("hello", &rs));
    try std.testing.expectEqual(@as(i32, 5), rs);
}
