// LeetCode 700. Search in a Binary Search Tree
// C signature:  struct TreeNode* searchBST(struct TreeNode* root, int val);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

pub fn searchBST(root: ?*TreeNode, val: i32) ?*TreeNode {
    var cur = root;
    while (cur != null) {
        if (cur.?.val == val) return cur;
        if (val < cur.?.val) {
            cur = cur.?.left;
        } else {
            cur = cur.?.right;
        }
    }
    return null;
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "searchBST" {
    // [4,2,7,1,3]  find 2 -> subtree rooted at 2
    const t = mk(4, mk(2, mk(1, null, null), mk(3, null, null)), mk(7, null, null));
    const r = searchBST(t, 2);
    try std.testing.expect(r != null);
    try std.testing.expectEqual(@as(i32, 2), r.?.val);
    try std.testing.expectEqual(@as(i32, 1), r.?.left.?.val);
    try std.testing.expectEqual(@as(i32, 3), r.?.right.?.val);

    // find 5 -> null
    try std.testing.expect(searchBST(t, 5) == null);
    // root itself
    const r2 = searchBST(t, 4);
    try std.testing.expect(r2 == t);
    // single node found / not found
    const s = mk(7, null, null);
    try std.testing.expect(searchBST(s, 7) == s);
    try std.testing.expect(searchBST(s, 1) == null);
    // null tree
    try std.testing.expect(searchBST(null, 1) == null);
}
