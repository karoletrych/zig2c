// LeetCode 129. Sum Root to Leaf Numbers
// C signature:  int sumNumbers(struct TreeNode* root);
//
// A DFS carries the number built so far; at a leaf it contributes that number,
// otherwise the two children are summed.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

fn dfs(node: ?*TreeNode, cur: i32) i32 {
    if (node == null) return 0;
    const n = node.?;
    const v = cur * 10 + n.val;
    if (n.left == null and n.right == null) return v;
    return dfs(n.left, v) + dfs(n.right, v);
}

pub fn sumNumbers(root: ?*TreeNode) i32 {
    return dfs(root, 0);
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "sumNumbers examples" {
    // [1,2,3] -> 12 + 13 = 25
    try std.testing.expectEqual(@as(i32, 25), sumNumbers(mk(1, mk(2, null, null), mk(3, null, null))));

    // [4,9,0,5,1] -> 495 + 491 + 40 = 1026
    const t = mk(4, mk(9, mk(5, null, null), mk(1, null, null)), mk(0, null, null));
    try std.testing.expectEqual(@as(i32, 1026), sumNumbers(t));
}

test "sumNumbers edges" {
    try std.testing.expectEqual(@as(i32, 0), sumNumbers(null));

    // single node
    try std.testing.expectEqual(@as(i32, 5), sumNumbers(mk(5, null, null)));
    try std.testing.expectEqual(@as(i32, 0), sumNumbers(mk(0, null, null)));

    // one level: 0 -> 10 or 11 (leading zero is kept as part of the number)
    try std.testing.expectEqual(@as(i32, 10), sumNumbers(mk(1, mk(0, null, null), null)));
    try std.testing.expectEqual(@as(i32, 21), sumNumbers(mk(1, mk(0, null, null), mk(1, null, null))));

    // left-skewed chain 1 -> 2 -> 3 forms the single number 123
    const sk = mk(1, mk(2, mk(3, null, null), null), null);
    try std.testing.expectEqual(@as(i32, 123), sumNumbers(sk));

    // leaves at different depths: 11 + 112 + 111 = 234
    const mixed = mk(1, mk(1, null, null), mk(1, mk(2, null, null), mk(1, null, null)));
    try std.testing.expectEqual(@as(i32, 234), sumNumbers(mixed));
}
