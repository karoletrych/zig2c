// LeetCode 135. Candy
// C signature:  int candy(int* ratings, int ratingsSize);
//
// Every child starts with one candy. A left-to-right pass fixes increasing
// neighbours; a right-to-left pass fixes decreasing ones.

const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn candy(ratings: [*]i32, ratingsSize: i32) i32 {
    const n: usize = @intCast(ratingsSize);
    if (n == 0) return 0;
    const c = allocator.alloc(i32, n) catch unreachable;
    defer allocator.free(c);

    var i: usize = 0;
    while (i < n) : (i += 1) c[i] = 1;

    i = 1;
    while (i < n) : (i += 1) {
        if (ratings[i] > ratings[i - 1]) c[i] = c[i - 1] + 1;
    }

    i = n - 1;
    while (i > 0) : (i -= 1) {
        if (ratings[i - 1] > ratings[i] and c[i - 1] <= c[i]) c[i - 1] = c[i] + 1;
    }

    var total: i32 = 0;
    i = 0;
    while (i < n) : (i += 1) total += c[i];
    return total;
}

test "candy examples" {
    var a = [_]i32{ 1, 0, 2 };
    try std.testing.expectEqual(@as(i32, 5), candy(&a, 3));

    var b = [_]i32{ 1, 2, 2 };
    try std.testing.expectEqual(@as(i32, 4), candy(&b, 3));
}

test "candy edges" {
    var empty = [_]i32{0};
    try std.testing.expectEqual(@as(i32, 0), candy(&empty, 0));

    var one = [_]i32{9};
    try std.testing.expectEqual(@as(i32, 1), candy(&one, 1));

    var same = [_]i32{ 5, 5, 5, 5 };
    try std.testing.expectEqual(@as(i32, 4), candy(&same, 4));

    var up = [_]i32{ 1, 2, 3, 4, 5 };
    try std.testing.expectEqual(@as(i32, 15), candy(&up, 5));

    var down = [_]i32{ 5, 4, 3, 2, 1 };
    try std.testing.expectEqual(@as(i32, 15), candy(&down, 5));

    var valley = [_]i32{ 3, 2, 1, 2, 3 };
    try std.testing.expectEqual(@as(i32, 11), candy(&valley, 5));
}
