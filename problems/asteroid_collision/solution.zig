// LeetCode 735. Asteroid Collision
// C signature:  int* asteroidCollision(int* asteroids, int asteroidsSize, int* returnSize);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn asteroidCollision(asteroids: [*]i32, asteroidsSize: i32, returnSize: *i32) [*]i32 {
    const n: usize = @intCast(asteroidsSize);
    const stk = allocator.alloc(i32, n) catch unreachable;

    var top: usize = 0;
    var i: usize = 0;
    while (i < n) : (i += 1) {
        const a = asteroids[i];
        var alive = true;
        while (top > 0 and alive and stk[top - 1] > 0 and a < 0) {
            const sum = stk[top - 1] + a;
            if (sum < 0) {
                top -= 1;
            } else if (sum > 0) {
                alive = false;
            } else {
                top -= 1;
                alive = false;
            }
        }
        if (alive) {
            stk[top] = a;
            top += 1;
        }
    }
    returnSize.* = @intCast(top);
    return stk.ptr;
}

test "asteroidCollision" {
    var a1 = [_]i32{ 5, 10, -5 };
    var rs1: i32 = 0;
    const r1 = asteroidCollision(&a1, 3, &rs1);
    try std.testing.expectEqual(@as(i32, 2), rs1);
    try std.testing.expectEqual(@as(i32, 5), r1[0]);
    try std.testing.expectEqual(@as(i32, 10), r1[1]);

    var a2 = [_]i32{ 8, -8 };
    var rs2: i32 = 0;
    const r2 = asteroidCollision(&a2, 2, &rs2);
    try std.testing.expectEqual(@as(i32, 0), rs2);
    _ = r2;

    var a3 = [_]i32{ 10, 2, -5 };
    var rs3: i32 = 0;
    const r3 = asteroidCollision(&a3, 3, &rs3);
    try std.testing.expectEqual(@as(i32, 1), rs3);
    try std.testing.expectEqual(@as(i32, 10), r3[0]);

    var a4 = [_]i32{ -2, -1, 1, 2 };
    var rs4: i32 = 0;
    const r4 = asteroidCollision(&a4, 4, &rs4);
    try std.testing.expectEqual(@as(i32, 4), rs4);
    try std.testing.expectEqual(@as(i32, -2), r4[0]);
    try std.testing.expectEqual(@as(i32, 2), r4[3]);
}
