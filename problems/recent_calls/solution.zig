// LeetCode 933. Number of Recent Calls
// C signature:
//   RecentCounter* recentCounterCreate();
//   int recentCounterPing(RecentCounter* obj, int t);
//   void recentCounterFree(RecentCounter* obj);
//
// Pings arrive in increasing order, so the window [t - 3000, t] is maintained
// by advancing head while the oldest timestamp is too old.
const std = @import("std");
const allocator = std.heap.c_allocator;

const CAP: i32 = 10001;

pub const RecentCounter = struct {
    buf: [*]i32,
    head: i32,
    tail: i32,
};

pub fn recentCounterCreate() ?*RecentCounter {
    const obj = allocator.create(RecentCounter) catch unreachable;
    obj.buf = (allocator.alloc(i32, @intCast(CAP)) catch unreachable).ptr;
    obj.head = 0;
    obj.tail = 0;
    return obj;
}

pub fn recentCounterPing(obj: *RecentCounter, t: i32) i32 {
    obj.buf[@intCast(obj.tail)] = t;
    obj.tail += 1;
    while (obj.buf[@intCast(obj.head)] < t - 3000) obj.head += 1;
    return obj.tail - obj.head;
}

pub fn recentCounterFree(obj: *RecentCounter) void {
    allocator.free(obj.buf[0..@intCast(CAP)]);
    allocator.destroy(obj);
}

test "recentCounter" {
    const obj = recentCounterCreate().?;
    try std.testing.expectEqual(@as(i32, 1), recentCounterPing(obj, 1));
    try std.testing.expectEqual(@as(i32, 2), recentCounterPing(obj, 100));
    try std.testing.expectEqual(@as(i32, 3), recentCounterPing(obj, 3001));
    try std.testing.expectEqual(@as(i32, 3), recentCounterPing(obj, 3002));
    recentCounterFree(obj);

    const obj2 = recentCounterCreate().?;
    try std.testing.expectEqual(@as(i32, 1), recentCounterPing(obj2, 5000));
    try std.testing.expectEqual(@as(i32, 1), recentCounterPing(obj2, 8001));
    try std.testing.expectEqual(@as(i32, 2), recentCounterPing(obj2, 8002));
    try std.testing.expectEqual(@as(i32, 3), recentCounterPing(obj2, 9000));
    try std.testing.expectEqual(@as(i32, 1), recentCounterPing(obj2, 20000));
    recentCounterFree(obj2);
}
