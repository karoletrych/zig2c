// LeetCode 637. Average of Levels in Binary Tree
// C signature:  double* averageOfLevels(struct TreeNode* root, int* returnSize);
//
// A single BFS queue; each outer pass handles one level, so the average is
// just the level sum divided by the level width.
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

pub fn averageOfLevels(root: ?*TreeNode, returnSize: *i32) ?[*]f64 {
    if (root == null) {
        returnSize.* = 0;
        return null;
    }
    const n = countNodes(root);
    const q = allocator.alloc(*TreeNode, @intCast(n)) catch unreachable;
    const out = allocator.alloc(f64, @intCast(n)) catch unreachable;

    var head: i32 = 0;
    var tail: i32 = 1;
    q[0] = root.?;
    var levels: i32 = 0;

    while (head < tail) {
        const cnt = tail - head;
        var sum: f64 = 0;
        var k: i32 = 0;
        while (k < cnt) : (k += 1) {
            const node = q[@intCast(head)];
            head += 1;
            sum += @as(f64, @floatFromInt(node.val));
            if (node.left) |l| {
                q[@intCast(tail)] = l;
                tail += 1;
            }
            if (node.right) |r| {
                q[@intCast(tail)] = r;
                tail += 1;
            }
        }
        out[@intCast(levels)] = sum / @as(f64, @floatFromInt(cnt));
        levels += 1;
    }

    returnSize.* = levels;
    return out.ptr;
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "averageOfLevels examples" {
    // [3,9,20,null,null,15,7] -> [3, 14.5, 11]
    var rs: i32 = 0;
    const t = mk(3, mk(9, null, null), mk(20, mk(15, null, null), mk(7, null, null)));
    const r = averageOfLevels(t, &rs).?;
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectApproxEqAbs(@as(f64, 3.0), r[0], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, 14.5), r[1], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, 11.0), r[2], 1e-9);
}

test "averageOfLevels edges" {
    var rs: i32 = 0;
    try std.testing.expect(averageOfLevels(null, &rs) == null);
    try std.testing.expectEqual(@as(i32, 0), rs);

    // single node
    const solo = averageOfLevels(mk(7, null, null), &rs).?;
    try std.testing.expectEqual(@as(i32, 1), rs);
    try std.testing.expectApproxEqAbs(@as(f64, 7.0), solo[0], 1e-9);

    // negative values and a fractional average
    const t = averageOfLevels(mk(1, mk(-2, null, null), mk(3, null, null)), &rs).?;
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectApproxEqAbs(@as(f64, 1.0), t[0], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, 0.5), t[1], 1e-9);

    // left-skewed: one node per level
    const sk = averageOfLevels(mk(1, mk(2, mk(3, null, null), null), null), &rs).?;
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectApproxEqAbs(@as(f64, 1.0), sk[0], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, 2.0), sk[1], 1e-9);
    try std.testing.expectApproxEqAbs(@as(f64, 3.0), sk[2], 1e-9);
}
