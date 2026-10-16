// LeetCode 146. LRU Cache
// C signatures:
//   LRUCache* lRUCacheCreate(int capacity);
//   int lRUCacheGet(LRUCache* obj, int key);
//   void lRUCachePut(LRUCache* obj, int key, int value);
//   void lRUCacheFree(LRUCache* obj);
//
// A doubly linked list keeps recency order (sentinels at both ends: `head.next`
// is the most recently used node, `tail.prev` the least). Lookup goes through a
// fixed-size, chained hash table held as an array of bucket lists, since a
// std.AutoHashMap field inside a struct cannot be emitted by zig2c (the map's C
// typedef is printed after the struct bodies). Every operation stays O(1).
const std = @import("std");
const allocator = std.heap.c_allocator;

const NBUCKETS: usize = 4096;

pub const LRUCacheNode = struct {
    key: i32,
    value: i32,
    prev: ?*LRUCacheNode,
    next: ?*LRUCacheNode,
};

pub const Bucket = struct {
    key: i32,
    node: ?*LRUCacheNode,
    next: ?*Bucket,
};

pub const LRUCache = struct {
    cap: i32,
    size: i32,
    head: ?*LRUCacheNode,
    tail: ?*LRUCacheNode,
    // Spelled as a literal: zig2c emits struct bodies before top-level consts,
    // so a `[NBUCKETS]` field would reference NBUCKETS before its definition.
    // Keep in sync with NBUCKETS above (power of two).
    buckets: [4096]?*Bucket,
};

fn bucketOf(key: i32) usize {
    // mask off the sign bit so negative keys still land in range
    const k: usize = @intCast(key & 0x7fffffff);
    return k & (NBUCKETS - 1);
}

fn newNode(key: i32, value: i32) *LRUCacheNode {
    const n = allocator.create(LRUCacheNode) catch unreachable;
    n.key = key;
    n.value = value;
    n.prev = null;
    n.next = null;
    return n;
}

fn bucketFind(obj: *LRUCache, key: i32) ?*LRUCacheNode {
    var e = obj.buckets[bucketOf(key)];
    while (e) |b| {
        if (b.key == key) return b.node;
        e = b.next;
    }
    return null;
}

fn bucketAdd(obj: *LRUCache, node: *LRUCacheNode) void {
    const idx = bucketOf(node.key);
    const b = allocator.create(Bucket) catch unreachable;
    b.key = node.key;
    b.node = node;
    b.next = obj.buckets[idx];
    obj.buckets[idx] = b;
}

fn bucketRemove(obj: *LRUCache, key: i32) void {
    const idx = bucketOf(key);
    var prev: ?*Bucket = null;
    var cur = obj.buckets[idx];
    while (cur) |b| {
        if (b.key == key) {
            if (prev) |p| {
                p.next = b.next;
            } else {
                obj.buckets[idx] = b.next;
            }
            allocator.destroy(b);
            return;
        }
        prev = b;
        cur = b.next;
    }
}

fn listAddFront(obj: *LRUCache, node: *LRUCacheNode) void {
    node.prev = obj.head;
    node.next = obj.head.?.next;
    obj.head.?.next.?.prev = node;
    obj.head.?.next = node;
}

fn listRemove(node: *LRUCacheNode) void {
    if (node.prev) |p| {
        p.next = node.next;
    }
    if (node.next) |n| {
        n.prev = node.prev;
    }
}

pub fn lRUCacheCreate(capacity: i32) ?*LRUCache {
    const obj = allocator.create(LRUCache) catch unreachable;
    obj.cap = capacity;
    obj.size = 0;
    var i: usize = 0;
    while (i < NBUCKETS) : (i += 1) {
        obj.buckets[i] = null;
    }
    const h = newNode(0, 0);
    const t = newNode(0, 0);
    h.next = t;
    t.prev = h;
    obj.head = h;
    obj.tail = t;
    return obj;
}

pub fn lRUCacheGet(obj: *LRUCache, key: i32) i32 {
    const node = bucketFind(obj, key);
    if (node == null) return -1;
    const n = node.?;
    listRemove(n);
    listAddFront(obj, n);
    return n.value;
}

pub fn lRUCachePut(obj: *LRUCache, key: i32, value: i32) void {
    const found = bucketFind(obj, key);
    if (found != null) {
        const n = found.?;
        n.value = value;
        listRemove(n);
        listAddFront(obj, n);
        return;
    }

    const n = newNode(key, value);
    listAddFront(obj, n);
    bucketAdd(obj, n);
    obj.size += 1;

    if (obj.size > obj.cap) {
        const old = obj.tail.?.prev.?;
        listRemove(old);
        bucketRemove(obj, old.key);
        allocator.destroy(old);
        obj.size -= 1;
    }
}

