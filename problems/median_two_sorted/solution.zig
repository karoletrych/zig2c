// LeetCode 4. Median of Two Sorted Arrays
// C signature:  double findMedianSortedArrays(int* nums1, int nums1Size,
//                                              int* nums2, int nums2Size);
//
// Linear merge that stops as soon as the middle is reached: `prev` and `cur`
// hold the last two values consumed, which is exactly what the median needs for
// both parities. O(m + n) time and O(1) extra space.
const std = @import("std");

pub fn findMedianSortedArrays(nums1: [*]i32, nums1Size: i32, nums2: [*]i32, nums2Size: i32) f64 {
    const total: i32 = nums1Size + nums2Size;
    if (total == 0) return 0.0;
    const half: i32 = @divTrunc(total, 2);

    var i: i32 = 0;
    var j: i32 = 0;
    var prev: i32 = 0;
    var cur: i32 = 0;
    var c: i32 = 0;
    while (c <= half) : (c += 1) {
        prev = cur;
        if (i < nums1Size and (j >= nums2Size or nums1[@intCast(i)] <= nums2[@intCast(j)])) {
            cur = nums1[@intCast(i)];
            i += 1;
        } else {
            cur = nums2[@intCast(j)];
            j += 1;
        }
    }

    if (@mod(total, 2) == 1) return @floatFromInt(cur);
    return @as(f64, @floatFromInt(cur + prev)) / 2.0;
}

test "findMedianSortedArrays examples" {
    var a = [_]i32{ 1, 3 };
    var b = [_]i32{2};
    try std.testing.expectApproxEqAbs(@as(f64, 2.0), findMedianSortedArrays(&a, 2, &b, 1), 1e-9);

    var c = [_]i32{ 1, 2 };
    var d = [_]i32{ 3, 4 };
    try std.testing.expectApproxEqAbs(@as(f64, 2.5), findMedianSortedArrays(&c, 2, &d, 2), 1e-9);
}

test "findMedianSortedArrays edges" {
    // one side empty
    var empty = [_]i32{0};
    var odd = [_]i32{ 1, 2, 3 };
    try std.testing.expectApproxEqAbs(@as(f64, 2.0), findMedianSortedArrays(&empty, 0, &odd, 3), 1e-9);

    var even = [_]i32{ 1, 2, 3, 4 };
    try std.testing.expectApproxEqAbs(@as(f64, 2.5), findMedianSortedArrays(&even, 4, &empty, 0), 1e-9);

    // both singletons
    var one = [_]i32{5};
    var two = [_]i32{7};
    try std.testing.expectApproxEqAbs(@as(f64, 6.0), findMedianSortedArrays(&one, 1, &two, 1), 1e-9);

    // equal singletons
    var same = [_]i32{4};
    try std.testing.expectApproxEqAbs(@as(f64, 4.0), findMedianSortedArrays(&same, 1, &same, 1), 1e-9);

    // interleaved
    var p = [_]i32{ 1, 3, 5, 7 };
    var q = [_]i32{ 2, 4, 6, 8 };
    try std.testing.expectApproxEqAbs(@as(f64, 4.5), findMedianSortedArrays(&p, 4, &q, 4), 1e-9);

    // all of one smaller than all of the other
    var lo = [_]i32{ 1, 2, 3 };
    var hi = [_]i32{ 10, 20, 30 };
    try std.testing.expectApproxEqAbs(@as(f64, 6.5), findMedianSortedArrays(&lo, 3, &hi, 3), 1e-9);

    // negatives
    var n1 = [_]i32{ -5, -3, -1 };
    var n2 = [_]i32{ -4, -2, 0 };
    try std.testing.expectApproxEqAbs(@as(f64, -2.5), findMedianSortedArrays(&n1, 3, &n2, 3), 1e-9);
}
