// LeetCode 236. Lowest Common Ancestor of a Binary Tree
// C signature:  struct TreeNode* lowestCommonAncestor(struct TreeNode* root, struct TreeNode* p, struct TreeNode* q);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

fn find(node: ?*TreeNode, p: *TreeNode, q: *TreeNode) ?*TreeNode {
    if (node == null) return null;
    if (node.? == p or node.? == q) return node;
    const l = find(node.?.left, p, q);
    const r = find(node.?.right, p, q);
    if (l != null and r != null) return node;
    if (l != null) return l;
    return r;
}

pub fn lowestCommonAncestor(root: ?*TreeNode, p: ?*TreeNode, q: ?*TreeNode) ?*TreeNode {
    if (root == null or p == null or q == null) return null;
    return find(root, p.?, q.?);
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "lowestCommonAncestor" {
    // [3,5,1,6,2,0,8,null,null,7,4]
    const n5 = mk(5, mk(6, null, null), mk(2, mk(7, null, null), mk(4, null, null)));
    const n1 = mk(1, mk(0, null, null), mk(8, null, null));
    const t = mk(3, n5, n1);

    // p=5, q=1 -> 3
    try std.testing.expectEqual(t, lowestCommonAncestor(t, n5, n1));
    // p=5, q=4 -> 5
    const n4 = n5.?.right.?.right;
    try std.testing.expectEqual(n5, lowestCommonAncestor(t, n5, n4));
    // p=7, q=4 -> 2
    const n7 = n5.?.right.?.left;
    const n2 = n5.?.right;
    try std.testing.expectEqual(n2, lowestCommonAncestor(t, n7, n4));

    // [1,2], p=1, q=2 -> 1
    const s2 = mk(2, null, null);
    const s = mk(1, s2, null);
    try std.testing.expectEqual(s, lowestCommonAncestor(s, s, s2));

    // same node twice
    try std.testing.expectEqual(t, lowestCommonAncestor(t, t, t));
    // null tree
    try std.testing.expect(lowestCommonAncestor(null, n5, n1) == null);
}
