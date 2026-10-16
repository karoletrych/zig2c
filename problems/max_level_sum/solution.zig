// LeetCode 1161. Maximum Level Sum of a Binary Tree
// C signature:  int maxLevelSum(struct TreeNode* root);
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

pub fn maxLevelSum(root: ?*TreeNode) i32 {
    if (root == null) return 0;

    const n = countNodes(root);
    const q = allocator.alloc(*TreeNode, @intCast(n)) catch unreachable;
    defer allocator.free(q);

    var head: i32 = 0;
    var tail: i32 = 0;
    q[0] = root.?;
    tail = 1;

    var level: i32 = 1;
    var bestLevel: i32 = 1;
    var bestSum: i64 = -9000000000000000000;

    while (head < tail) {
        const cnt = tail - head;
        var sum: i64 = 0;
        var k: i32 = 0;
        while (k < cnt) : (k += 1) {
            const node = q[@intCast(head)];
            head += 1;
            sum += node.val;
            if (node.left) |l| {
                q[@intCast(tail)] = l;
                tail += 1;
            }
            if (node.right) |r| {
                q[@intCast(tail)] = r;
                tail += 1;
            }
        }
        if (sum > bestSum) {
            bestSum = sum;
            bestLevel = level;
        }
        level += 1;
    }
    return bestLevel;
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "maxLevelSum" {
    // [1,7,0,7,-8,null,null] -> 2
    const t1 = mk(1, mk(7, mk(7, null, null), mk(-8, null, null)), mk(0, null, null));
    try std.testing.expectEqual(@as(i32, 2), maxLevelSum(t1));

    // [989,null,10250,98693,-89388,null,null,null,-32127] -> 2
    const t2 = mk(989, null, mk(10250, mk(98693, null, mk(-32127, null, null)), mk(-89388, null, null)));
    try std.testing.expectEqual(@as(i32, 2), maxLevelSum(t2));

    // single node -> 1
    try std.testing.expectEqual(@as(i32, 1), maxLevelSum(mk(1, null, null)));

    // tie between level 1 and level 2 picks the smallest level: [1,1,0] -> 1
    try std.testing.expectEqual(@as(i32, 1), maxLevelSum(mk(1, mk(1, null, null), mk(0, null, null))));

    // null -> 0
    try std.testing.expectEqual(@as(i32, 0), maxLevelSum(null));
}
