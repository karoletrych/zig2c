// LeetCode 123. Best Time to Buy and Sell Stock III
// C signature:  int maxProfit(int* prices, int pricesSize);
//
// At most two transactions. Four running values are enough: the best balance
// after the first buy, the best profit after the first sell, the same two after
// the second buy and sell. Each price updates them in order, which naturally
// allows the second transaction to start where the first ended.
const std = @import("std");

pub fn maxProfit(prices: [*]i32, pricesSize: i32) i32 {
    if (pricesSize <= 1) return 0;
    const NEG: i32 = -2147483647;
    var buy1: i32 = NEG;
    var sell1: i32 = 0;
    var buy2: i32 = NEG;
    var sell2: i32 = 0;
    var i: i32 = 0;
    while (i < pricesSize) : (i += 1) {
        const p = prices[@intCast(i)];
        if (buy1 < -p) buy1 = -p;
        if (sell1 < buy1 + p) sell1 = buy1 + p;
        if (buy2 < sell1 - p) buy2 = sell1 - p;
        if (sell2 < buy2 + p) sell2 = buy2 + p;
    }
    return sell2;
}

test "maxProfit examples" {
    var a = [_]i32{ 3, 3, 5, 0, 0, 3, 1, 4 };
    try std.testing.expectEqual(@as(i32, 6), maxProfit(&a, 8));

    var b = [_]i32{ 1, 2, 3, 4, 5 };
    try std.testing.expectEqual(@as(i32, 4), maxProfit(&b, 5));

    var c = [_]i32{ 7, 6, 4, 3, 1 };
    try std.testing.expectEqual(@as(i32, 0), maxProfit(&c, 5));
}

test "maxProfit edges" {
    // fewer than two days
    var one = [_]i32{5};
    try std.testing.expectEqual(@as(i32, 0), maxProfit(&one, 1));

    // a single up move
    var up = [_]i32{ 1, 2 };
    try std.testing.expectEqual(@as(i32, 1), maxProfit(&up, 2));

    // one transaction is better than forcing two
    var once = [_]i32{ 2, 4, 1 };
    try std.testing.expectEqual(@as(i32, 2), maxProfit(&once, 3));

    // two disjoint waves
    var two = [_]i32{ 1, 2, 4, 2, 5, 7, 2, 4, 9, 0 };
    try std.testing.expectEqual(@as(i32, 13), maxProfit(&two, 10));

    // all equal
    var flat = [_]i32{ 3, 3, 3, 3 };
    try std.testing.expectEqual(@as(i32, 0), maxProfit(&flat, 4));

    // deep V then recovery
    var v = [_]i32{ 5, 2, 0, 3, 8 };
    try std.testing.expectEqual(@as(i32, 8), maxProfit(&v, 5));
}
