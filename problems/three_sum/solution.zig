// LeetCode 15. 3Sum
// C signature:  int** threeSum(int* nums, int numsSize, int* returnSize,
//                             int** returnColumnSizes);
//
// Sort a copy, then for each anchor i use a two-pointer sweep on the suffix.
// Duplicate anchors and duplicate endpoints are skipped. Every emitted row has
// exactly three values, so returnColumnSizes is a parallel array of 3s.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn lessThan(_: void, a: i32, b: i32) bool {
    return a < b;
}

pub fn threeSum(nums: [*]i32, numsSize: i32, returnSize: *i32, returnColumnSizes: [*][*]i32) ?[*][*]i32 {
    const n: usize = @intCast(numsSize);
    if (n < 3) {
        returnSize.* = 0;
        return null;
    }

    const a = allocator.alloc(i32, n) catch unreachable;
    var i: usize = 0;
    while (i < n) : (i += 1) a[i] = nums[i];
    std.mem.sort(i32, a, {}, lessThan);

    var rowList: std.ArrayList([*]i32) = .empty;
    defer rowList.deinit(allocator);
    var colList: std.ArrayList(i32) = .empty;
    defer colList.deinit(allocator);

    i = 0;
    while (i + 2 < n) {
        if (i > 0 and a[i] == a[i - 1]) {
            i += 1;
            continue;
        }
        var lo: usize = i + 1;
        var hi: usize = n - 1;
        while (lo < hi) {
            const sum = a[i] + a[lo] + a[hi];
            if (sum == 0) {
                const triple = allocator.alloc(i32, 3) catch unreachable;
                triple[0] = a[i];
                triple[1] = a[lo];
                triple[2] = a[hi];
                rowList.append(allocator, triple.ptr) catch unreachable;
                colList.append(allocator, 3) catch unreachable;
                lo += 1;
                hi -= 1;
                while (lo < hi and a[lo] == a[lo - 1]) lo += 1;
                while (lo < hi and a[hi] == a[hi + 1]) hi -= 1;
            } else if (sum < 0) {
                lo += 1;
            } else {
                hi -= 1;
            }
        }
        i += 1;
    }

    const count: usize = rowList.items.len;
    if (count == 0) {
        returnSize.* = 0;
        return null;
    }
    const rows = allocator.alloc([*]i32, count) catch unreachable;
    const cols = allocator.alloc(i32, count) catch unreachable;
    var k: usize = 0;
    while (k < count) : (k += 1) {
        rows[k] = rowList.items[k];
        cols[k] = colList.items[k];
    }
    returnColumnSizes[0] = cols.ptr;
    returnSize.* = @intCast(count);
    return rows.ptr;
}

test "threeSum examples" {
    var nums = [_]i32{ -1, 0, 1, 2, -1, -4 };
    var rs: i32 = 0;
    var cb = [_][*]i32{undefined};
    const r = threeSum(&nums, 6, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, 3), cb[0][0]);
    try std.testing.expectEqual(@as(i32, 3), cb[0][1]);
    try std.testing.expectEqual(@as(i32, -1), r[0][0]);
    try std.testing.expectEqual(@as(i32, -1), r[0][1]);
    try std.testing.expectEqual(@as(i32, 2), r[0][2]);
    try std.testing.expectEqual(@as(i32, -1), r[1][0]);
    try std.testing.expectEqual(@as(i32, 0), r[1][1]);
    try std.testing.expectEqual(@as(i32, 1), r[1][2]);

    var none = [_]i32{ 0, 1, 1 };
    var rs2: i32 = 3;
    const r2 = threeSum(&none, 3, &rs2, &cb);
    try std.testing.expectEqual(@as(i32, 0), rs2);
    try std.testing.expect(r2 == null);
}

test "threeSum edges" {
    var zeros = [_]i32{ 0, 0, 0 };
    var rs: i32 = 0;
    var cb = [_][*]i32{undefined};
    const r = threeSum(&zeros, 3, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 1), rs);
    try std.testing.expectEqual(@as(i32, 0), r[0][0]);
    try std.testing.expectEqual(@as(i32, 0), r[0][1]);
    try std.testing.expectEqual(@as(i32, 0), r[0][2]);

    // all zeros, longer input -> still exactly one triple
    var many = [_]i32{ 0, 0, 0, 0, 0, 0 };
    var rs2: i32 = 0;
    const r2 = threeSum(&many, 6, &rs2, &cb).?;
    try std.testing.expectEqual(@as(i32, 1), rs2);
    try std.testing.expectEqual(@as(i32, 3), cb[0][0]);
    try std.testing.expectEqual(@as(i32, 0), r2[0][0]);
    try std.testing.expectEqual(@as(i32, 0), r2[0][1]);
    try std.testing.expectEqual(@as(i32, 0), r2[0][2]);

    // two values, too short
    var two = [_]i32{ 0, 0 };
    var rs3: i32 = 9;
    const r3 = threeSum(&two, 2, &rs3, &cb);
    try std.testing.expectEqual(@as(i32, 0), rs3);
    try std.testing.expect(r3 == null);

    // duplicate-rich input
    var dup = [_]i32{ -2, 0, 0, 2, 2 };
    var rs4: i32 = 0;
    const r4 = threeSum(&dup, 5, &rs4, &cb).?;
    try std.testing.expectEqual(@as(i32, 1), rs4);
    try std.testing.expectEqual(@as(i32, -2), r4[0][0]);
    try std.testing.expectEqual(@as(i32, 0), r4[0][1]);
    try std.testing.expectEqual(@as(i32, 2), r4[0][2]);
}
