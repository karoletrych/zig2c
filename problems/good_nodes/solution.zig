// LeetCode 1448. Count Good Nodes in Binary Tree  (LeetCode 75)
// C signature:  int goodNodes(struct TreeNode* root);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

fn goodCount(node: ?*TreeNode, maxv: i32) i32 {
    if (node == null) return 0;
    var c: i32 = 0;
    if (node.?.val >= maxv) c = 1;
    const m = @max(maxv, node.?.val);
    return c + goodCount(node.?.left, m) + goodCount(node.?.right, m);
}

pub fn goodNodes(root: ?*TreeNode) i32 {
    if (root == null) return 0;
    return goodCount(root, -1000000000);
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "goodNodes" {
    // [3,1,4,3,null,1,5] -> 4
    const t = mk(3, mk(1, mk(3, null, null), null), mk(4, mk(1, null, null), mk(5, null, null)));
    try std.testing.expectEqual(@as(i32, 4), goodNodes(t));

    // [3,3,null,4,2] -> 3
    const t2 = mk(3, mk(3, mk(4, null, null), mk(2, null, null)), null);
    try std.testing.expectEqual(@as(i32, 3), goodNodes(t2));

    // [1] -> 1
    try std.testing.expectEqual(@as(i32, 1), goodNodes(mk(1, null, null)));

    // null -> 0
    try std.testing.expectEqual(@as(i32, 0), goodNodes(null));

    // decreasing chain [5,4,3] -> only root good
    try std.testing.expectEqual(@as(i32, 1), goodNodes(mk(5, mk(4, mk(3, null, null), null), null)));
}
