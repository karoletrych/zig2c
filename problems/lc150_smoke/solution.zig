// Smoke test for features the LC150 set needs:
//  - a `Node` struct (LeetCode provides graph/copy-list/quad-tree Node; the
//    translator hides the body behind ZIG2C_LOCAL)
//  - std.AutoHashMap with POINTER values, so `map.get(k)` is `?*Node`
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const Node = struct {
    val: i32,
    next: ?*Node,
    random: ?*Node,
};

pub fn buildAndLink(n: i32, returnSize: *i32) i32 {
    var m = std.AutoHashMap(i32, *Node).init(allocator);
    defer m.deinit();

    var i: i32 = 0;
    while (i < n) : (i += 1) {
        const node = allocator.create(Node) catch unreachable;
        node.val = i * 10;
        node.next = null;
        node.random = null;
        m.put(i, node) catch unreachable;
    }

    var total: i32 = 0;
    i = 0;
    while (i < n) : (i += 1) {
        if (m.get(i)) |node| total += node.val;
        if (m.get(i + 100)) |node| total += node.val; // absent -> skipped
    }

    i = 0;
    while (i < n) : (i += 1) {
        if (m.get(i)) |node| allocator.destroy(node);
    }
    returnSize.* = @intCast(m.count());
    return total;
}

const NBUCKETS = 64;

pub const Cache = struct {
    buckets: [NBUCKETS]i32, // top-level int const as an array bound
    counts: std.AutoHashMap(i32, i32), // hash map as a struct field
    rng: u64,
};

pub fn cacheSmoke(n: i32, returnSize: *i32) i32 {
    var c: Cache = undefined;
    c.counts = std.AutoHashMap(i32, i32).init(allocator);
    defer c.counts.deinit();
    c.rng = 12345;

    var i: i32 = 0;
    while (i < NBUCKETS) : (i += 1) c.buckets[@intCast(i)] = 0;

    i = 0;
    while (i < n) : (i += 1) {
        const k: i32 = @mod(i, 7);
        const gop = c.counts.getOrPut(k) catch unreachable;
        if (!gop.found_existing) gop.value_ptr.* = 0;
        gop.value_ptr.* += 1;
    }

    var total: i32 = 0;
    i = 0;
    while (i < n) : (i += 1) {
        const k: i32 = @mod(i, 7);
        total += c.counts.get(k) orelse 0;
    }
    returnSize.* = @intCast(c.counts.count());
    return total;
}

pub fn floorModCheck() i32 {
    return @as(i32, @intCast(@mod(-7, 3))) * 100 + @as(i32, @intCast(@mod(7, -3)));
}

pub fn charLiteralCond(s: [*]u8) i32 {
    const str = std.mem.sliceTo(s, 0);
    var n: i32 = 0;
    for (str) |ch| {
        if (ch == '(' or ch == ')') n += 1;
        if (std.ascii.isAlphanumeric(ch)) n += 10;
    }
    return n;
}

test "lc150 smoke" {
    var rs: i32 = 0;
    try std.testing.expectEqual(@as(i32, 30), buildAndLink(3, &rs)); // 0 + 10 + 20
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqual(@as(i32, 3), cacheSmoke(3, &rs));
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqual(@as(i32, 198), floorModCheck());
    try std.testing.expectEqual(@as(i32, 12), charLiteralCond(@constCast("(a)")));
}
