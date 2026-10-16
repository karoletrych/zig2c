// LeetCode 124. Binary Tree Maximum Path Sum
// C signature:  int maxPathSum(struct TreeNode* root);
//
// `gain` returns the best downward path starting at a node (clamped at 0 so a
// negative branch is simply not taken). The best "arch" through a node is
// val + left-gain + right-gain, which is the candidate answer.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

fn gain(node: ?*TreeNode, best: *i32) i32 {
    if (node == null) return 0;
    const n = node.?;
    var l = gain(n.left, best);
    if (l < 0) l = 0;
    var r = gain(n.right, best);
    if (r < 0) r = 0;
    const through = n.val + l + r;
    if (through > best.*) best.* = through;
    return n.val + @max(l, r);
}

pub fn maxPathSum(root: ?*TreeNode) i32 {
    // Every node value is at least -1000 and a path is a subset of the nodes,
    // so -10^9 is a safe lower bound for the answer.
    var best: i32 = -1000000000;
    _ = gain(root, &best);
    return best;
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "maxPathSum examples" {
    try std.testing.expectEqual(@as(i32, 6), maxPathSum(mk(1, mk(2, null, null), mk(3, null, null))));
    const t = mk(-10, mk(9, null, null), mk(20, mk(15, null, null), mk(7, null, null)));
    try std.testing.expectEqual(@as(i32, 42), maxPathSum(t));
}

test "maxPathSum edges" {
    // single node, even when negative
    try std.testing.expectEqual(@as(i32, -3), maxPathSum(mk(-3, null, null)));
    try std.testing.expectEqual(@as(i32, 0), maxPathSum(mk(0, null, null)));

    // the best path may avoid a negative child
    try std.testing.expectEqual(@as(i32, 2), maxPathSum(mk(2, mk(-1, null, null), null)));
    try std.testing.expectEqual(@as(i32, -1), maxPathSum(mk(-2, mk(-1, null, null), null)));
    try std.testing.expectEqual(@as(i32, 1), maxPathSum(mk(1, mk(-2, null, null), mk(-3, null, null))));

    // a path that climbs out of the left subtree through the root
    const t = mk(1, mk(2, mk(4, null, null), null), mk(3, null, null));
    try std.testing.expectEqual(@as(i32, 10), maxPathSum(t)); // 4+2+1+3

    // left-skewed all positive chain: the whole chain
    const sk = mk(1, mk(2, mk(3, null, null), null), null);
    try std.testing.expectEqual(@as(i32, 6), maxPathSum(sk));

    // negative root with a big positive subtree
    const neg = mk(-5, mk(10, mk(4, null, null), mk(3, null, null)), mk(-1, null, null));
    try std.testing.expectEqual(@as(i32, 17), maxPathSum(neg)); // 4+10+3
}
