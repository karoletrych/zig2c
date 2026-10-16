// LeetCode 872. Leaf-Similar Trees  (LeetCode 75)
// C signature:  bool leafSimilar(struct TreeNode* root1, struct TreeNode* root2);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

fn countLeaves(root: ?*TreeNode) i32 {
    if (root == null) return 0;
    if (root.?.left == null and root.?.right == null) return 1;
    return countLeaves(root.?.left) + countLeaves(root.?.right);
}

fn collectLeaves(root: ?*TreeNode, out: [*]i32, count: *i32) void {
    if (root == null) return;
    if (root.?.left == null and root.?.right == null) {
        out[@intCast(count.*)] = root.?.val;
        count.* += 1;
        return;
    }
    collectLeaves(root.?.left, out, count);
    collectLeaves(root.?.right, out, count);
}

pub fn leafSimilar(root1: ?*TreeNode, root2: ?*TreeNode) bool {
    const n1 = countLeaves(root1);
    const n2 = countLeaves(root2);
    if (n1 != n2) return false;
    if (n1 == 0) return true;

    const a = allocator.alloc(i32, @intCast(n1)) catch unreachable;
    defer allocator.free(a);
    const b = allocator.alloc(i32, @intCast(n2)) catch unreachable;
    defer allocator.free(b);

    var c1: i32 = 0;
    var c2: i32 = 0;
    collectLeaves(root1, a.ptr, &c1);
    collectLeaves(root2, b.ptr, &c2);

    var i: i32 = 0;
    while (i < n1) : (i += 1) {
        if (a[@intCast(i)] != b[@intCast(i)]) return false;
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

test "leafSimilar" {
    // [3,5,1,6,2,9,8,null,null,7,4] vs [3,5,1,6,7,4,2,null,null,null,null,null,null,9,8]
    const t1 = mk(3, mk(5, mk(6, null, null), mk(2, mk(7, null, null), mk(4, null, null))), mk(1, mk(9, null, null), mk(8, null, null)));
    const t2 = mk(3, mk(5, mk(6, null, null), mk(7, null, null)), mk(1, mk(4, null, null), mk(2, mk(9, null, null), mk(8, null, null))));
    try std.testing.expectEqual(true, leafSimilar(t1, t2));

    const t3 = mk(1, mk(2, null, null), mk(3, null, null));
    const t4 = mk(1, mk(3, null, null), mk(2, null, null));
    try std.testing.expectEqual(false, leafSimilar(t3, t4));

    // single node vs single node with same value
    try std.testing.expectEqual(true, leafSimilar(mk(1, null, null), mk(1, null, null)));
    // single node vs single node with different value
    try std.testing.expectEqual(false, leafSimilar(mk(1, null, null), mk(2, null, null)));
    // both null
    try std.testing.expectEqual(true, leafSimilar(null, null));
    // one null
    try std.testing.expectEqual(false, leafSimilar(null, mk(1, null, null)));
}
