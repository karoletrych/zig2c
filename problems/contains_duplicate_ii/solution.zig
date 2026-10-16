// LeetCode 219. Contains Duplicate II
// C signature:  bool containsNearbyDuplicate(int* nums, int numsSize, int k);
//
// Keep the most recent index of each value in a hash map; whenever a value is
// seen again within distance k, a pair exists.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn containsNearbyDuplicate(nums: [*]i32, numsSize: i32, k: i32) bool {
    const n: usize = @intCast(numsSize);
    var last = std.AutoHashMap(i32, i32).init(allocator);
    defer last.deinit();

    var i: usize = 0;
    while (i < n) : (i += 1) {
        const v = nums[i];
        if (last.get(v)) |prev| {
            if (@as(i64, @intCast(i)) - @as(i64, prev) <= @as(i64, k)) return true;
        }
        last.put(v, @intCast(i)) catch unreachable;
    }
    return false;
}

test "containsNearbyDuplicate examples" {
    var a = [_]i32{ 1, 2, 3, 1 };
    try std.testing.expect(containsNearbyDuplicate(&a, 4, 3));

    var b = [_]i32{ 1, 0, 1, 1 };
    try std.testing.expect(containsNearbyDuplicate(&b, 4, 1));

    var c = [_]i32{ 1, 2, 3, 1, 2, 3 };
    try std.testing.expect(!containsNearbyDuplicate(&c, 6, 2));

    var d = [_]i32{1};
    try std.testing.expect(!containsNearbyDuplicate(&d, 1, 100));

    // k = 0 can never match (indices are distinct).
    var e = [_]i32{ 1, 1, 1 };
    try std.testing.expect(!containsNearbyDuplicate(&e, 3, 0));
    try std.testing.expect(containsNearbyDuplicate(&e, 3, 1));

    // negative values and exact boundary distance
    var f = [_]i32{ -7, 3, -7 };
    try std.testing.expect(containsNearbyDuplicate(&f, 3, 2));
    try std.testing.expect(!containsNearbyDuplicate(&f, 3, 1));
}
