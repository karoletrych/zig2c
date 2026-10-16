// LeetCode 134. Gas Station
// C signature:  int canCompleteCircuit(int* gas, int gasSize,
//                                       int* cost, int costSize);
//
// If the total gas covers the total cost, the trip is possible. Whenever the
// running tank goes negative, no start before the current index can work, so
// restart just after it.

const std = @import("std");

pub fn canCompleteCircuit(gas: [*]i32, gasSize: i32, cost: [*]i32, costSize: i32) i32 {
    _ = costSize;
    var total: i32 = 0;
    var tank: i32 = 0;
    var start: i32 = 0;
    var i: i32 = 0;
    while (i < gasSize) : (i += 1) {
        const diff = gas[@intCast(i)] - cost[@intCast(i)];
        total += diff;
        tank += diff;
        if (tank < 0) {
            start = i + 1;
            tank = 0;
        }
    }
    if (total < 0) return -1;
    return start;
}

test "canCompleteCircuit examples" {
    var g = [_]i32{ 1, 2, 3, 4, 5 };
    var c = [_]i32{ 3, 4, 5, 1, 2 };
    try std.testing.expectEqual(@as(i32, 3), canCompleteCircuit(&g, 5, &c, 5));

    var g2 = [_]i32{ 2, 3, 4 };
    var c2 = [_]i32{ 3, 4, 3 };
    try std.testing.expectEqual(@as(i32, -1), canCompleteCircuit(&g2, 3, &c2, 3));
}

test "canCompleteCircuit edges" {
    var g = [_]i32{1};
    var c = [_]i32{1};
    try std.testing.expectEqual(@as(i32, 0), canCompleteCircuit(&g, 1, &c, 1));

    var g2 = [_]i32{1};
    var c2 = [_]i32{2};
    try std.testing.expectEqual(@as(i32, -1), canCompleteCircuit(&g2, 1, &c2, 1));

    var g3 = [_]i32{ 5, 1, 2, 3, 4 };
    var c3 = [_]i32{ 4, 4, 1, 5, 1 };
    try std.testing.expectEqual(@as(i32, 4), canCompleteCircuit(&g3, 5, &c3, 5));

    var empty = [_]i32{0};
    var empty2 = [_]i32{0};
    try std.testing.expectEqual(@as(i32, 0), canCompleteCircuit(&empty, 0, &empty2, 0));
}
