// LeetCode 437. Path Sum III
// C signature:  int pathSum(struct TreeNode* root, int targetSum);
//
// Prefix-sum counting over the DFS path. zig2c cannot pass a `*std.AutoHashMap`
// as a parameter, so the traversal is an explicit enter/exit stack and the map
// lives in this one function.
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

pub fn pathSum(root: ?*TreeNode, targetSum: i32) i32 {
    if (root == null) return 0;

    var map = std.AutoHashMap(i64, i32).init(allocator);
    defer map.deinit();
    map.put(0, 1) catch unreachable;

    const n = countNodes(root);
    const cap: usize = @intCast(2 * n + 8);
    const stkNode = allocator.alloc(*TreeNode, cap) catch unreachable;
    defer allocator.free(stkNode);
    const stkSum = allocator.alloc(i64, cap) catch unreachable;
    defer allocator.free(stkSum);
    const stkEnter = allocator.alloc(bool, cap) catch unreachable;
    defer allocator.free(stkEnter);

    var top: i32 = 0;
    stkNode[0] = root.?;
    stkSum[0] = 0;
    stkEnter[0] = true;
    top = 1;
    var total: i32 = 0;
    const target: i64 = @as(i64, targetSum);

    while (top > 0) {
        top -= 1;
        const idx: usize = @intCast(top);
        const node = stkNode[idx];
        const cur = stkSum[idx];
        if (stkEnter[idx]) {
            const c = cur + node.val;
            if (map.get(c - target)) |v| total += v;

            const before = map.get(c) orelse 0;
            map.put(c, before + 1) catch unreachable;

            // Write the exit marker, then the children (right before left so
            // left is processed first).
            stkNode[@intCast(top)] = node;
            stkSum[@intCast(top)] = c;
            stkEnter[@intCast(top)] = false;
            top += 1;
            if (node.right) |r| {
                const j: usize = @intCast(top);
                stkNode[j] = r;
                stkSum[j] = c;
                stkEnter[j] = true;
                top += 1;
            }
            if (node.left) |l| {
                const j: usize = @intCast(top);
                stkNode[j] = l;
                stkSum[j] = c;
                stkEnter[j] = true;
                top += 1;
            }
        } else {
            const after = map.get(cur) orelse 0;
            map.put(cur, after - 1) catch unreachable;
        }
    }
    return total;
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "pathSum" {
    // [10,5,-3,3,2,null,11,3,-2,null,1], target 8 -> 3
    const t1 = mk(10, mk(5, mk(3, mk(3, null, null), mk(-2, null, null)), mk(2, null, mk(1, null, null))), mk(-3, null, mk(11, null, null)));
    try std.testing.expectEqual(@as(i32, 3), pathSum(t1, 8));

    // [5,4,8,11,null,13,4,7,2,null,null,5,1], target 22 -> 3
    const t2 = mk(5, mk(4, mk(11, mk(7, null, null), mk(2, null, null)), null), mk(8, mk(13, null, null), mk(4, mk(5, null, null), mk(1, null, null))));
    try std.testing.expectEqual(@as(i32, 3), pathSum(t2, 22));

    // single node
    try std.testing.expectEqual(@as(i32, 1), pathSum(mk(1, null, null), 1));
    try std.testing.expectEqual(@as(i32, 0), pathSum(mk(1, null, null), 0));
    // null tree
    try std.testing.expectEqual(@as(i32, 0), pathSum(null, 5));
    // negative values: [1,-2,-3], target -1 -> only 1 + -2
    const t3 = mk(1, mk(-2, null, null), mk(-3, null, null));
    try std.testing.expectEqual(@as(i32, 1), pathSum(t3, -1));
    // deeper chain [1,2,3], target 3 -> 2 (3, 1+2)
    try std.testing.expectEqual(@as(i32, 2), pathSum(mk(1, mk(2, mk(3, null, null), null), null), 3));
}
