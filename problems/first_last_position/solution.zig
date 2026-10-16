// LeetCode 34. Find First and Last Position of Element in Sorted Array
// C signature:  int* searchRange(int* nums, int numsSize, int target,
//                              int* returnSize);
//
// Two lower-bound binary searches: the first finds the first index >= target,
// and the second (using `<= target`) finds the first index > target, so the
// last occurrence is one before it. returnSize is always 2.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn searchRange(nums: [*]i32, numsSize: i32, target: i32, returnSize: *i32) ?[*]i32 {
    const res = allocator.alloc(i32, 2) catch unreachable;
    res[0] = -1;
    res[1] = -1;

    // first index with nums[i] >= target
    var lo: i32 = 0;
    var hi: i32 = numsSize;
    while (lo < hi) {
        const mid = lo + @divTrunc(hi - lo, 2);
        if (nums[@intCast(mid)] < target) {
            lo = mid + 1;
        } else {
            hi = mid;
        }
    }
    const first = lo;
    if (first < numsSize and nums[@intCast(first)] == target) {
        res[0] = first;
        // first index with nums[i] > target
        lo = first;
        hi = numsSize;
        while (lo < hi) {
            const mid = lo + @divTrunc(hi - lo, 2);
            if (nums[@intCast(mid)] <= target) {
                lo = mid + 1;
            } else {
                hi = mid;
            }
        }
        res[1] = lo - 1;
    }

    returnSize.* = 2;
    return res.ptr;
}

test "searchRange examples" {
    var a = [_]i32{ 5, 7, 7, 8, 8, 10 };
    var rs: i32 = 0;
    const r = searchRange(&a, 6, 8, &rs).?;
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, 3), r[0]);
    try std.testing.expectEqual(@as(i32, 4), r[1]);

    var rs2: i32 = 0;
    const r2 = searchRange(&a, 6, 6, &rs2).?;
    try std.testing.expectEqual(@as(i32, 2), rs2);
    try std.testing.expectEqual(@as(i32, -1), r2[0]);
    try std.testing.expectEqual(@as(i32, -1), r2[1]);
}

test "searchRange edges" {
    // empty input
    var e = [_]i32{0};
    var rs: i32 = 0;
    const r = searchRange(&e, 0, 0, &rs).?;
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, -1), r[0]);
    try std.testing.expectEqual(@as(i32, -1), r[1]);

    // single element present / absent
    var one = [_]i32{1};
    var rs1: i32 = 0;
    const r1 = searchRange(&one, 1, 1, &rs1).?;
    try std.testing.expectEqual(@as(i32, 0), r1[0]);
    try std.testing.expectEqual(@as(i32, 0), r1[1]);
    const r1b = searchRange(&one, 1, 2, &rs1).?;
    try std.testing.expectEqual(@as(i32, -1), r1b[0]);
    try std.testing.expectEqual(@as(i32, -1), r1b[1]);

    // two equal elements
    var two = [_]i32{ 2, 2 };
    var rs2: i32 = 0;
    const r2 = searchRange(&two, 2, 2, &rs2).?;
    try std.testing.expectEqual(@as(i32, 0), r2[0]);
    try std.testing.expectEqual(@as(i32, 1), r2[1]);

    // all equal, longer
    var eq = [_]i32{ 4, 4, 4, 4, 4 };
    var rs3: i32 = 0;
    const r3 = searchRange(&eq, 5, 4, &rs3).?;
    try std.testing.expectEqual(@as(i32, 0), r3[0]);
    try std.testing.expectEqual(@as(i32, 4), r3[1]);

    // target at each end of an otherwise distinct array
    var d = [_]i32{ 1, 2, 3, 4, 5 };
    var rs4: i32 = 0;
    const r4 = searchRange(&d, 5, 1, &rs4).?;
    try std.testing.expectEqual(@as(i32, 0), r4[0]);
    try std.testing.expectEqual(@as(i32, 0), r4[1]);
    const r5 = searchRange(&d, 5, 5, &rs4).?;
    try std.testing.expectEqual(@as(i32, 4), r5[0]);
    try std.testing.expectEqual(@as(i32, 4), r5[1]);

    // below and above the range
    const r6 = searchRange(&d, 5, -9, &rs4).?;
    try std.testing.expectEqual(@as(i32, -1), r6[0]);
    const r7 = searchRange(&d, 5, 99, &rs4).?;
    try std.testing.expectEqual(@as(i32, -1), r7[0]);
}
