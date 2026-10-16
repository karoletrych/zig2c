// LeetCode 2300. Successful Pairs of Spells and Potions
// C signature:  int* successfulPairs(int* spells, int spellsSize,
//                                    int* potions, int potionsSize,
//                                    long long success, int* returnSize);
//
// Sort the potions, then for each spell binary-search the first potion whose
// product with the spell reaches `success`; every potion from there on counts.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn lessThan(_: void, a: i32, b: i32) bool {
    return a < b;
}

pub fn successfulPairs(spells: [*]i32, spellsSize: i32, potions: [*]i32, potionsSize: i32, success: i64, returnSize: *i32) ?[*]i32 {
    const ns: usize = @intCast(spellsSize);
    const np: usize = @intCast(potionsSize);
    std.mem.sort(i32, potions[0..np], {}, lessThan);

    const out = allocator.alloc(i32, ns) catch unreachable;
    var i: usize = 0;
    while (i < ns) : (i += 1) {
        const s: i64 = @intCast(spells[i]);
        var lo: usize = 0;
        var hi: usize = np;
        while (lo < hi) {
            const mid = lo + (hi - lo) / 2;
            const prod = s * @as(i64, @intCast(potions[mid]));
            if (prod >= success) {
                hi = mid;
            } else {
                lo = mid + 1;
            }
        }
        out[i] = @intCast(np - lo);
    }

    returnSize.* = spellsSize;
    return out.ptr;
}

test "successfulPairs examples" {
    var sp = [_]i32{ 5, 1, 3 };
    var po = [_]i32{ 1, 2, 3, 4, 5 };
    var rs: i32 = 0;
    const r = successfulPairs(&sp, 3, &po, 5, 7, &rs).?;
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqual(@as(i32, 4), r[0]);
    try std.testing.expectEqual(@as(i32, 0), r[1]);
    try std.testing.expectEqual(@as(i32, 3), r[2]);

    var sp2 = [_]i32{ 3, 1, 2 };
    var po2 = [_]i32{ 8, 5, 8 };
    var rs2: i32 = 0;
    const r2 = successfulPairs(&sp2, 3, &po2, 3, 16, &rs2).?;
    try std.testing.expectEqual(@as(i32, 3), rs2);
    try std.testing.expectEqual(@as(i32, 2), r2[0]);
    try std.testing.expectEqual(@as(i32, 0), r2[1]);
    try std.testing.expectEqual(@as(i32, 2), r2[2]);
}

test "successfulPairs edges" {
    // products fit in long long far beyond int range
    var sp = [_]i32{ 100000, 1 };
    var po = [_]i32{ 100000, 100000 };
    var rs: i32 = 0;
    const r = successfulPairs(&sp, 2, &po, 2, 10000000000, &rs).?;
    try std.testing.expectEqual(@as(i32, 2), r[0]);
    try std.testing.expectEqual(@as(i32, 0), r[1]);

    // success = 1: every pair with a positive potion qualifies
    var sp2 = [_]i32{ 1, 1, 1 };
    var po2 = [_]i32{ 1 };
    var rs2: i32 = 0;
    const r2 = successfulPairs(&sp2, 3, &po2, 1, 1, &rs2).?;
    try std.testing.expectEqual(@as(i32, 1), r2[0]);
    try std.testing.expectEqual(@as(i32, 1), r2[1]);
    try std.testing.expectEqual(@as(i32, 1), r2[2]);
}