pub fn lRUCacheFree(obj: *LRUCache) void {
    var cur = obj.head;
    while (cur) |n| {
        const nxt = n.next;
        allocator.destroy(n);
        cur = nxt;
    }
    var i: usize = 0;
    while (i < NBUCKETS) : (i += 1) {
        var b = obj.buckets[i];
        while (b) |e| {
            const nxt = e.next;
            allocator.destroy(e);
            b = nxt;
        }
        obj.buckets[i] = null;
    }
    allocator.destroy(obj);
}

test "LRU example" {
    const c = lRUCacheCreate(2).?;
    lRUCachePut(c, 1, 1);
    lRUCachePut(c, 2, 2);
    try std.testing.expectEqual(@as(i32, 1), lRUCacheGet(c, 1)); // returns 1
    lRUCachePut(c, 3, 3); // evicts key 2
    try std.testing.expectEqual(@as(i32, -1), lRUCacheGet(c, 2));
    lRUCachePut(c, 4, 4); // evicts key 1
    try std.testing.expectEqual(@as(i32, -1), lRUCacheGet(c, 1));
    try std.testing.expectEqual(@as(i32, 3), lRUCacheGet(c, 3));
    try std.testing.expectEqual(@as(i32, 4), lRUCacheGet(c, 4));
    lRUCacheFree(c);
}

test "LRU capacity one" {
    const c = lRUCacheCreate(1).?;
    lRUCachePut(c, 2, 20);
    try std.testing.expectEqual(@as(i32, 20), lRUCacheGet(c, 2));
    lRUCachePut(c, 3, 30); // evicts 2
    try std.testing.expectEqual(@as(i32, -1), lRUCacheGet(c, 2));
    try std.testing.expectEqual(@as(i32, 30), lRUCacheGet(c, 3));
    lRUCacheFree(c);
}

test "LRU updates and repeats" {
    const c = lRUCacheCreate(2).?;
    lRUCachePut(c, 1, 1);
    lRUCachePut(c, 2, 2);
    lRUCachePut(c, 1, 10); // refresh key 1, no eviction
    try std.testing.expectEqual(@as(i32, 10), lRUCacheGet(c, 1));
    lRUCachePut(c, 3, 3); // key 2 was least recently used -> evicted
    try std.testing.expectEqual(@as(i32, -1), lRUCacheGet(c, 2));
    try std.testing.expectEqual(@as(i32, 10), lRUCacheGet(c, 1));
    try std.testing.expectEqual(@as(i32, 3), lRUCacheGet(c, 3));

    // putting the same key twice does not grow the cache
    lRUCachePut(c, 3, 33);
    try std.testing.expectEqual(@as(i32, 33), lRUCacheGet(c, 3));
    try std.testing.expectEqual(@as(i32, 10), lRUCacheGet(c, 1));
    lRUCacheFree(c);
}

test "LRU arbitrary and negative keys" {
    const c = lRUCacheCreate(3).?;
    lRUCachePut(c, 100000, 7);
    lRUCachePut(c, -100000, 8);
    lRUCachePut(c, 2147483647, 9);
    lRUCachePut(c, -2147483648, 10); // 4th insert evicts 100000 (the LRU)
    try std.testing.expectEqual(@as(i32, 8), lRUCacheGet(c, -100000));
    try std.testing.expectEqual(@as(i32, 9), lRUCacheGet(c, 2147483647));
    try std.testing.expectEqual(@as(i32, 10), lRUCacheGet(c, -2147483648));
    try std.testing.expectEqual(@as(i32, -1), lRUCacheGet(c, 100000));
    // re-inserting after eviction works
    lRUCachePut(c, 100000, 77);
    try std.testing.expectEqual(@as(i32, 77), lRUCacheGet(c, 100000));
    lRUCacheFree(c);
}

test "LRU eviction order" {
    const c = lRUCacheCreate(2).?;
    lRUCachePut(c, 1, 1);
    lRUCachePut(c, 2, 2);
    _ = lRUCacheGet(c, 1); // 1 is now most recent, 2 is LRU
    lRUCachePut(c, 3, 3);  // evicts 2
    try std.testing.expectEqual(@as(i32, -1), lRUCacheGet(c, 2));
    try std.testing.expectEqual(@as(i32, 1), lRUCacheGet(c, 1));
    lRUCacheFree(c);
}
