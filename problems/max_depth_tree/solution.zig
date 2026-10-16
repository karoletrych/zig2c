// LeetCode 104. Maximum Depth of Binary Tree
// C signature:  int maxDepth(struct TreeNode* root);
//
// LeetCode's C harness already defines `struct TreeNode`. zig2c therefore emits
// only a typedef for it in the submission and hides the body behind ZIG2C_LOCAL
// (which the local test driver turns on).
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

pub fn maxDepth(root: ?*TreeNode) i32 {
    if (root == null) return 0;
    const l = maxDepth(root.?.left);
    const r = maxDepth(root.?.right);
    return 1 + @max(l, r);
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "maxDepth" {
    const t = mk(3, mk(9, null, null), mk(20, mk(15, null, null), mk(7, null, null)));
    try std.testing.expectEqual(@as(i32, 3), maxDepth(t));
    try std.testing.expectEqual(@as(i32, 0), maxDepth(null));
    const one = mk(1, null, mk(2, null, null));
    try std.testing.expectEqual(@as(i32, 2), maxDepth(one));
}
