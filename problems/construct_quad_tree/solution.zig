// LeetCode 427. Construct Quad Tree
// C signature:  struct Node* construct(int** grid, int gridSize, int* gridColSize);
//
// The grid is n x n and n is a power of two. A block becomes a leaf when all of
// its cells are equal, otherwise it is split into four quadrants of size n/2.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const Node = struct {
    val: bool,
    isLeaf: bool,
    topLeft: ?*Node,
    topRight: ?*Node,
    bottomLeft: ?*Node,
    bottomRight: ?*Node,
};

fn allSame(grid: [*][*]i32, r0: i32, c0: i32, n: i32, v: *i32) bool {
    const first = grid[@intCast(r0)][@intCast(c0)];
    v.* = first;
    var r = r0;
    while (r < r0 + n) : (r += 1) {
        var c = c0;
        while (c < c0 + n) : (c += 1) {
            if (grid[@intCast(r)][@intCast(c)] != first) return false;
        }
    }
    return true;
}

fn build(grid: [*][*]i32, r0: i32, c0: i32, n: i32) ?*Node {
    var v: i32 = 0;
    const node = allocator.create(Node) catch unreachable;
    if (allSame(grid, r0, c0, n, &v)) {
        node.val = v != 0;
        node.isLeaf = true;
        node.topLeft = null;
        node.topRight = null;
        node.bottomLeft = null;
        node.bottomRight = null;
        return node;
    }
    const half = @divTrunc(n, 2);
    node.val = true; // internal nodes conventionally carry val = true
    node.isLeaf = false;
    node.topLeft = build(grid, r0, c0, half);
    node.topRight = build(grid, r0, c0 + half, half);
    node.bottomLeft = build(grid, r0 + half, c0, half);
    node.bottomRight = build(grid, r0 + half, c0 + half, half);
    return node;
}

pub fn construct(grid: [*][*]i32, gridSize: i32, gridColSize: [*]i32) ?*Node {
    _ = gridColSize;
    if (gridSize <= 0) return null;
    return build(grid, 0, 0, gridSize);
}

test "construct example" {
    // [[0,1],[1,0]] -> one internal node with four leaf children
    var r0 = [_]i32{ 0, 1 };
    var r1 = [_]i32{ 1, 0 };
    var g = [_][*]i32{ &r0, &r1 };
    var cols = [_]i32{ 2, 2 };

    const q = construct(&g, 2, &cols).?;
    try std.testing.expect(!q.isLeaf);
    try std.testing.expect(q.val);
    try std.testing.expect(q.topLeft.?.isLeaf and q.topLeft.?.val == false);
    try std.testing.expect(q.topRight.?.isLeaf and q.topRight.?.val == true);
    try std.testing.expect(q.bottomLeft.?.isLeaf and q.bottomLeft.?.val == true);
    try std.testing.expect(q.bottomRight.?.isLeaf and q.bottomRight.?.val == false);
    try std.testing.expect(q.topLeft.?.topLeft == null);
    try std.testing.expect(q.bottomRight.?.bottomRight == null);
}

test "construct uniform grid" {
    // all ones -> a single leaf
    var r0 = [_]i32{ 1, 1 };
    var r1 = [_]i32{ 1, 1 };
    var g = [_][*]i32{ &r0, &r1 };
    var cols = [_]i32{ 2, 2 };
    const q = construct(&g, 2, &cols).?;
    try std.testing.expect(q.isLeaf);
    try std.testing.expect(q.val);
    try std.testing.expect(q.topLeft == null and q.topRight == null and q.bottomLeft == null and q.bottomRight == null);

    // all zeros -> a single leaf with val == false
    var z0 = [_]i32{ 0, 0 };
    var z1 = [_]i32{ 0, 0 };
    var gz = [_][*]i32{ &z0, &z1 };
    var cz = [_]i32{ 2, 2 };
    const qz = construct(&gz, 2, &cz).?;
    try std.testing.expect(qz.isLeaf);
    try std.testing.expect(!qz.val);
}

test "construct 4x4 quadrants" {
    var r0 = [_]i32{ 1, 1, 0, 0 };
    var r1 = [_]i32{ 1, 1, 0, 0 };
    var r2 = [_]i32{ 0, 0, 1, 1 };
    var r3 = [_]i32{ 0, 0, 1, 1 };
    var g = [_][*]i32{ &r0, &r1, &r2, &r3 };
    var cols = [_]i32{ 4, 4, 4, 4 };
    const q = construct(&g, 4, &cols).?;
    try std.testing.expect(!q.isLeaf);
    try std.testing.expect(q.topLeft.?.isLeaf and q.topLeft.?.val);
    try std.testing.expect(q.topRight.?.isLeaf and !q.topRight.?.val);
    try std.testing.expect(q.bottomLeft.?.isLeaf and !q.bottomLeft.?.val);
    try std.testing.expect(q.bottomRight.?.isLeaf and q.bottomRight.?.val);

    // a single 1x1 grid is always a leaf
    var s0 = [_]i32{1};
    var sg = [_][*]i32{&s0};
    var sc = [_]i32{1};
    const sq = construct(&sg, 1, &sc).?;
    try std.testing.expect(sq.isLeaf and sq.val);

    // empty grid
    try std.testing.expect(construct(undefined, 0, undefined) == null);
}
