// LeetCode 322. Coin Change
// C signature:  int coinChange(int* coins, int coinsSize, int amount);
//
// dp[a] = fewest coins summing to a. Iterate amounts outward so each coin is
// reusable. An unreachable amount keeps the sentinel amount+1.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn coinChange(coins: [*]i32, coinsSize: i32, amount: i32) i32 {
    const inf: i32 = amount + 1;
    const dp = allocator.alloc(i32, @intCast(amount + 1)) catch unreachable;

    var i: i32 = 0;
    while (i <= amount) : (i += 1) dp[@intCast(i)] = inf;
    dp[0] = 0;

    i = 1;
    while (i <= amount) : (i += 1) {
        var c: i32 = 0;
        while (c < coinsSize) : (c += 1) {
            const coin = coins[@intCast(c)];
            if (coin <= i) {
                const prev = dp[@intCast(i - coin)];
                if (prev + 1 < dp[@intCast(i)]) dp[@intCast(i)] = prev + 1;
            }
        }
    }

    const ans = dp[@intCast(amount)];
    allocator.free(dp);
    return if (ans > amount) -1 else ans;
}

test "coinChange examples" {
    var a = [_]i32{ 1, 2, 5 };
    try std.testing.expectEqual(@as(i32, 3), coinChange(&a, 3, 11));

    var b = [_]i32{2};
    try std.testing.expectEqual(@as(i32, -1), coinChange(&b, 1, 3));

    var c = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 0), coinChange(&c, 1, 0));
}

test "coinChange edges" {
    var a = [_]i32{ 2, 5, 10, 1 };
    try std.testing.expectEqual(@as(i32, 4), coinChange(&a, 4, 27));

    var b = [_]i32{ 186, 419, 83, 408 };
    try std.testing.expectEqual(@as(i32, 20), coinChange(&b, 4, 6249));

    var c = [_]i32{5};
    try std.testing.expectEqual(@as(i32, -1), coinChange(&c, 1, 3));
    try std.testing.expectEqual(@as(i32, 2), coinChange(&c, 1, 10));

    var d = [_]i32{ 1, 2, 5 };
    try std.testing.expectEqual(@as(i32, 0), coinChange(&d, 3, 0));
    try std.testing.expectEqual(@as(i32, 1), coinChange(&d, 3, 5));
    try std.testing.expectEqual(@as(i32, 2), coinChange(&d, 3, 6));
}
