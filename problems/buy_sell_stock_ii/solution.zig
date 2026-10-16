// LeetCode 122. Best Time to Buy and Sell Stock II
// C signature:  int maxProfit(int* prices, int pricesSize);
//
// Unlimited transactions: every upward step can be captured.

const std = @import("std");

pub fn maxProfit(prices: [*]i32, pricesSize: i32) i32 {
    var total: i32 = 0;
    var i: i32 = 1;
    while (i < pricesSize) : (i += 1) {
        const diff = prices[@intCast(i)] - prices[@intCast(i - 1)];
        if (diff > 0) total += diff;
    }
    return total;
}

test "maxProfit examples" {
    var a = [_]i32{ 7, 1, 5, 3, 6, 4 };
    try std.testing.expectEqual(@as(i32, 7), maxProfit(&a, 6));

    var b = [_]i32{ 1, 2, 3, 4, 5 };
    try std.testing.expectEqual(@as(i32, 4), maxProfit(&b, 5));

    var c = [_]i32{ 7, 6, 4, 3, 1 };
    try std.testing.expectEqual(@as(i32, 0), maxProfit(&c, 5));
}

test "maxProfit edges" {
    var empty = [_]i32{0};
    try std.testing.expectEqual(@as(i32, 0), maxProfit(&empty, 0));

    var one = [_]i32{5};
    try std.testing.expectEqual(@as(i32, 0), maxProfit(&one, 1));

    var same = [_]i32{ 4, 4, 4 };
    try std.testing.expectEqual(@as(i32, 0), maxProfit(&same, 3));

    var up = [_]i32{ 1, 2 };
    try std.testing.expectEqual(@as(i32, 1), maxProfit(&up, 2));
}
