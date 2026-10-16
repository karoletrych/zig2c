// LeetCode 226. Invert Binary Tree
// C signature:  struct TreeNode* invertTree(struct TreeNode* root);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

pub fn invertTree(root: ?*TreeNode) ?*TreeNode {
    if (root == null) return null;
    const l = invertTree(root.?.left);
    const r = invertTree(root.?.right);
    root.?.left = r;
    root.?.right = l;
    return root;
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

// Test-only structural comparison (only reachable from tests).
fn sameShape(a: ?*TreeNode, b: ?*TreeNode) bool {
    if (a == null and b == null) return true;
    if (a == null or b == null) return false;
    if (a.?.val != b.?.val) return false;
    return sameShape(a.?.left, b.?.left) and sameShape(a.?.right, b.?.right);
}

test "invertTree example" {
    const got = invertTree(mk(4, mk(2, mk(1, null, null), mk(3, null, null)), mk(7, mk(6, null, null), mk(9, null, null))));
    const want = mk(4, mk(7, mk(9, null, null), mk(6, null, null)), mk(2, mk(3, null, null), mk(1, null, null)));
    try std.testing.expect(sameShape(got, want));
}

test "invertTree edges" {
    try std.testing.expect(invertTree(null) == null);

    // single node
    const solo = invertTree(mk(1, null, null));
    try std.testing.expectEqual(@as(i32, 1), solo.?.val);
    try std.testing.expect(solo.?.left == null and solo.?.right == null);

    // only a left child becomes only a right child
    const l = invertTree(mk(1, mk(2, null, null), null));
    try std.testing.expect(l.?.left == null);
    try std.testing.expectEqual(@as(i32, 2), l.?.right.?.val);

    // only a right child becomes only a left child
    const r = invertTree(mk(1, null, mk(2, null, null)));
    try std.testing.expect(r.?.right == null);
    try std.testing.expectEqual(@as(i32, 2), r.?.left.?.val);

    // inverting twice restores the original
    const orig = mk(5, mk(3, mk(2, null, null), mk(4, null, null)), mk(8, mk(7, null, null), mk(9, null, null)));
    const twice = invertTree(invertTree(orig));
    try std.testing.expect(sameShape(twice, orig));

    // negative values
    const neg = invertTree(mk(-1, mk(-2, null, null), mk(-3, null, null)));
    try std.testing.expectEqual(@as(i32, -3), neg.?.left.?.val);
    try std.testing.expectEqual(@as(i32, -2), neg.?.right.?.val);
}
