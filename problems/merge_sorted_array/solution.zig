// LeetCode 88. Merge Sorted Array
// C signature:  void merge(int* nums1, int nums1Size, int m,
//                         int* nums2, int nums2Size, int n);
//
// nums1 has m valid elements followed by n zero placeholders. Merge from the
// back so no element is overwritten before it is read.

const std = @import("std");

pub fn merge(nums1: [*]i32, nums1Size: i32, m: i32, nums2: [*]i32, nums2Size: i32, n: i32) void {
    _ = nums1Size;
    _ = nums2Size;
    var i: i32 = m - 1;
    var j: i32 = n - 1;
    var k: i32 = m + n - 1;
    while (k >= 0) : (k -= 1) {
        if (j < 0) break;
        if (i >= 0 and nums1[@intCast(i)] > nums2[@intCast(j)]) {
            nums1[@intCast(k)] = nums1[@intCast(i)];
            i -= 1;
        } else {
            nums1[@intCast(k)] = nums2[@intCast(j)];
            j -= 1;
        }
    }
}

test "merge examples" {
    var a = [_]i32{ 1, 2, 3, 0, 0, 0 };
    var b = [_]i32{ 2, 5, 6 };
    merge(&a, 6, 3, &b, 3, 3);
    try std.testing.expectEqual(@as(i32, 1), a[0]);
    try std.testing.expectEqual(@as(i32, 2), a[1]);
    try std.testing.expectEqual(@as(i32, 2), a[2]);
    try std.testing.expectEqual(@as(i32, 3), a[3]);
    try std.testing.expectEqual(@as(i32, 5), a[4]);
    try std.testing.expectEqual(@as(i32, 6), a[5]);

    var c = [_]i32{1};
    var d = [_]i32{2};
    merge(&c, 1, 1, &d, 1, 0);
    try std.testing.expectEqual(@as(i32, 1), c[0]);

    var e = [_]i32{ 0, 0 };
    var f = [_]i32{1};
    merge(&e, 2, 0, &f, 1, 1);
    try std.testing.expectEqual(@as(i32, 1), e[0]);
    try std.testing.expectEqual(@as(i32, 0), e[1]);
}
