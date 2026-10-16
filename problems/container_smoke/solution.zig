// Smoke test for the container lowering: std.AutoHashMap + std.ArrayList.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn containerSmoke(nums: [*]i32, n: i32, returnSize: *i32) [*]i32 {
    var counts = std.AutoHashMap(i32, i32).init(allocator);
    defer counts.deinit();

    var i: i32 = 0;
    while (i < n) : (i += 1) {
        const gop = counts.getOrPut(nums[@intCast(i)]) catch unreachable;
        if (!gop.found_existing) gop.value_ptr.* = 0;
        gop.value_ptr.* += 1;
    }

    const out = allocator.alloc(i32, @intCast(counts.count())) catch unreachable;
    var list: std.ArrayList(i32) = .empty;
    defer list.deinit(allocator);

    i = 0;
    while (i < n) : (i += 1) {
        const v = nums[@intCast(i)];
        if (counts.contains(v)) {
            list.append(allocator, counts.get(v) orelse 0) catch unreachable;
            _ = counts.remove(v);
        }
    }

    var k: usize = 0;
    for (list.items) |v| {
        out[k] = v;
        k += 1;
    }
    returnSize.* = @intCast(list.items.len);
    return out.ptr;
}

test "containerSmoke" {
    var a = [_]i32{ 1, 2, 2, 3, 3, 3 };
    var rs: i32 = 0;
    const r = containerSmoke(&a, 6, &rs);
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqual(@as(i32, 1), r[0]);
    try std.testing.expectEqual(@as(i32, 2), r[1]);
    try std.testing.expectEqual(@as(i32, 3), r[2]);
}
