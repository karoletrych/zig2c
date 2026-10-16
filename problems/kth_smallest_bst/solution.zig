// LeetCode 230. Kth Smallest Element in a BST
// C signature:  int kthSmallest(struct TreeNode* root, int k);
//
// An in-order walk of a BST yields the values in ascending order; the k-th
// value visited is the answer.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

fn inorder(node: ?*TreeNode, k: i32, count: *i32, result: *i32) void {
    if (node == null) return;
    inorder(node.?.left, k, count, result);
    count.* += 1;
    if (count.* == k) result.* = node.?.val;
    inorder(node.?.right, k, count, result);
}

pub fn kthSmallest(root: ?*TreeNode, k: i32) i32 {
    var count: i32 = 0;
    var result: i32 = 0;
    inorder(root, k, &count, &result);
    return result;
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "kthSmallest examples" {
    // [3,1,4,null,2]
    const t = mk(3, mk(1, null, mk(2, null, null)), mk(4, null, null));
    try std.testing.expectEqual(@as(i32, 1), kthSmallest(t, 1));
    try std.testing.expectEqual(@as(i32, 2), kthSmallest(t, 2));
    try std.testing.expectEqual(@as(i32, 3), kthSmallest(t, 3));
    try std.testing.expectEqual(@as(i32, 4), kthSmallest(t, 4));
}

test "kthSmallest edges" {
    // [5,3,6,2,4,null,null,1]
    const t = mk(5, mk(3, mk(2, mk(1, null, null), null), mk(4, null, null)), mk(6, null, null));
    try std.testing.expectEqual(@as(i32, 1), kthSmallest(t, 1));
    try std.testing.expectEqual(@as(i32, 3), kthSmallest(t, 3));
    try std.testing.expectEqual(@as(i32, 6), kthSmallest(t, 6));

    // single node
    try std.testing.expectEqual(@as(i32, 7), kthSmallest(mk(7, null, null), 1));

    // right-skewed chain
    const rsk = mk(1, null, mk(2, null, mk(3, null, null)));
    try std.testing.expectEqual(@as(i32, 2), kthSmallest(rsk, 2));
    try std.testing.expectEqual(@as(i32, 3), kthSmallest(rsk, 3));

    // left-skewed chain
    const lsk = mk(3, mk(2, mk(1, null, null), null), null);
    try std.testing.expectEqual(@as(i32, 1), kthSmallest(lsk, 1));
    try std.testing.expectEqual(@as(i32, 3), kthSmallest(lsk, 3));
}
