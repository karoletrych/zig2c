// LeetCode 39. Combination Sum
// C signature:  int** combinationSum(int* candidates, int candidatesSize,
//                                    int target, int* returnSize,
//                                    int** returnColumnSizes);
//
// Unbounded-knapsack DFS. From index `start` on, a candidate may be used again
// (so the recursion keeps the same index) which yields every multiset exactly
// once; a candidate larger than the remaining target is skipped. The row count
// is not known in advance, so growable lists collect the rows and columns.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn buildSums(candidates: [*]i32, n: i32, remaining: i32, start: i32, buf: [*]i32, depth: i32, rows: *std.ArrayList([*]i32), cols: *std.ArrayList(i32)) void {
    if (remaining == 0) {
        const du: usize = @intCast(depth);
        const row = allocator.alloc(i32, du) catch unreachable;
        var i: usize = 0;
        while (i < du) : (i += 1) row[i] = buf[i];
        rows.append(allocator, row.ptr) catch unreachable;
        cols.append(allocator, depth) catch unreachable;
        return;
    }
    var i: i32 = start;
    while (i < n) : (i += 1) {
        const v: i32 = candidates[@intCast(i)];
        if (v > remaining) continue;
        buf[@intCast(depth)] = v;
        buildSums(candidates, n, remaining - v, i, buf, depth + 1, rows, cols);
    }
}

pub fn combinationSum(candidates: [*]i32, candidatesSize: i32, target: i32, returnSize: *i32, returnColumnSizes: [*][*]i32) ?[*][*]i32 {
    var rows: std.ArrayList([*]i32) = .empty;
    var cols: std.ArrayList(i32) = .empty;

    var bcap: usize = 1;
    if (target > 0) bcap = @intCast(target);
    const buf = allocator.alloc(i32, bcap) catch unreachable;
    defer allocator.free(buf);

    buildSums(candidates, candidatesSize, target, 0, buf.ptr, 0, &rows, &cols);

    const rn: usize = rows.items.len;
    var rcap: usize = rn;
    if (rcap == 0) rcap = 1;
    const rout = allocator.alloc([*]i32, rcap) catch unreachable;
    const cout = allocator.alloc(i32, rcap) catch unreachable;
    var i: usize = 0;
    while (i < rn) : (i += 1) {
        rout[i] = rows.items[i];
        cout[i] = cols.items[i];
    }

    returnColumnSizes[0] = cout.ptr;
    returnSize.* = @intCast(rn);
    return rout.ptr;
}

fn rowEq(r: [*]i32, len: i32, want: []i32) bool {
    if (len != @as(i32, @intCast(want.len))) return false;
    var i: usize = 0;
    while (i < want.len) : (i += 1) {
        if (r[i] != want[i]) return false;
    }
    return true;
}

test "combinationSum examples" {
    var cands = [_]i32{ 2, 3, 6, 7 };
    var rs: i32 = 0;
    var cb = [_][*]i32{undefined};
    const r = combinationSum(&cands, 4, 7, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, 3), cb[0][0]);
    var w0 = [_]i32{ 2, 2, 3 };
    try std.testing.expect(rowEq(r[0], cb[0][0], &w0));
    try std.testing.expectEqual(@as(i32, 1), cb[0][1]);
    var w1 = [_]i32{7};
    try std.testing.expect(rowEq(r[1], cb[0][1], &w1));

    var c2 = [_]i32{ 2, 3, 5 };
    var rs2: i32 = 0;
    var cb2 = [_][*]i32{undefined};
    const r2 = combinationSum(&c2, 3, 8, &rs2, &cb2).?;
    try std.testing.expectEqual(@as(i32, 3), rs2);
    var v0 = [_]i32{ 2, 2, 2, 2 };
    var v1 = [_]i32{ 2, 3, 3 };
    var v2 = [_]i32{ 3, 5 };
    try std.testing.expect(rowEq(r2[0], cb2[0][0], &v0));
    try std.testing.expect(rowEq(r2[1], cb2[0][1], &v1));
    try std.testing.expect(rowEq(r2[2], cb2[0][2], &v2));
}

test "combinationSum edges" {
    // no combination reaches the target
    var c = [_]i32{2};
    var rs: i32 = 0;
    var cb = [_][*]i32{undefined};
    const r = combinationSum(&c, 1, 3, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 0), rs);
    _ = r;

    // the target itself is a candidate
    var c2 = [_]i32{5};
    var rs2: i32 = 0;
    var cb2 = [_][*]i32{undefined};
    const r2 = combinationSum(&c2, 1, 5, &rs2, &cb2).?;
    try std.testing.expectEqual(@as(i32, 1), rs2);
    try std.testing.expectEqual(@as(i32, 1), cb2[0][0]);
    try std.testing.expectEqual(@as(i32, 5), r2[0][0]);

    // using 1 repeatedly produces target + 1 rows for a single candidate
    var c3 = [_]i32{1};
    var rs3: i32 = 0;
    var cb3 = [_][*]i32{undefined};
    const r3 = combinationSum(&c3, 1, 4, &rs3, &cb3).?;
    try std.testing.expectEqual(@as(i32, 1), rs3);
    try std.testing.expectEqual(@as(i32, 4), cb3[0][0]);
    var w = [_]i32{ 1, 1, 1, 1 };
    try std.testing.expect(rowEq(r3[0], cb3[0][0], &w));

    // unsorted input still works
    var c4 = [_]i32{ 3, 2, 5 };
    var rs4: i32 = 0;
    var cb4 = [_][*]i32{undefined};
    const r4 = combinationSum(&c4, 3, 8, &rs4, &cb4).?;
    try std.testing.expectEqual(@as(i32, 3), rs4);
    var p0 = [_]i32{ 3, 3, 2 };
    var p1 = [_]i32{ 3, 5 };
    var p2 = [_]i32{ 2, 2, 2, 2 };
    try std.testing.expect(rowEq(r4[0], cb4[0][0], &p0));
    try std.testing.expect(rowEq(r4[1], cb4[0][1], &p1));
    try std.testing.expect(rowEq(r4[2], cb4[0][2], &p2));
}
