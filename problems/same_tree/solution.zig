// LeetCode 100. Same Tree
// C signature:  bool isSameTree(struct TreeNode* p, struct TreeNode* q);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

pub fn isSameTree(p: ?*TreeNode, q: ?*TreeNode) bool {
    if (p == null and q == null) return true;
    if (p == null or q == null) return false;
    if (p.?.val != q.?.val) return false;
    return isSameTree(p.?.left, q.?.left) and isSameTree(p.?.right, q.?.right);
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "isSameTree example" {
    const a = mk(1, mk(2, null, null), mk(3, null, null));
    const b = mk(1, mk(2, null, null), mk(3, null, null));
    try std.testing.expectEqual(true, isSameTree(a, b));

    const c = mk(1, mk(2, null, null), null);
    const d = mk(1, null, mk(2, null, null));
    try std.testing.expectEqual(false, isSameTree(c, d));

    const e = mk(1, mk(2, null, null), mk(1, null, null));
    const f = mk(1, mk(1, null, null), mk(2, null, null));
    try std.testing.expectEqual(false, isSameTree(e, f));
}

test "isSameTree edges" {
    try std.testing.expectEqual(true, isSameTree(null, null));
    try std.testing.expectEqual(false, isSameTree(null, mk(1, null, null)));
    try std.testing.expectEqual(false, isSameTree(mk(1, null, null), null));
    try std.testing.expectEqual(true, isSameTree(mk(7, null, null), mk(7, null, null)));
    try std.testing.expectEqual(false, isSameTree(mk(7, null, null), mk(-7, null, null)));
    // same values but one subtree deeper
    const deep = mk(1, mk(2, mk(4, null, null), null), mk(3, null, null));
    const shallow = mk(1, mk(2, null, null), mk(3, null, null));
    try std.testing.expectEqual(false, isSameTree(deep, shallow));
    // a tree is the same as itself
    try std.testing.expectEqual(true, isSameTree(deep, deep));
}
