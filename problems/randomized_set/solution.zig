// LeetCode 380. Insert Delete GetRandom O(1)
// C signatures:
//   RandomizedSet* randomizedSetCreate();
//   bool randomizedSetInsert(RandomizedSet* obj, int val);
//   bool randomizedSetRemove(RandomizedSet* obj, int val);
//   int randomizedSetGetRandom(RandomizedSet* obj);
//
// `vals` holds the current members; `idx` maps a value to its position in
// `vals`, so removal swaps the last member into the hole. Randomness comes from
// a hand-rolled xorshift64 PRNG in the `rng` field.
//
// Note: the translator emits HashMap typedefs after struct bodies, so a map
// cannot be a struct field. The map is heap-allocated and the struct keeps its
// raw address in `idx` (cast back with mapOf).

const std = @import("std");
const allocator = std.heap.c_allocator;

pub const RandomizedSet = struct {
    vals: std.ArrayList(i32),
    idx: *u8,
    rng: u64,
};

fn mapOf(obj: *RandomizedSet) *std.AutoHashMap(i32, i32) {
    return @alignCast(@ptrCast(obj.idx));
}

pub fn randomizedSetCreate() ?*RandomizedSet {
    const obj = allocator.create(RandomizedSet) catch unreachable;
    obj.vals = .empty;
    const raw = allocator.alloc(u8, @sizeOf(std.AutoHashMap(i32, i32))) catch unreachable;
    const m: *std.AutoHashMap(i32, i32) = @alignCast(@ptrCast(raw.ptr));
    m.* = std.AutoHashMap(i32, i32).init(allocator);
    obj.idx = @ptrCast(m);
    obj.rng = 88172645463325252;
    return obj;
}

pub fn randomizedSetInsert(obj: *RandomizedSet, val: i32) bool {
    const m = mapOf(obj);
    if (m.contains(val)) return false;
    m.put(val, @intCast(obj.vals.items.len)) catch unreachable;
    obj.vals.append(allocator, val) catch unreachable;
    return true;
}

pub fn randomizedSetRemove(obj: *RandomizedSet, val: i32) bool {
    const m = mapOf(obj);
    if (m.get(val)) |i| {
        const last = obj.vals.items[obj.vals.items.len - 1];
        obj.vals.items[@intCast(i)] = last;
        m.put(last, i) catch unreachable;
        _ = obj.vals.pop();
        _ = m.remove(val);
        return true;
    }
    return false;
}

pub fn randomizedSetGetRandom(obj: *RandomizedSet) i32 {
    const n: usize = obj.vals.items.len;
    if (n == 0) return 0;
    obj.rng = obj.rng ^ (obj.rng << 13);
    obj.rng = obj.rng ^ (obj.rng >> 7);
    obj.rng = obj.rng ^ (obj.rng << 17);
    const r = obj.rng % @as(u64, @intCast(n));
    return obj.vals.items[@intCast(r)];
}

test "randomizedSet example" {
    const obj = randomizedSetCreate().?;
    try std.testing.expect(randomizedSetInsert(obj, 1));
    try std.testing.expect(!randomizedSetRemove(obj, 2));
    try std.testing.expect(randomizedSetInsert(obj, 2));
    const g = randomizedSetGetRandom(obj);
    try std.testing.expect(g == 1 or g == 2);
    try std.testing.expect(randomizedSetRemove(obj, 1));
    try std.testing.expect(!randomizedSetInsert(obj, 2));
    try std.testing.expectEqual(@as(i32, 2), randomizedSetGetRandom(obj));
}

test "randomizedSet single element" {
    const obj = randomizedSetCreate().?;
    try std.testing.expect(randomizedSetInsert(obj, 5));
    try std.testing.expectEqual(@as(i32, 5), randomizedSetGetRandom(obj));
    try std.testing.expectEqual(@as(i32, 5), randomizedSetGetRandom(obj));
    try std.testing.expect(randomizedSetRemove(obj, 5));
    try std.testing.expect(randomizedSetInsert(obj, 5));
    try std.testing.expectEqual(@as(i32, 5), randomizedSetGetRandom(obj));
}

test "randomizedSet keeps every member reachable" {
    const obj = randomizedSetCreate().?;
    var i: i32 = 0;
    while (i < 10) : (i += 1) {
        try std.testing.expect(randomizedSetInsert(obj, i));
    }
    try std.testing.expect(!randomizedSetInsert(obj, 4));
    try std.testing.expect(randomizedSetRemove(obj, 4));
    try std.testing.expect(!randomizedSetRemove(obj, 4));
    var seen: i32 = 0;
    var t: i32 = 0;
    while (t < 200) : (t += 1) {
        const g = randomizedSetGetRandom(obj);
        try std.testing.expect(g != 4);
        try std.testing.expect(g >= 0 and g < 10);
        seen += 1;
    }
    try std.testing.expectEqual(@as(i32, 200), seen);
}
