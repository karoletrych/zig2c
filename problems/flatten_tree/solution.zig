// LeetCode 114. Flatten Binary Tree to Linked List
// C signature:  void flatten(struct TreeNode* root);
//
// A post-order helper flattens a subtree in place and returns its tail, so the
// caller can splice the flattened right subtree after the flattened left one.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

fn flat(node: ?*TreeNode) ?*TreeNode {
    if (node == null) return null;
    const root = node.?;
    const l = root.left;
    const r = root.right;
    root.left = null;
    root.right = null;
    var tail: ?*TreeNode = root;
    if (l) |left| {
        const lt = flat(left).?;
        tail.?.right = left;
        tail = lt;
    }
    if (r) |right| {
        const rt = flat(right).?;
        tail.?.right = right;
        tail = rt;
    }
    return tail;
}

pub fn flatten(root: ?*TreeNode) void {
    _ = flat(root);
}

fn collect(root: ?*TreeNode, out: [*]i32) i32 {
    var cur = root;
    var n: i32 = 0;
    while (cur) |c| {
        out[@intCast(n)] = c.val;
        n += 1;
        cur = c.right;
    }
    return n;
}

fn allLeftNull(root: ?*TreeNode) bool {
    var cur = root;
    while (cur) |c| {
        if (c.left != null) return false;
        cur = c.right;
    }
    return true;
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "flatten example" {
    // [1,2,5,3,4,null,6] -> 1 -> 2 -> 3 -> 4 -> 5 -> 6
    const t = mk(1, mk(2, mk(3, null, null), mk(4, null, null)), mk(5, null, mk(6, null, null)));
    flatten(t);
    var buf: [16]i32 = undefined;
    const n = collect(t, &buf);
    try std.testing.expectEqual(@as(i32, 6), n);
    const want = [_]i32{ 1, 2, 3, 4, 5, 6 };
    var i: usize = 0;
    while (i < 6) : (i += 1) try std.testing.expectEqual(want[i], buf[i]);
    try std.testing.expect(allLeftNull(t));
}

test "flatten edges" {
    flatten(null);

    const solo = mk(1, null, null);
    flatten(solo);
    try std.testing.expectEqual(@as(i32, 1), solo.?.val);
    try std.testing.expect(solo.?.left == null);
    try std.testing.expect(solo.?.right == null);

    // left-skewed: 1 -> 2 -> 3 already, nothing to move
    const lsk = mk(1, mk(2, mk(3, null, null), null), null);
    flatten(lsk);
    var b1: [8]i32 = undefined;
    try std.testing.expectEqual(@as(i32, 3), collect(lsk, &b1));
    try std.testing.expectEqual(@as(i32, 3), b1[2]);

    // right-skewed stays as it is
    const rsk = mk(1, null, mk(2, null, mk(3, null, null)));
    flatten(rsk);
    var b2: [8]i32 = undefined;
    try std.testing.expectEqual(@as(i32, 3), collect(rsk, &b2));
    try std.testing.expectEqual(@as(i32, 3), b2[2]);
    try std.testing.expect(allLeftNull(rsk));

    // a left-only chain of depth 3 under a root with a right child
    const mix = mk(1, mk(2, mk(3, null, null), null), mk(4, null, null));
    flatten(mix);
    var b3: [8]i32 = undefined;
    try std.testing.expectEqual(@as(i32, 4), collect(mix, &b3));
    const want = [_]i32{ 1, 2, 3, 4 };
    var j: usize = 0;
    while (j < 4) : (j += 1) try std.testing.expectEqual(want[j], b3[j]);
}
