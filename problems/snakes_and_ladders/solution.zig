// LeetCode 909. Snakes and Ladders
// C signature:  int snakesAndLadders(int** board, int boardSize,
//                                    int* boardColSize);
//
// Breadth-first search over the square labels 1..n*n. Label -> (row, col) uses
// the boustrophedon layout (even rows left to right, odd rows right to left,
// counted from the bottom); a board value != -1 teleports to that label.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn cellAt(board: [*][*]i32, n: i32, label: i32) i32 {
    const fromBottom: i32 = @divTrunc(label - 1, n);
    const r: i32 = n - 1 - fromBottom;
    const off: i32 = @mod(label - 1, n);
    var c: i32 = off;
    if (@mod(fromBottom, 2) != 0) c = n - 1 - off;
    return board[@intCast(r)][@intCast(c)];
}

pub fn snakesAndLadders(board: [*][*]i32, boardSize: i32, boardColSize: [*]i32) i32 {
    _ = boardColSize;
    const n: i32 = boardSize;
    const total: i32 = n * n;
    const size: usize = @intCast(total + 1);

    const dist = allocator.alloc(i32, size) catch unreachable;
    defer allocator.free(dist);
    var i: usize = 0;
    while (i < size) : (i += 1) dist[i] = -1;

    const q = allocator.alloc(i32, size) catch unreachable;
    defer allocator.free(q);

    var qh: i32 = 0;
    var qt: i32 = 0;
    dist[1] = 0;
    q[0] = 1;
    qt = 1;

    while (qh < qt) {
        const cur: i32 = q[@intCast(qh)];
        qh += 1;
        if (cur == total) return dist[@intCast(cur)];

        var step: i32 = 1;
        while (step <= 6) : (step += 1) {
            var nxt: i32 = cur + step;
            if (nxt > total) break;
            const v: i32 = cellAt(board, n, nxt);
            if (v != -1) nxt = v;
            if (dist[@intCast(nxt)] == -1) {
                dist[@intCast(nxt)] = dist[@intCast(cur)] + 1;
                q[@intCast(qt)] = nxt;
                qt += 1;
            }
        }
    }
    return -1;
}

test "snakesAndLadders examples" {
    var r0 = [_]i32{ -1, -1, -1, -1, -1, -1 };
    var r1 = [_]i32{ -1, -1, -1, -1, -1, -1 };
    var r2 = [_]i32{ -1, -1, -1, -1, -1, -1 };
    var r3 = [_]i32{ -1, 35, -1, -1, 13, -1 };
    var r4 = [_]i32{ -1, -1, -1, -1, -1, -1 };
    var r5 = [_]i32{ -1, 15, -1, -1, -1, -1 };
    var b = [_][*]i32{ &r0, &r1, &r2, &r3, &r4, &r5 };
    var cols = [_]i32{ 6, 6, 6, 6, 6, 6 };
    try std.testing.expectEqual(@as(i32, 4), snakesAndLadders(&b, 6, &cols));

    var s0 = [_]i32{ -1, -1 };
    var s1 = [_]i32{ -1, 3 };
    var b2 = [_][*]i32{ &s0, &s1 };
    var cols2 = [_]i32{ 2, 2 };
    try std.testing.expectEqual(@as(i32, 1), snakesAndLadders(&b2, 2, &cols2));
}

test "snakesAndLadders edges" {
    // nothing but snakes back to the start
    var a0 = [_]i32{ 1, 1, -1 };
    var a1 = [_]i32{ 1, 1, 1 };
    var a2 = [_]i32{ -1, 1, 1 };
    var b = [_][*]i32{ &a0, &a1, &a2 };
    var cols = [_]i32{ 3, 3, 3 };
    try std.testing.expectEqual(@as(i32, -1), snakesAndLadders(&b, 3, &cols));

    // 2x2 with no snakes: 1 -> 4 in a single roll of 3
    var c0 = [_]i32{ -1, -1 };
    var c1 = [_]i32{ -1, -1 };
    var b2 = [_][*]i32{ &c0, &c1 };
    var cols2 = [_]i32{ 2, 2 };
    try std.testing.expectEqual(@as(i32, 1), snakesAndLadders(&b2, 2, &cols2));

    // 3x3 with no snakes: 6 then 2
    var d0 = [_]i32{ -1, -1, -1 };
    var d1 = [_]i32{ -1, -1, -1 };
    var d2 = [_]i32{ -1, -1, -1 };
    var b3 = [_][*]i32{ &d0, &d1, &d2 };
    var cols3 = [_]i32{ 3, 3, 3 };
    try std.testing.expectEqual(@as(i32, 2), snakesAndLadders(&b3, 3, &cols3));

    // a ladder on label 2 jumps straight to the top
    var e0 = [_]i32{ -1, -1 };
    var e1 = [_]i32{ -1, 4 };
    var b4 = [_][*]i32{ &e0, &e1 };
    var cols4 = [_]i32{ 2, 2 };
    try std.testing.expectEqual(@as(i32, 1), snakesAndLadders(&b4, 2, &cols4));
}
