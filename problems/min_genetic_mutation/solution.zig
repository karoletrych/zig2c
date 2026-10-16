// LeetCode 433. Minimum Genetic Mutation
// C signature:  int minMutation(char* startGene, char* endGene, char** bank,
//                               int bankSize);
//
// Breadth-first search over the bank. Two genes are one mutation apart iff they
// differ in exactly one position; a generation is one BFS level.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn diffOne(a: []u8, b: []u8) bool {
    if (a.len != b.len) return false;
    var d: i32 = 0;
    var i: usize = 0;
    while (i < a.len) : (i += 1) {
        if (a[i] != b[i]) d += 1;
    }
    return d == 1;
}

pub fn minMutation(startGene: [*]u8, endGene: [*]u8, bank: [*][*]u8, bankSize: i32) i32 {
    const s = std.mem.sliceTo(startGene, 0);
    const e = std.mem.sliceTo(endGene, 0);
    if (std.mem.eql(u8, s, e)) return 0;

    const n: usize = @intCast(bankSize);
    var endIdx: i32 = -1;
    var i: usize = 0;
    while (i < n) : (i += 1) {
        if (std.mem.eql(u8, std.mem.sliceTo(bank[i], 0), e)) endIdx = @intCast(i);
    }
    if (endIdx == -1) return -1;

    const dist = allocator.alloc(i32, n) catch unreachable;
    defer allocator.free(dist);
    i = 0;
    while (i < n) : (i += 1) dist[i] = -1;

    const q = allocator.alloc(i32, n + 1) catch unreachable;
    defer allocator.free(q);

    var qh: usize = 0;
    var qt: usize = 0;
    i = 0;
    while (i < n) : (i += 1) {
        if (diffOne(s, std.mem.sliceTo(bank[i], 0))) {
            dist[i] = 1;
            q[qt] = @intCast(i);
            qt += 1;
        }
    }

    const target: usize = @intCast(endIdx);
    while (qh < qt) {
        const u: usize = @intCast(q[qh]);
        qh += 1;
        if (u == target) return dist[u];
        const cur = std.mem.sliceTo(bank[u], 0);
        i = 0;
        while (i < n) : (i += 1) {
            if (dist[i] == -1 and diffOne(cur, std.mem.sliceTo(bank[i], 0))) {
                dist[i] = dist[u] + 1;
                q[qt] = @intCast(i);
                qt += 1;
            }
        }
    }
    return -1;
}

test "minMutation examples" {
    var b0 = [_][*]u8{@constCast("AACCGGTA")};
    try std.testing.expectEqual(@as(i32, 1), minMutation(@constCast("AACCGGTT"), @constCast("AACCGGTA"), &b0, 1));

    var b1 = [_][*]u8{ @constCast("AACCGGTA"), @constCast("AACCGCTA"), @constCast("AAACGGTA") };
    try std.testing.expectEqual(@as(i32, 2), minMutation(@constCast("AACCGGTT"), @constCast("AAACGGTA"), &b1, 3));

    var b2 = [_][*]u8{ @constCast("AAAACCCC"), @constCast("AAACCCCC"), @constCast("AACCCCCC") };
    try std.testing.expectEqual(@as(i32, 3), minMutation(@constCast("AAAAACCC"), @constCast("AACCCCCC"), &b2, 3));
}

test "minMutation edges" {
    // target gene missing from the bank
    var b0 = [_][*]u8{@constCast("AACCGGTA")};
    try std.testing.expectEqual(@as(i32, -1), minMutation(@constCast("AACCGGTT"), @constCast("AACCGGTC"), &b0, 1));

    // empty bank
    var empty = [_][*]u8{undefined};
    try std.testing.expectEqual(@as(i32, -1), minMutation(@constCast("AACCGGTT"), @constCast("AACCGGTA"), &empty, 0));

    // already there
    try std.testing.expectEqual(@as(i32, 0), minMutation(@constCast("AACCGGTT"), @constCast("AACCGGTT"), &empty, 0));

    // unreachable: the target needs 8 mutations and no intermediate exists
    var b1 = [_][*]u8{@constCast("CCCCCCCC")};
    try std.testing.expectEqual(@as(i32, -1), minMutation(@constCast("AAAAAAAA"), @constCast("CCCCCCCC"), &b1, 1));

    // a longer path through the bank
    var b2 = [_][*]u8{
        @constCast("AACCGGTA"),
        @constCast("AACCGGTC"),
        @constCast("AACCGGCC"),
        @constCast("AACCGCCC"),
    };
    try std.testing.expectEqual(@as(i32, 3), minMutation(@constCast("AACCGGTT"), @constCast("AACCGCCC"), &b2, 4));
}
