// Smoke test for std.StringHashMap and hash-map iteration.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn stringMapSmoke(returnSize: *i32) i32 {
    var counts = std.StringHashMap(i32).init(allocator);
    defer counts.deinit();

    const words = [_][]const u8{ "apple", "banana", "apple", "cherry", "banana", "apple" };
    for (words) |w| {
        const gop = counts.getOrPut(w) catch unreachable;
        if (!gop.found_existing) gop.value_ptr.* = 0;
        gop.value_ptr.* += 1;
    }

    var total: i32 = 0;
    for (words) |w| {
        if (counts.get(w)) |v| total += v;
    }

    var keyChars: i32 = 0;
    var kit = counts.keyIterator();
    while (kit.next()) |k| keyChars += @intCast(k.len);

    var sumValues: i32 = 0;
    var eit = counts.iterator();
    while (eit.next()) |entry| sumValues += entry.value_ptr.*;

    returnSize.* = @intCast(counts.count());
    return total + keyChars + sumValues;
}

pub fn intMapIter(returnSize: *i32) i32 {
    var m = std.AutoHashMap(i32, i32).init(allocator);
    defer m.deinit();
    m.put(1, 10) catch unreachable;
    m.put(2, 20) catch unreachable;
    m.put(3, 30) catch unreachable;

    var s: i32 = 0;

    var kit = m.keyIterator();
    while (kit.next()) |k| s += k.*;

    var vit = m.valueIterator();
    while (vit.next()) |v| s += v.*;

    var eit = m.iterator();
    while (eit.next()) |entry| s += entry.key_ptr.* + entry.value_ptr.*;

    returnSize.* = @intCast(m.count());
    return s;
}

test "stdmap smoke" {
    var rs: i32 = 0;
    // counts: apple=3 banana=2 cherry=1; total=14, keyChars=5+6+6=17, sum=6
    try std.testing.expectEqual(@as(i32, 37), stringMapSmoke(&rs));
    try std.testing.expectEqual(@as(i32, 3), rs);
    // keys 6 + values 60 + (key+value) 66 = 132
    try std.testing.expectEqual(@as(i32, 132), intMapIter(&rs));
    try std.testing.expectEqual(@as(i32, 3), rs);
}
