// LeetCode 121. Best Time to Buy and Sell Stock
// C signature:  int maxProfit(int* prices, int pricesSize);
//
// One transaction: track the cheapest price seen so far and the best sale.

const std = @import("std");

pub fn maxProfit(prices: [*]i32, pricesSize: i32) i32 {
    if (pricesSize == 0) return 0;
    var minPrice: i32 = prices[0];
    var best: i32 = 0;
    var i: i32 = 1;
    while (i < pricesSize) : (i += 1) {
        const p = prices[@intCast(i)];
        if (p - minPrice > best) best = p - minPrice;
        if (p < minPrice) minPrice = p;
    }
    return best;
}

test "maxProfit examples" {
    var a = [_]i32{ 7, 1, 5, 3, 6, 4 };
    try std.testing.expectEqual(@as(i32, 5), maxProfit(&a, 6));

    var b = [_]i32{ 7, 6, 4, 3, 1 };
    try std.testing.expectEqual(@as(i32, 0), maxProfit(&b, 5));
}

test "maxProfit edges" {
    var empty = [_]i32{0};
    try std.testing.expectEqual(@as(i32, 0), maxProfit(&empty, 0));

    var one = [_]i32{5};
    try std.testing.expectEqual(@as(i32, 0), maxProfit(&one, 1));

    var two = [_]i32{ 1, 5 };
    try std.testing.expectEqual(@as(i32, 4), maxProfit(&two, 2));

    var same = [_]i32{ 3, 3, 3 };
    try std.testing.expectEqual(@as(i32, 0), maxProfit(&same, 3));
}
