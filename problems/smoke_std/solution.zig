// Smoke test for the "std helpers" side of the supported subset.
// Not a LeetCode problem - it exercises defer/free, std.mem.eql,
// std.ascii.*, and structs passed by value.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const Pair = struct {
    a: i32,
    b: i32,
};

pub fn sumPair(p: Pair) i32 {
    return p.a + p.b;
}

pub fn countDigits(s: [*]u8) i32 {
    const str = std.mem.sliceTo(s, 0);
    var n: i32 = 0;
    for (str) |c| {
        if (std.ascii.isDigit(c)) n += 1;
    }
    return n;
}

pub fn stringsEqual(a: [*]u8, b: [*]u8) bool {
    const x = std.mem.sliceTo(a, 0);
    const y = std.mem.sliceTo(b, 0);
    return std.mem.eql(u8, x, y);
}

pub fn sumSquaresBelow(n: i32, returnSize: *i32) i32 {
    const buf = allocator.alloc(i32, @intCast(n)) catch unreachable;
    defer allocator.free(buf);

    var i: i32 = 0;
    while (i < n) : (i += 1) buf[@intCast(i)] = i * i;

    var total: i32 = 0;
    i = 0;
    while (i < n) : (i += 1) {
        if (buf[@intCast(i)] > 5) break;
        total += buf[@intCast(i)];
    }
    returnSize.* = n;
    return total;
}

test "smoke" {
    try std.testing.expectEqual(@as(i32, 3), sumPair(.{ .a = 1, .b = 2 }));
    try std.testing.expectEqual(@as(i32, 3), countDigits(@constCast("a1b2c3")));
    try std.testing.expect(stringsEqual(@constCast("abc"), @constCast("abc")));
    try std.testing.expect(!stringsEqual(@constCast("abc"), @constCast("abd")));
    var rs: i32 = 0;
    try std.testing.expectEqual(@as(i32, 5), sumSquaresBelow(5, &rs));
}
