// LeetCode 530. Minimum Absolute Difference in BST
// C signature:  int getMinimumDifference(struct TreeNode* root);
//
// An in-order walk of a BST visits the values in sorted order, so the minimum
// absolute difference is the smallest gap between two consecutive visits.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

fn inorder(node: ?*TreeNode, prev: *i32, has: *bool, best: *i32) void {
    if (node == null) return;
    inorder(node.?.left, prev, has, best);
    const v = node.?.val;
    if (has.*) {
        const d = v - prev.*;
        if (d < best.*) best.* = d;
    }
    prev.* = v;
    has.* = true;
    inorder(node.?.right, prev, has, best);
}

pub fn getMinimumDifference(root: ?*TreeNode) i32 {
    var prev: i32 = 0;
    var has = false;
    var best: i32 = 2147483647;
    inorder(root, &prev, &has, &best);
    return best;
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "getMinimumDifference examples" {
    // [4,2,6,1,3] -> 1
    try std.testing.expectEqual(@as(i32, 1), getMinimumDifference(mk(4, mk(2, mk(1, null, null), mk(3, null, null)), mk(6, null, null))));

    // [1,0,48,null,null,12,49] -> 1
    const t = mk(1, mk(0, null, null), mk(48, mk(12, null, null), mk(49, null, null)));
    try std.testing.expectEqual(@as(i32, 1), getMinimumDifference(t));
}

test "getMinimumDifference edges" {
    // two nodes
    try std.testing.expectEqual(@as(i32, 2), getMinimumDifference(mk(1, null, mk(3, null, null))));
    try std.testing.expectEqual(@as(i32, 2), getMinimumDifference(mk(3, mk(1, null, null), null)));

    // consecutive gaps straddle the root
    try std.testing.expectEqual(@as(i32, 1), getMinimumDifference(mk(5, mk(4, null, null), mk(7, null, null))));

    // [236,104,701,null,227,null,911] -> |227-236| = 9
    const t = mk(236, mk(104, null, mk(227, null, null)), mk(701, null, mk(911, null, null)));
    try std.testing.expectEqual(@as(i32, 9), getMinimumDifference(t));

    // a left-skewed chain has a single consecutive pair difference of 1
    try std.testing.expectEqual(@as(i32, 1), getMinimumDifference(mk(3, mk(2, mk(1, null, null), null), null)));
}
