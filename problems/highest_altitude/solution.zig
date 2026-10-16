// LeetCode 1732. Find the Highest Altitude
// C signature:  int* largestAltitude(int* gain, int gainSize, int* returnSize);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn largestAltitude(gain: [*]i32, gainSize: i32, returnSize: *i32) ?[*]i32 {
    const n: usize = @intCast(gainSize);
    const out = allocator.alloc(i32, n + 1) catch unreachable;
    out[0] = 0;

    var alt: i32 = 0;
    var i: usize = 0;
    while (i < n) : (i += 1) {
        alt += gain[i];
        out[i + 1] = alt;
    }
    returnSize.* = gainSize + 1;
    return out.ptr;
}

test "largestAltitude" {
    var gain = [_]i32{ -5, 1, 5, 0, -7 };
    var rs: i32 = 0;
    const r = largestAltitude(&gain, 5, &rs).?;
    try std.testing.expectEqual(@as(i32, 6), rs);
    const want = [_]i32{ 0, -5, -4, 1, 1, -6 };
    for (want, 0..) |w, k| try std.testing.expectEqual(w, r[k]);

    var g2 = [_]i32{ -4, -3, -2, -1, 4, 3, 2 };
    var rs2: i32 = 0;
    const r2 = largestAltitude(&g2, 7, &rs2).?;
    try std.testing.expectEqual(@as(i32, 8), rs2);
    const want2 = [_]i32{ 0, -4, -7, -9, -10, -6, -3, -1 };
    for (want2, 0..) |w, k| try std.testing.expectEqual(w, r2[k]);

    var g3 = [_]i32{0};
    var rs3: i32 = 0;
    const r3 = largestAltitude(&g3, 1, &rs3).?;
    try std.testing.expectEqual(@as(i32, 2), rs3);
    try std.testing.expectEqual(@as(i32, 0), r3[0]);
    try std.testing.expectEqual(@as(i32, 0), r3[1]);
}
