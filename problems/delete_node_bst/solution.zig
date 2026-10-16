// LeetCode 450. Delete Node in a BST
// C signature:  struct TreeNode* deleteNode(struct TreeNode* root, int key);
// The tree is mutated in place and the (possibly new) root is returned.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

pub fn deleteNode(root: ?*TreeNode, key: i32) ?*TreeNode {
    if (root == null) return null;

    if (key < root.?.val) {
        root.?.left = deleteNode(root.?.left, key);
        return root;
    }
    if (key > root.?.val) {
        root.?.right = deleteNode(root.?.right, key);
        return root;
    }

    // Found the node.
    if (root.?.left == null) return root.?.right;
    if (root.?.right == null) return root.?.left;

    // Two children: replace with the inorder successor (min of right subtree).
    var succ = root.?.right;
    while (succ.?.left != null) {
        succ = succ.?.left;
    }
    root.?.val = succ.?.val;
    root.?.right = deleteNode(root.?.right, succ.?.val);
    return root;
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

fn inorder(node: ?*TreeNode, out: [*]i32, count: *i32) void {
    if (node == null) return;
    inorder(node.?.left, out, count);
    out[@intCast(count.*)] = node.?.val;
    count.* += 1;
    inorder(node.?.right, out, count);
}

fn checkTree(root: ?*TreeNode, want: []const i32) bool {
    var buf: [32]i32 = undefined;
    var c: i32 = 0;
    inorder(root, &buf, &c);
    if (c != @as(i32, @intCast(want.len))) return false;
    var i: usize = 0;
    while (i < want.len) : (i += 1) {
        if (want[i] != buf[i]) return false;
    }
    return true;
}

test "deleteNode" {
    var w5 = [_]i32{ 2, 4, 5, 6, 7 };
    var w4 = [_]i32{ 2, 4, 6, 7 };
    var w3 = [_]i32{ 4, 6, 7 };
    var w1 = [_]i32{2};

    // [5,3,6,2,4,null,7] delete 3 -> [2,4,5,6,7]
    var t = mk(5, mk(3, mk(2, null, null), mk(4, null, null)), mk(6, null, mk(7, null, null)));
    t = deleteNode(t, 3);
    try std.testing.expect(checkTree(t, w5[0..5]));

    // delete a key not present leaves the tree unchanged
    t = deleteNode(t, 0);
    try std.testing.expect(checkTree(t, w5[0..5]));

    // delete the root (two children): [2,4,6,7]
    t = deleteNode(t, 5);
    try std.testing.expect(checkTree(t, w4[0..4]));

    // delete a leaf
    t = deleteNode(t, 2);
    try std.testing.expect(checkTree(t, w3[0..3]));

    // single node, delete it
    const one = deleteNode(mk(1, null, null), 1);
    try std.testing.expect(one == null);
    // delete from null
    try std.testing.expect(deleteNode(null, 5) == null);
    // root with only a right child
    const ronly = deleteNode(mk(1, null, mk(2, null, null)), 1);
    try std.testing.expect(checkTree(ronly, w1[0..1]));
}
