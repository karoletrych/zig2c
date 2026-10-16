// LeetCode 101. Symmetric Tree
// C signature:  bool isSymmetric(struct TreeNode* root);
//
// A tree is symmetric when its left and right subtrees are mirror images:
// equal roots and crosswise-matching children.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

fn mirror(a: ?*TreeNode, b: ?*TreeNode) bool {
    if (a == null and b == null) return true;
    if (a == null or b == null) return false;
    if (a.?.val != b.?.val) return false;
    return mirror(a.?.left, b.?.right) and mirror(a.?.right, b.?.left);
}

pub fn isSymmetric(root: ?*TreeNode) bool {
    if (root == null) return true;
    return mirror(root.?.left, root.?.right);
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "isSymmetric example" {
    const a = mk(1, mk(2, mk(3, null, null), mk(4, null, null)), mk(2, mk(4, null, null), mk(3, null, null)));
    try std.testing.expectEqual(true, isSymmetric(a));

    const b = mk(1, mk(2, null, mk(3, null, null)), mk(2, null, mk(3, null, null)));
    try std.testing.expectEqual(false, isSymmetric(b));
}

test "isSymmetric edges" {
    // empty and single node
    try std.testing.expectEqual(true, isSymmetric(null));
    try std.testing.expectEqual(true, isSymmetric(mk(1, null, null)));

    // only one child
    try std.testing.expectEqual(false, isSymmetric(mk(1, mk(2, null, null), null)));
    try std.testing.expectEqual(false, isSymmetric(mk(1, null, mk(2, null, null))));

    // one value differs
    try std.testing.expectEqual(false, isSymmetric(mk(1, mk(2, null, null), mk(3, null, null))));

    // mirrored but different values deep down
    const c = mk(1, mk(2, mk(5, null, null), mk(3, null, null)), mk(2, mk(3, null, null), mk(5, null, null)));
    try std.testing.expectEqual(true, isSymmetric(c));

    // deep asymmetric leaf
    const d = mk(1, mk(2, mk(5, null, null), mk(3, null, null)), mk(2, mk(3, null, null), mk(4, null, null)));
    try std.testing.expectEqual(false, isSymmetric(d));

    // negative values, symmetric
    const e = mk(-1, mk(-2, null, null), mk(-2, null, null));
    try std.testing.expectEqual(true, isSymmetric(e));
}
