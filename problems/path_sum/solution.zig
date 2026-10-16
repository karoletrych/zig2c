// LeetCode 112. Path Sum
// C signature:  bool hasPathSum(struct TreeNode* root, int targetSum);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

pub fn hasPathSum(root: ?*TreeNode, targetSum: i32) bool {
    if (root == null) return false;
    const r = root.?;
    if (r.left == null and r.right == null) return r.val == targetSum;
    return hasPathSum(r.left, targetSum - r.val) or hasPathSum(r.right, targetSum - r.val);
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "hasPathSum example" {
    // [5,4,8,11,null,13,4,7,2,null,null,null,1]
    const t = mk(5, mk(4, mk(11, mk(7, null, null), mk(2, null, null)), null), mk(8, mk(13, null, null), mk(4, null, mk(1, null, null))));
    try std.testing.expect(hasPathSum(t, 22)); // 5+4+11+2
    try std.testing.expect(hasPathSum(t, 27)); // 5+4+11+7
    try std.testing.expect(hasPathSum(t, 26)); // 5+8+13
    try std.testing.expect(hasPathSum(t, 18)); // 5+8+4+1
    try std.testing.expect(!hasPathSum(t, 1));
    try std.testing.expect(!hasPathSum(t, 100));
}

test "hasPathSum edges" {
    try std.testing.expect(!hasPathSum(null, 0));
    try std.testing.expect(!hasPathSum(null, 5));

    // a single node is a root-to-leaf path
    try std.testing.expect(hasPathSum(mk(1, null, null), 1));
    try std.testing.expect(!hasPathSum(mk(1, null, null), 0));
    try std.testing.expect(hasPathSum(mk(0, null, null), 0));

    // an internal node is not a leaf, so a partial sum must not match
    const two = mk(1, mk(2, null, null), null);
    try std.testing.expect(hasPathSum(two, 3));
    try std.testing.expect(!hasPathSum(two, 1));

    // negative values
    try std.testing.expect(hasPathSum(mk(-2, null, mk(-3, null, null)), -5));

    // left-skewed chain
    const sk = mk(1, mk(2, mk(3, null, null), null), null);
    try std.testing.expect(hasPathSum(sk, 6));
    try std.testing.expect(!hasPathSum(sk, 5));
}
