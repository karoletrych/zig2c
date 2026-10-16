// LeetCode 649. Dota2 Senate
// C signature:  char* predictPartyVictory(char* senate);
//
// Two queues of senator indices. Repeatedly the two front senators act in
// index order: the earlier one bans the later one, and the winner is re-queued
// at index + n so the round structure (a circular queue) is preserved.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn predictPartyVictory(senate: [*]u8) [*]u8 {
    const str = std.mem.sliceTo(senate, 0);
    const n: usize = str.len;
    const cap = 2 * n + 1;

    const rq = allocator.alloc(i32, cap) catch unreachable;
    const dq = allocator.alloc(i32, cap) catch unreachable;
    defer allocator.free(rq);
    defer allocator.free(dq);

    var rhead: usize = 0;
    var rtail: usize = 0;
    var dhead: usize = 0;
    var dtail: usize = 0;

    var i: usize = 0;
    while (i < n) : (i += 1) {
        if (str[i] == 'R') {
            rq[rtail] = @intCast(i);
            rtail += 1;
        } else {
            dq[dtail] = @intCast(i);
            dtail += 1;
        }
    }

    while (rhead < rtail and dhead < dtail) {
        const ri = rq[rhead];
        const di = dq[dhead];
        if (ri < di) {
            dhead += 1;
            rq[rtail] = ri + @as(i32, @intCast(n));
            rtail += 1;
            rhead += 1;
        } else {
            rhead += 1;
            dq[dtail] = di + @as(i32, @intCast(n));
            dtail += 1;
            dhead += 1;
        }
    }

    const out = allocator.alloc(u8, 8) catch unreachable;
    if (rhead < rtail) {
        out[0] = 'R';
        out[1] = 'a';
        out[2] = 'd';
        out[3] = 'i';
        out[4] = 'a';
        out[5] = 'n';
        out[6] = 't';
        out[7] = 0;
    } else {
        out[0] = 'D';
        out[1] = 'i';
        out[2] = 'r';
        out[3] = 'e';
        out[4] = 0;
    }
    return out.ptr;
}

test "predictPartyVictory" {
    const r1 = predictPartyVictory(@constCast("RD"));
    try std.testing.expectEqualStrings("Radiant", std.mem.span(@as([*:0]u8, @ptrCast(r1))));
    const r2 = predictPartyVictory(@constCast("RDD"));
    try std.testing.expectEqualStrings("Dire", std.mem.span(@as([*:0]u8, @ptrCast(r2))));
    const r3 = predictPartyVictory(@constCast("DDRRR"));
    try std.testing.expectEqualStrings("Dire", std.mem.span(@as([*:0]u8, @ptrCast(r3))));
    const r4 = predictPartyVictory(@constCast("DRRDRDRDRDDRDRDR"));
    try std.testing.expectEqualStrings("Radiant", std.mem.span(@as([*:0]u8, @ptrCast(r4))));
    const r5 = predictPartyVictory(@constCast("RRRR"));
    try std.testing.expectEqualStrings("Radiant", std.mem.span(@as([*:0]u8, @ptrCast(r5))));
}
