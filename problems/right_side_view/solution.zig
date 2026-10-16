// LeetCode 199. Binary Tree Right Side View
// C signature:  int* rightSideView(struct TreeNode* root, int* returnSize);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

fn countNodes(root: ?*TreeNode) i32 {
    if (root == null) return 0;
    return 1 + countNodes(root.?.left) + countNodes(root.?.right);
}

// Visit right before left so the first node seen at each depth is the
// rightmost one.
fn walk(node: ?*TreeNode, depth: i32, res: [*]i32, levels: *i32) void {
    if (node == null) return;
    if (depth == levels.*) {
        res[@intCast(depth)] = node.?.val;
        levels.* += 1;
    }
    walk(node.?.right, depth + 1, res, levels);
    walk(node.?.left, depth + 1, res, levels);
}

pub fn rightSideView(root: ?*TreeNode, returnSize: *i32) [*]i32 {
    const n = countNodes(root);
    if (n == 0) {
        const empty = allocator.alloc(i32, 1) catch unreachable;
        returnSize.* = 0;
        return empty.ptr;
    }
    const res = allocator.alloc(i32, @intCast(n)) catch unreachable;
    var levels: i32 = 0;
    walk(root, 0, res.ptr, &levels);
    returnSize.* = levels;
    return res.ptr;
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "rightSideView" {
    // [1,2,3,null,5,null,4] -> [1,3,4]
    var rs: i32 = 0;
    const t = mk(1, mk(2, null, mk(5, null, null)), mk(3, null, mk(4, null, null)));
    var r = rightSideView(t, &rs);
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqual(@as(i32, 1), r[0]);
    try std.testing.expectEqual(@as(i32, 3), r[1]);
    try std.testing.expectEqual(@as(i32, 4), r[2]);

    // [1,null,3] -> [1,3]
    r = rightSideView(mk(1, null, mk(3, null, null)), &rs);
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, 1), r[0]);
    try std.testing.expectEqual(@as(i32, 3), r[1]);

    // [1,2] -> [1,2]
    r = rightSideView(mk(1, mk(2, null, null), null), &rs);
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqual(@as(i32, 2), r[1]);

    // single node
    r = rightSideView(mk(7, null, null), &rs);
    try std.testing.expectEqual(@as(i32, 1), rs);
    try std.testing.expectEqual(@as(i32, 7), r[0]);

    // null tree
    _ = rightSideView(null, &rs);
    try std.testing.expectEqual(@as(i32, 0), rs);
}
