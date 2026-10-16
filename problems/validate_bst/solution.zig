// LeetCode 98. Validate Binary Search Tree
// C signature:  bool isValidBST(struct TreeNode* root);
//
// A BST is valid exactly when its in-order traversal is strictly increasing.
// `has` distinguishes "no previous value yet" from a real previous value, so no
// sentinel (and no 64-bit bounds) are needed.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

fn inorder(node: ?*TreeNode, prev: *i32, has: *bool, ok: *bool) void {
    if (node == null) return;
    inorder(node.?.left, prev, has, ok);
    if (!ok.*) return;
    const v = node.?.val;
    if (has.* and v <= prev.*) {
        ok.* = false;
        return;
    }
    prev.* = v;
    has.* = true;
    inorder(node.?.right, prev, has, ok);
}

pub fn isValidBST(root: ?*TreeNode) bool {
    var prev: i32 = 0;
    var has = false;
    var ok = true;
    inorder(root, &prev, &has, &ok);
    return ok;
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "isValidBST examples" {
    // [2,1,3] -> true
    try std.testing.expect(isValidBST(mk(2, mk(1, null, null), mk(3, null, null))));

    // [5,1,4,null,null,3,6] -> false (3 is in the right subtree of 5)
    const bad = mk(5, mk(1, null, null), mk(4, mk(3, null, null), mk(6, null, null)));
    try std.testing.expect(!isValidBST(bad));
}

test "isValidBST edges" {
    // empty tree is a valid BST
    try std.testing.expect(isValidBST(null));
    // single node, extremes included
    try std.testing.expect(isValidBST(mk(1, null, null)));
    try std.testing.expect(isValidBST(mk(2147483647, null, null)));
    try std.testing.expect(isValidBST(mk(-2147483648, null, null)));

    // duplicates are not allowed
    try std.testing.expect(!isValidBST(mk(1, mk(1, null, null), null)));
    try std.testing.expect(!isValidBST(mk(2, mk(1, null, null), mk(2, null, null))));

    // the violation is deep in the right subtree
    const deep = mk(10, mk(5, null, null), mk(15, mk(6, null, null), mk(20, null, null)));
    try std.testing.expect(!isValidBST(deep));

    // skewed but valid
    try std.testing.expect(isValidBST(mk(1, null, mk(2, null, mk(3, null, null)))));
    try std.testing.expect(isValidBST(mk(3, mk(2, mk(1, null, null), null), null)));

    // skewed but invalid: a decreasing right chain
    try std.testing.expect(!isValidBST(mk(3, null, mk(2, null, mk(1, null, null)))));
    // invalid because 4 sits in the left subtree of 3
    try std.testing.expect(!isValidBST(mk(3, mk(2, mk(4, null, null), null), null)));
}
