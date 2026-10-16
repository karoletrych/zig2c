// LeetCode 2336. Smallest Number in Infinite Set
// C signature:
//   SmallestInfiniteSet* smallestInfiniteSetCreate();
//   int popSmallest(SmallestInfiniteSet* obj);
//   void addBack(SmallestInfiniteSet* obj, int num);
//
// At most 1000 calls are made, so a pop can never return a value above 2000.
// `present[i]` tracks whether i is still in the set; the set begins as
// {1, 2, 3, ...}. popSmallest scans for the first present value.
const std = @import("std");
const allocator = std.heap.c_allocator;

const LIMIT: usize = 2000;

pub const SmallestInfiniteSet = struct {
    present: [2001]bool,
};

pub fn smallestInfiniteSetCreate() ?*SmallestInfiniteSet {
    const obj = allocator.create(SmallestInfiniteSet) catch unreachable;
    var i: usize = 0;
    while (i <= LIMIT) : (i += 1) obj.present[i] = true;
    return obj;
}

pub fn popSmallest(obj: *SmallestInfiniteSet) i32 {
    var i: usize = 1;
    while (i <= LIMIT) : (i += 1) {
        if (obj.present[i]) {
            obj.present[i] = false;
            return @intCast(i);
        }
    }
    return -1;
}

pub fn addBack(obj: *SmallestInfiniteSet, num: i32) void {
    if (num >= 1 and num <= @as(i32, @intCast(LIMIT))) {
        obj.present[@intCast(num)] = true;
    }
}

test "smallestInfiniteSet example" {
    const obj = smallestInfiniteSetCreate().?;
    addBack(obj, 2);
    try std.testing.expectEqual(@as(i32, 1), popSmallest(obj));
    try std.testing.expectEqual(@as(i32, 2), popSmallest(obj));
    try std.testing.expectEqual(@as(i32, 3), popSmallest(obj));
    addBack(obj, 1);
    try std.testing.expectEqual(@as(i32, 1), popSmallest(obj));
    try std.testing.expectEqual(@as(i32, 4), popSmallest(obj));
    try std.testing.expectEqual(@as(i32, 5), popSmallest(obj));
}

test "smallestInfiniteSet addBack duplicates" {
    const obj = smallestInfiniteSetCreate().?;
    try std.testing.expectEqual(@as(i32, 1), popSmallest(obj));
    try std.testing.expectEqual(@as(i32, 2), popSmallest(obj));
    addBack(obj, 2);
    addBack(obj, 2);
    try std.testing.expectEqual(@as(i32, 2), popSmallest(obj));
    try std.testing.expectEqual(@as(i32, 3), popSmallest(obj));
    addBack(obj, 100);
    try std.testing.expectEqual(@as(i32, 4), popSmallest(obj));
    try std.testing.expectEqual(@as(i32, 5), popSmallest(obj));
}
