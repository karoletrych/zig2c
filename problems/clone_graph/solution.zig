// LeetCode 133. Clone Graph
// C signature:  struct Node* cloneGraph(struct Node* node);
//   struct Node { int val; int numNeighbors; struct Node** neighbors; };
//
// Breadth-first copy. `map` maps an original node's value to its clone (the
// constraints guarantee `node.val == index`, but the value is used as the key
// anyway so it also works for arbitrary labels). Every original node is visited
// once; its clone's neighbour array is filled slot by slot.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const Node = struct {
    val: i32,
    numNeighbors: i32,
    neighbors: [*]?*Node,
};

fn makeNode(val: i32, n: i32) *Node {
    const node = allocator.create(Node) catch unreachable;
    node.val = val;
    node.numNeighbors = n;
    var cap: usize = 1;
    if (n > 0) cap = @intCast(n);
    const nb = allocator.alloc(?*Node, cap) catch unreachable;
    var i: usize = 0;
    while (i < cap) : (i += 1) nb[i] = null;
    node.neighbors = nb.ptr;
    return node;
}

pub fn cloneGraph(node: ?*Node) ?*Node {
    if (node == null) return null;

    var map = std.AutoHashMap(i32, *Node).init(allocator);
    defer map.deinit();

    var queue: std.ArrayList(*Node) = .empty;
    defer queue.deinit(allocator);

    const rootCopy = makeNode(node.?.val, node.?.numNeighbors);
    map.put(node.?.val, rootCopy) catch unreachable;
    queue.append(allocator, node.?) catch unreachable;

    var i: usize = 0;
    while (i < queue.items.len) : (i += 1) {
        const cur = queue.items[i];
        const copy = map.get(cur.val).?;
        var j: i32 = 0;
        while (j < cur.numNeighbors) : (j += 1) {
            const nb = cur.neighbors[@intCast(j)].?;
            if (!map.contains(nb.val)) {
                const ncopy = makeNode(nb.val, nb.numNeighbors);
                map.put(nb.val, ncopy) catch unreachable;
                queue.append(allocator, nb) catch unreachable;
            }
            copy.neighbors[@intCast(j)] = map.get(nb.val).?;
        }
    }
    return rootCopy;
}

fn neighVal(n: *Node, i: i32) i32 {
    return n.neighbors[@intCast(i)].?.val;
}

test "cloneGraph example" {
    const n1 = makeNode(1, 2);
    const n2 = makeNode(2, 2);
    const n3 = makeNode(3, 2);
    const n4 = makeNode(4, 2);
    n1.neighbors[0] = n2;
    n1.neighbors[1] = n4;
    n2.neighbors[0] = n1;
    n2.neighbors[1] = n3;
    n3.neighbors[0] = n2;
    n3.neighbors[1] = n4;
    n4.neighbors[0] = n1;
    n4.neighbors[1] = n3;

    const cp = cloneGraph(n1).?;
    try std.testing.expect(cp != n1);
    try std.testing.expectEqual(@as(i32, 1), cp.val);
    try std.testing.expectEqual(@as(i32, 2), cp.numNeighbors);
    try std.testing.expectEqual(@as(i32, 2), neighVal(cp, 0));
    try std.testing.expectEqual(@as(i32, 4), neighVal(cp, 1));
    try std.testing.expect(cp.neighbors[0].? != n2);

    const c2 = cp.neighbors[0].?;
    const c4 = cp.neighbors[1].?;
    try std.testing.expectEqual(@as(i32, 2), c2.val);
    try std.testing.expectEqual(@as(i32, 1), neighVal(c2, 0));
    try std.testing.expectEqual(@as(i32, 3), neighVal(c2, 1));
    try std.testing.expectEqual(@as(i32, 4), c4.val);
    try std.testing.expectEqual(@as(i32, 1), neighVal(c4, 0));
    try std.testing.expectEqual(@as(i32, 3), neighVal(c4, 1));
    // the clone is a distinct graph: the two neighbours share the third node
    try std.testing.expect(c2.neighbors[1].? == c4.neighbors[1].?);
    // and the original graph is untouched
    try std.testing.expectEqual(@as(i32, 2), neighVal(n1, 0));
    try std.testing.expectEqual(@as(i32, 4), neighVal(n1, 1));
}

test "cloneGraph edges" {
    try std.testing.expect(cloneGraph(null) == null);

    const solo = makeNode(1, 0);
    const cp = cloneGraph(solo).?;
    try std.testing.expectEqual(@as(i32, 1), cp.val);
    try std.testing.expectEqual(@as(i32, 0), cp.numNeighbors);
    try std.testing.expect(cp != solo);

    // a two-node cycle
    const a = makeNode(1, 1);
    const b = makeNode(2, 1);
    a.neighbors[0] = b;
    b.neighbors[0] = a;
    const ca = cloneGraph(a).?;
    try std.testing.expectEqual(@as(i32, 1), ca.val);
    try std.testing.expectEqual(@as(i32, 2), ca.neighbors[0].?.val);
    try std.testing.expect(ca.neighbors[0].?.neighbors[0].? == ca);
}
