// LeetCode 222. Count Complete Tree Nodes
// C signature:  int countNodes(struct TreeNode* root);
//
// A complete tree has all levels full except possibly the last, which is filled
// left to right. Let `h` be the height (following left children) and `rh` the
// height of the right subtree:
//   * rh == h - 1  => the left subtree is a perfect tree of height h-1,
//                     so it contributes 2^(h-1) - 1 nodes;
//   * otherwise the right subtree is perfect of height h-2 (or empty) and
//                     contributes 2^(h-2) - 1 nodes.
// Either way one full subtree is counted in O(1) and the recursion follows the
// other one, doing O(h) height probes per level => O(log^2 n).
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

fn leftHeight(node: ?*TreeNode) i32 {
    var h: i32 = 0;
    var cur = node;
    while (cur) |c| {
        h += 1;
        cur = c.left;
    }
    return h;
}

fn pow2(e: i32) i32 {
    var p: i32 = 1;
    var i: i32 = 0;
    while (i < e) : (i += 1) p *= 2;
    return p;
}

pub fn countNodes(root: ?*TreeNode) i32 {
    if (root == null) return 0;
    const h = leftHeight(root);
    const rh = leftHeight(root.?.right);
    if (rh == h - 1) {
        // 2^(h-1) - 1 (perfect left) + 1 (root) = 2^(h-1)
        return pow2(h - 1) + countNodes(root.?.right);
    }
    // 2^(h-2) - 1 (perfect right) + 1 (root) = 2^(h-2)
    return pow2(h - 2) + countNodes(root.?.left);
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

// A complete tree of `n` nodes, numbered 1..n in level order.
fn buildComplete(n: i32, idx: i32) ?*TreeNode {
    if (idx > n) return null;
    const node = allocator.create(TreeNode) catch unreachable;
    node.val = idx;
    node.left = buildComplete(n, idx * 2);
    node.right = buildComplete(n, idx * 2 + 1);
    return node;
}

test "countNodes examples" {
    // [1,2,3,4,5,6] -> 6
    const t = mk(1, mk(2, mk(4, null, null), mk(5, null, null)), mk(3, mk(6, null, null), null));
    try std.testing.expectEqual(@as(i32, 6), countNodes(t));

    // empty tree
    try std.testing.expectEqual(@as(i32, 0), countNodes(null));

    // single node
    try std.testing.expectEqual(@as(i32, 1), countNodes(mk(1, null, null)));
}

test "countNodes every complete tree size" {
    // For every n the complete tree has exactly n nodes; this exercises both
    // branches of the recursion (empty / full last level, partial last level).
    var n: i32 = 0;
    while (n <= 40) : (n += 1) {
        try std.testing.expectEqual(n, countNodes(buildComplete(n, 1)));
    }
    // a perfect tree of height 5
    try std.testing.expectEqual(@as(i32, 31), countNodes(buildComplete(31, 1)));
}
