// LeetCode 188. Best Time to Buy and Sell Stock IV
// C signature:  int maxProfit(int k, int* prices, int pricesSize);
//
// `buy[j]` is the best balance after buying with j transactions so far, and
// `sell[j]` the best total profit using at most j transactions. Each day updates
// j = 1..k; buy[j] reads sell[j - 1] from the same pass, which is what lets the
// transactions chain without overlapping on a single day.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn maxProfit(k: i32, prices: [*]i32, pricesSize: i32) i32 {
    if (pricesSize <= 1 or k <= 0) return 0;

    const kk: usize = @intCast(k);
    const buy = allocator.alloc(i32, kk + 1) catch unreachable;
    defer allocator.free(buy);
    const sell = allocator.alloc(i32, kk + 1) catch unreachable;
    defer allocator.free(sell);

    var j: usize = 0;
    while (j <= kk) : (j += 1) {
        buy[j] = -2147483647;
        sell[j] = 0;
    }

    var i: i32 = 0;
    while (i < pricesSize) : (i += 1) {
        const p = prices[@intCast(i)];
        j = 1;
        while (j <= kk) : (j += 1) {
            if (buy[j] < sell[j - 1] - p) buy[j] = sell[j - 1] - p;
            if (sell[j] < buy[j] + p) sell[j] = buy[j] + p;
        }
    }
    return sell[kk];
}

test "maxProfit examples" {
    var a = [_]i32{ 2, 4, 1 };
    try std.testing.expectEqual(@as(i32, 2), maxProfit(2, &a, 3));

    var b = [_]i32{ 3, 2, 6, 5, 0, 3 };
    try std.testing.expectEqual(@as(i32, 7), maxProfit(2, &b, 6));
}

test "maxProfit edges" {
    // k == 0: no trading allowed
    var a = [_]i32{ 1, 2, 3, 4, 5 };
    try std.testing.expectEqual(@as(i32, 0), maxProfit(0, &a, 5));

    // k == 1 behaves like the single-transaction problem
    try std.testing.expectEqual(@as(i32, 4), maxProfit(1, &a, 5));

    // k >= number of days: unlimited transactions, sum every rising edge
    try std.testing.expectEqual(@as(i32, 4), maxProfit(100, &a, 5));
    var b = [_]i32{ 7, 1, 5, 3, 6, 4 };
    try std.testing.expectEqual(@as(i32, 7), maxProfit(100, &b, 6));

    // decreasing prices
    var c = [_]i32{ 9, 8, 7, 6 };
    try std.testing.expectEqual(@as(i32, 0), maxProfit(2, &c, 4));

    // single day
    var one = [_]i32{5};
    try std.testing.expectEqual(@as(i32, 0), maxProfit(3, &one, 1));

    // all equal
    var flat = [_]i32{ 4, 4, 4 };
    try std.testing.expectEqual(@as(i32, 0), maxProfit(2, &flat, 3));

    // two classic transactions
    var two = [_]i32{ 3, 3, 5, 0, 0, 3, 1, 4 };
    try std.testing.expectEqual(@as(i32, 6), maxProfit(2, &two, 8));
}
