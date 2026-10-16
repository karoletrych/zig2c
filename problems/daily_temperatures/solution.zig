// LeetCode 739. Daily Temperatures  (LeetCode 75)
// C signature:  int* dailyTemperatures(int* temperatures, int temperaturesSize, int* returnSize);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn dailyTemperatures(temperatures: [*]i32, temperaturesSize: i32, returnSize: *i32) [*]i32 {
    const n: usize = @intCast(temperaturesSize);
    const res = allocator.alloc(i32, n) catch unreachable;
    const stk = allocator.alloc(usize, n) catch unreachable;

    var top: usize = 0;
    var i: usize = 0;
    while (i < n) : (i += 1) {
        while (top > 0 and temperatures[stk[top - 1]] < temperatures[i]) {
            const idx = stk[top - 1];
            res[idx] = @intCast(i - idx);
            top -= 1;
        }
        stk[top] = i;
        top += 1;
    }
    while (top > 0) {
        top -= 1;
        res[stk[top]] = 0;
    }
    returnSize.* = temperaturesSize;
    return res.ptr;
}

test "dailyTemperatures" {
    var t = [_]i32{ 73, 74, 75, 71, 69, 72, 76, 73 };
    var rs: i32 = 0;
    const r = dailyTemperatures(&t, 8, &rs);
    const want = [_]i32{ 1, 1, 4, 2, 1, 1, 0, 0 };
    for (want, 0..) |w, k| try std.testing.expectEqual(w, r[k]);
}
