// LeetCode 66. Plus One
// C signature:  int* plusOne(int* digits, int digitsSize, int* returnSize);
//
// If every digit is a 9 the result is one digit longer (1 followed by zeros);
// otherwise copy and propagate the carry from the least significant digit.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn plusOne(digits: [*]i32, digitsSize: i32, returnSize: *i32) [*]i32 {
    const n: usize = @intCast(digitsSize);

    var allNine = true;
    var i: usize = 0;
    while (i < n) : (i += 1) {
        if (digits[i] != 9) allNine = false;
    }

    if (allNine) {
        const out = allocator.alloc(i32, n + 1) catch unreachable;
        out[0] = 1;
        i = 1;
        while (i <= n) : (i += 1) out[i] = 0;
        returnSize.* = @intCast(n + 1);
        return out.ptr;
    }

    const out = allocator.alloc(i32, n) catch unreachable;
    var carry: i32 = 1;
    i = n;
    while (i > 0) : (i -= 1) {
        const d = digits[i - 1] + carry;
        if (d == 10) {
            out[i - 1] = 0;
            carry = 1;
        } else {
            out[i - 1] = d;
            carry = 0;
        }
    }
    returnSize.* = @intCast(n);
    return out.ptr;
}

test "plusOne examples" {
    var a = [_]i32{ 1, 2, 3 };
    var rs: i32 = 0;
    const r1 = plusOne(&a, 3, &rs);
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqual(@as(i32, 1), r1[0]);
    try std.testing.expectEqual(@as(i32, 2), r1[1]);
    try std.testing.expectEqual(@as(i32, 4), r1[2]);

    var b = [_]i32{ 4, 3, 2, 1 };
    const r2 = plusOne(&b, 4, &rs);
    try std.testing.expectEqual(@as(i32, 4), rs);
    try std.testing.expectEqual(@as(i32, 4), r2[0]);
    try std.testing.expectEqual(@as(i32, 2), r2[2]);
    try std.testing.expectEqual(@as(i32, 2), r2[3]);
}

test "plusOne edges" {
    var a = [_]i32{9};
    var rs: i32 = 0;
    const r1 = plusOne(&a, 1, &rs);
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, 1), r1[0]);
    try std.testing.expectEqual(@as(i32, 0), r1[1]);

    var b = [_]i32{ 9, 9, 9 };
    const r2 = plusOne(&b, 3, &rs);
    try std.testing.expectEqual(@as(i32, 4), rs);
    try std.testing.expectEqual(@as(i32, 1), r2[0]);
    try std.testing.expectEqual(@as(i32, 0), r2[3]);

    var c = [_]i32{0};
    const r3 = plusOne(&c, 1, &rs);
    try std.testing.expectEqual(@as(i32, 1), rs);
    try std.testing.expectEqual(@as(i32, 1), r3[0]);

    var d = [_]i32{ 1, 9 };
    const r4 = plusOne(&d, 2, &rs);
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, 2), r4[0]);
    try std.testing.expectEqual(@as(i32, 0), r4[1]);
}
