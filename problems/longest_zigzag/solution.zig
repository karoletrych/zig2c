// LeetCode 1372. Longest ZigZag Path in a Binary Tree  (LeetCode 75)
// C signature:  int longestZigZag(struct TreeNode* root);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

// `arrivedLeft` is true when `node` was reached by moving left from its parent.
fn maxZigZag(node: ?*TreeNode, arrivedLeft: bool, length: i32, best: *i32) void {
    if (node == null) return;
    if (length > best.*) best.* = length;
    if (arrivedLeft) {
        // Continue the zigzag to the right, or restart going left.
        maxZigZag(node.?.right, false, length + 1, best);
        maxZigZag(node.?.left, true, 1, best);
    } else {
        maxZigZag(node.?.left, true, length + 1, best);
        maxZigZag(node.?.right, false, 1, best);
    }
}

pub fn longestZigZag(root: ?*TreeNode) i32 {
    if (root == null) return 0;
    var best: i32 = 0;
    maxZigZag(root.?.left, true, 1, &best);
    maxZigZag(root.?.right, false, 1, &best);
    return best;
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "longestZigZag" {
    // [1,null,1,1,1,null,null,1,1,null,1,null,null,null,1] -> 3
    const t1 = mk(1, null, mk(1,
        mk(1, null, mk(1, null, mk(1, null, null))),
        mk(1, mk(1, null, null), null)));
    try std.testing.expectEqual(@as(i32, 3), longestZigZag(t1));

    // [1,1,1,null,1,null,null,1,1,null,1] -> 4
    const t2 = mk(1,
        mk(1, null, mk(1, mk(1, null, mk(1, null, null)), mk(1, null, null))),
        mk(1, null, null));
    try std.testing.expectEqual(@as(i32, 4), longestZigZag(t2));

    // single node -> 0
    try std.testing.expectEqual(@as(i32, 0), longestZigZag(mk(1, null, null)));
    // null -> 0
    try std.testing.expectEqual(@as(i32, 0), longestZigZag(null));
    // straight chain [1,2,null,3] -> 1 (no zigzag)
    try std.testing.expectEqual(@as(i32, 1), longestZigZag(mk(1, mk(2, mk(3, null, null), null), null)));
}
