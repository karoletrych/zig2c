// LeetCode 2215. Find the Difference of Two Arrays
// C signature:  int** findDifference(int* nums1, int nums1Size, int* nums2, int nums2Size,
//                                   int* returnSize, int** returnColumnSizes);
// Values are in [-1000, 1000], so presence is tracked with a fixed 2001-entry table.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn findDifference(nums1: [*]i32, nums1Size: i32, nums2: [*]i32, nums2Size: i32, returnSize: *i32, returnColumnSizes: [*][*]i32) ?[*][*]i32 {
    var in1: [2001]bool = undefined;
    var in2: [2001]bool = undefined;
    var i: usize = 0;
    while (i < 2001) : (i += 1) {
        in1[i] = false;
        in2[i] = false;
    }

    var j: i32 = 0;
    while (j < nums1Size) : (j += 1) {
        in1[@intCast(nums1[@intCast(j)] + 1000)] = true;
    }
    j = 0;
    while (j < nums2Size) : (j += 1) {
        in2[@intCast(nums2[@intCast(j)] + 1000)] = true;
    }

    const row0 = allocator.alloc(i32, 2001) catch unreachable;
    const row1 = allocator.alloc(i32, 2001) catch unreachable;
    var n0: i32 = 0;
    var n1: i32 = 0;

    i = 0;
    while (i < 2001) : (i += 1) {
        if (in1[i] and !in2[i]) {
            row0[@intCast(n0)] = @as(i32, @intCast(i)) - 1000;
            n0 += 1;
        }
        if (in2[i] and !in1[i]) {
            row1[@intCast(n1)] = @as(i32, @intCast(i)) - 1000;
            n1 += 1;
        }
    }

    const out = allocator.alloc([*]i32, 2) catch unreachable;
    out[0] = row0.ptr;
    out[1] = row1.ptr;

    const cols = allocator.alloc(i32, 2) catch unreachable;
    cols[0] = n0;
    cols[1] = n1;
    returnColumnSizes[0] = cols.ptr;

    returnSize.* = 2;
    return out.ptr;
}

test "findDifference" {
    var a = [_]i32{ 1, 2, 3 };
    var b = [_]i32{ 2, 4, 6 };
    var rs: i32 = 0;
    var cb = [_][*]i32{ undefined, undefined };
    const res = findDifference(&a, 3, &b, 3, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, 2), cb[0][0]);
    try std.testing.expectEqual(@as(i32, 1), res[0][0]);
    try std.testing.expectEqual(@as(i32, 3), res[0][1]);
    try std.testing.expectEqual(@as(i32, 2), cb[0][1]);
    try std.testing.expectEqual(@as(i32, 4), res[1][0]);
    try std.testing.expectEqual(@as(i32, 6), res[1][1]);

    var c = [_]i32{ 1, 2, 3, 3 };
    var d = [_]i32{ 1, 1, 2, 2 };
    var rs2: i32 = 0;
    var cb2 = [_][*]i32{ undefined, undefined };
    const res2 = findDifference(&c, 4, &d, 4, &rs2, &cb2).?;
    try std.testing.expectEqual(@as(i32, 1), cb2[0][0]);
    try std.testing.expectEqual(@as(i32, 3), res2[0][0]);
    try std.testing.expectEqual(@as(i32, 0), cb2[0][1]);

    var e = [_]i32{-1000};
    var f = [_]i32{1000};
    var rs3: i32 = 0;
    var cb3 = [_][*]i32{ undefined, undefined };
    const res3 = findDifference(&e, 1, &f, 1, &rs3, &cb3).?;
    try std.testing.expectEqual(@as(i32, 1), cb3[0][0]);
    try std.testing.expectEqual(@as(i32, -1000), res3[0][0]);
    try std.testing.expectEqual(@as(i32, 1), cb3[0][1]);
    try std.testing.expectEqual(@as(i32, 1000), res3[1][0]);
}
