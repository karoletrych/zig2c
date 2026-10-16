// LeetCode 102. Binary Tree Level Order Traversal
// C signature:  int** levelOrder(struct TreeNode* root, int* returnSize,
//                                int** returnColumnSizes);
//
// BFS with one queue; the outer pass walks exactly the nodes of the current
// level, then copies them into a freshly allocated row.
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

pub fn levelOrder(root: ?*TreeNode, returnSize: *i32, returnColumnSizes: [*][*]i32) ?[*][*]i32 {
    if (root == null) {
        const empty_rows = allocator.alloc([*]i32, 1) catch unreachable;
        const empty_cols = allocator.alloc(i32, 1) catch unreachable;
        returnColumnSizes[0] = empty_cols.ptr;
        returnSize.* = 0;
        return empty_rows.ptr;
    }

    const n = countNodes(root);
    const q = allocator.alloc(*TreeNode, @intCast(n)) catch unreachable;
    const rows = allocator.alloc([*]i32, @intCast(n)) catch unreachable;
    const cols = allocator.alloc(i32, @intCast(n)) catch unreachable;

    var head: i32 = 0;
    var tail: i32 = 1;
    q[0] = root.?;
    var levels: i32 = 0;

    while (head < tail) {
        const cnt = tail - head;
        const row = allocator.alloc(i32, @intCast(cnt)) catch unreachable;
        var k: i32 = 0;
        while (k < cnt) : (k += 1) {
            const node = q[@intCast(head)];
            head += 1;
            row[@intCast(k)] = node.val;
            if (node.left) |l| {
                q[@intCast(tail)] = l;
                tail += 1;
            }
            if (node.right) |r| {
                q[@intCast(tail)] = r;
                tail += 1;
            }
        }
        rows[@intCast(levels)] = row.ptr;
        cols[@intCast(levels)] = cnt;
        levels += 1;
    }

    returnColumnSizes[0] = cols.ptr;
    returnSize.* = levels;
    return rows.ptr;
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "levelOrder examples" {
    // [3,9,20,null,null,15,7] -> [[3],[9,20],[15,7]]
    var rs: i32 = 0;
    var cb = [_][*]i32{undefined};
    const t = mk(3, mk(9, null, null), mk(20, mk(15, null, null), mk(7, null, null)));
    const r = levelOrder(t, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqual(@as(i32, 1), cb[0][0]);
    try std.testing.expectEqual(@as(i32, 2), cb[0][1]);
    try std.testing.expectEqual(@as(i32, 2), cb[0][2]);
    try std.testing.expectEqual(@as(i32, 3), r[0][0]);
    try std.testing.expectEqual(@as(i32, 9), r[1][0]);
    try std.testing.expectEqual(@as(i32, 20), r[1][1]);
    try std.testing.expectEqual(@as(i32, 15), r[2][0]);
    try std.testing.expectEqual(@as(i32, 7), r[2][1]);

    // [1] -> [[1]]
    var rs2: i32 = 0;
    var cb2 = [_][*]i32{undefined};
    const r2 = levelOrder(mk(1, null, null), &rs2, &cb2).?;
    try std.testing.expectEqual(@as(i32, 1), rs2);
    try std.testing.expectEqual(@as(i32, 1), cb2[0][0]);
    try std.testing.expectEqual(@as(i32, 1), r2[0][0]);
}

test "levelOrder edges" {
    // empty -> zero rows
    var rs: i32 = 0;
    var cb = [_][*]i32{undefined};
    _ = levelOrder(null, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 0), rs);

    // left-skewed: one value per level
    var rs2: i32 = 0;
    var cb2 = [_][*]i32{undefined};
    const sk = levelOrder(mk(1, mk(2, mk(3, null, null), null), null), &rs2, &cb2).?;
    try std.testing.expectEqual(@as(i32, 3), rs2);
    try std.testing.expectEqual(@as(i32, 1), cb2[0][0]);
    try std.testing.expectEqual(@as(i32, 1), cb2[0][1]);
    try std.testing.expectEqual(@as(i32, 1), cb2[0][2]);
    try std.testing.expectEqual(@as(i32, 1), sk[0][0]);
    try std.testing.expectEqual(@as(i32, 2), sk[1][0]);
    try std.testing.expectEqual(@as(i32, 3), sk[2][0]);

    // ragged last level: [1,2,3,4]
    var rs3: i32 = 0;
    var cb3 = [_][*]i32{undefined};
    const rg = levelOrder(mk(1, mk(2, mk(4, null, null), null), mk(3, null, null)), &rs3, &cb3).?;
    try std.testing.expectEqual(@as(i32, 3), rs3);
    try std.testing.expectEqual(@as(i32, 2), cb3[0][1]);
    try std.testing.expectEqual(@as(i32, 1), cb3[0][2]);
    try std.testing.expectEqual(@as(i32, 4), rg[2][0]);
}
