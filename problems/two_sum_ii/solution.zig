// LeetCode 167. Two Sum II - Input Array Is Sorted
// C signature:  int* twoSum(int* numbers, int numbersSize, int target, int* returnSize);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn twoSum(numbers: [*]i32, numbersSize: i32, target: i32, returnSize: *i32) ?[*]i32 {
    var i: i32 = 0;
    var j: i32 = numbersSize - 1;
    while (i < j) {
        const sum = numbers[@intCast(i)] + numbers[@intCast(j)];
        if (sum == target) {
            const out = allocator.alloc(i32, 2) catch unreachable;
            out[0] = i + 1;
            out[1] = j + 1;
            returnSize.* = 2;
            return out.ptr;
        } else if (sum < target) {
            i += 1;
        } else {
            j -= 1;
        }
    }
    returnSize.* = 0;
    return null;
}

test "twoSum examples" {
    var a = [_]i32{ 2, 7, 11, 15 };
    var rs: i32 = 0;
    const r = twoSum(&a, 4, 9, &rs).?;
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, 1), r[0]);
    try std.testing.expectEqual(@as(i32, 2), r[1]);

    var b = [_]i32{ 2, 3, 4 };
    var rs2: i32 = 0;
    const r2 = twoSum(&b, 3, 6, &rs2).?;
    try std.testing.expectEqual(@as(i32, 1), r2[0]);
    try std.testing.expectEqual(@as(i32, 3), r2[1]);
}

test "twoSum edges" {
    var a = [_]i32{ -1, 0 };
    var rs: i32 = 0;
    const r = twoSum(&a, 2, -1, &rs).?;
    try std.testing.expectEqual(@as(i32, 1), r[0]);
    try std.testing.expectEqual(@as(i32, 2), r[1]);

    // No valid pair: the C signature permits a NULL result.
    var b = [_]i32{ 1, 2, 3 };
    var rs2: i32 = 7;
    const r2 = twoSum(&b, 3, 100, &rs2);
    try std.testing.expectEqual(@as(i32, 0), rs2);
    try std.testing.expect(r2 == null);
}
