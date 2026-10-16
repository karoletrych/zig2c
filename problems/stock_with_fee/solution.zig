// LeetCode 714. Best Time to Buy and Sell Stock with Transaction Fee
// C signature:  int maxProfit(int* prices, int pricesSize, int fee);
const std = @import("std");

pub fn maxProfit(prices: [*]i32, pricesSize: i32, fee: i32) i32 {
    if (pricesSize == 0) return 0;

    var cash: i32 = 0; // max profit, no stock held
    var hold: i32 = -prices[0]; // max profit, stock held
    var i: i32 = 1;
    while (i < pricesSize) : (i += 1) {
        const p = prices[@intCast(i)];
        const newCash = @max(cash, hold + p - fee);
        const newHold = @max(hold, cash - p);
        cash = newCash;
        hold = newHold;
    }
    return cash;
}

test "maxProfit examples" {
    var a = [_]i32{ 1, 3, 2, 8, 4, 9 };
    try std.testing.expectEqual(@as(i32, 8), maxProfit(&a, 6, 2));

    var b = [_]i32{ 1, 3, 7, 5, 10, 3 };
    try std.testing.expectEqual(@as(i32, 6), maxProfit(&b, 6, 3));
}

test "maxProfit edges" {
    var one = [_]i32{5};
    try std.testing.expectEqual(@as(i32, 0), maxProfit(&one, 1, 2));

    var same = [_]i32{ 4, 4, 4, 4 };
    try std.testing.expectEqual(@as(i32, 0), maxProfit(&same, 4, 1));

    var down = [_]i32{ 9, 8, 7, 6 };
    try std.testing.expectEqual(@as(i32, 0), maxProfit(&down, 4, 2));

    var none = [_]i32{ 1, 4 };
    try std.testing.expectEqual(@as(i32, 3), maxProfit(&none, 2, 0));
}
