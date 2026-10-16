// LeetCode 117. Populating Next Right Pointers in Each Node II
// C signature:  struct Node* connect(struct Node* root);
//
// The tree is general (not necessarily perfect). Because each level is threaded
// before the next one is processed, the level below can be walked through the
// `next` chain of the level above, so no queue and no extra memory is needed.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const Node = struct {
    val: i32,
    left: ?*Node,
    right: ?*Node,
    next: ?*Node,
};

pub fn connect(root: ?*Node) ?*Node {
    if (root == null) return null;
    var leftmost: ?*Node = root;
    while (leftmost) |lm| {
        var head: ?*Node = null;
        var prev: ?*Node = null;
        var cur: ?*Node = lm;
        while (cur) |c| {
            if (c.left) |l| {
                if (prev) |p| {
                    p.next = l;
                } else {
                    head = l;
                }
                prev = l;
            }
            if (c.right) |r| {
                if (prev) |p| {
                    p.next = r;
                } else {
                    head = r;
                }
                prev = r;
            }
            cur = c.next;
        }
        leftmost = head;
    }
    return root;
}

fn mk(v: i32, l: ?*Node, r: ?*Node) *Node {
    const n = allocator.create(Node) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    n.next = null;
    return n;
}

test "connect example" {
    // [1,2,3,4,5,null,7]
    const four = mk(4, null, null);
    const five = mk(5, null, null);
    const seven = mk(7, null, null);
    const two = mk(2, four, five);
    const three = mk(3, null, seven);
    const one = mk(1, two, three);

    const r = connect(one).?;
    try std.testing.expect(r == one);
    try std.testing.expect(r.next == null);
    try std.testing.expect(r.left.?.next == r.right);
    try std.testing.expect(r.right.?.next == null);
    try std.testing.expect(r.left.?.left.?.next == r.left.?.right);
    try std.testing.expect(r.left.?.right.?.next == r.right.?.right);
    try std.testing.expect(r.right.?.right.?.next == null);
}

test "connect edges" {
    try std.testing.expect(connect(null) == null);

    const solo = mk(9, null, null);
    const rs = connect(solo).?;
    try std.testing.expect(rs.next == null);

    // left-skewed: 1 -> 2 -> 3, every next stays null
    const n3 = mk(3, null, null);
    const n2 = mk(2, n3, null);
    const n1 = mk(1, n2, null);
    _ = connect(n1);
    try std.testing.expect(n1.next == null);
    try std.testing.expect(n2.next == null);
    try std.testing.expect(n3.next == null);

    // right child of the left subtree links to the left child of the right one:
    //        1
    //      /   \
    //     2     3
    //    /     /
    //   4     6
    const c4 = mk(4, null, null);
    const c6 = mk(6, null, null);
    const b2 = mk(2, c4, null);
    const b3 = mk(3, c6, null);
    const b1 = mk(1, b2, b3);
    _ = connect(b1);
    try std.testing.expect(b2.next == b3);
    try std.testing.expect(c4.next == c6);
    try std.testing.expect(c6.next == null);
}
