// LeetCode 105. Construct Binary Tree from Preorder and Inorder Traversal
// C signature:
//   struct TreeNode* buildTree(int* preorder, int preorderSize, int* inorder, int inorderSize);
//
// The first unused preorder value is the current root; its position in the
// inorder array splits the remaining values into the left and right subtrees.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

fn buildPre(pre: []i32, idx: [*]i32, ino: []i32, lo: i32, hi: i32) ?*TreeNode {
    if (lo > hi) return null;
    const v = pre[@intCast(idx[0])];
    idx[0] += 1;
    var mid: i32 = lo;
    while (mid <= hi) : (mid += 1) {
        if (ino[@intCast(mid)] == v) break;
    }
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = buildPre(pre, idx, ino, lo, mid - 1);
    n.right = buildPre(pre, idx, ino, mid + 1, hi);
    return n;
}

pub fn buildTree(preorder: [*]i32, preorderSize: i32, inorder: [*]i32, inorderSize: i32) ?*TreeNode {
    const n: usize = @intCast(preorderSize);
    const m: usize = @intCast(inorderSize);
    // Scratch space for the preorder cursor, so it can be passed as a pointer.
    const buf = allocator.alloc(i32, 4) catch unreachable;
    defer allocator.free(buf);
    buf[0] = 0;
    const pre = preorder[0..n];
    const ino = inorder[0..m];
    return buildPre(pre, buf.ptr, ino, 0, inorderSize - 1);
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "buildTree preorder/inorder example" {
    var pre = [_]i32{ 3, 9, 20, 15, 7 };
    var ino = [_]i32{ 9, 3, 15, 20, 7 };
    const root = buildTree(&pre, @intCast(pre.len), &ino, @intCast(ino.len));
    try std.testing.expect(root != null);
    try std.testing.expectEqual(@as(i32, 3), root.?.val);
    try std.testing.expectEqual(@as(i32, 9), root.?.left.?.val);
    try std.testing.expectEqual(@as(i32, 20), root.?.right.?.val);
    try std.testing.expect(root.?.left.?.left == null);
    try std.testing.expect(root.?.left.?.right == null);
    try std.testing.expectEqual(@as(i32, 15), root.?.right.?.left.?.val);
    try std.testing.expectEqual(@as(i32, 7), root.?.right.?.right.?.val);
}

test "buildTree preorder/inorder edges" {
    // empty input
    var empty = [_]i32{0};
    try std.testing.expect(buildTree(&empty, 0, &empty, 0) == null);

    // single node
    var onePre = [_]i32{-1};
    var oneIn = [_]i32{-1};
    const one = buildTree(&onePre, 1, &oneIn, 1);
    try std.testing.expectEqual(@as(i32, -1), one.?.val);
    try std.testing.expect(one.?.left == null and one.?.right == null);

    // left-skewed: preorder [1,2,3], inorder [3,2,1]
    var skewPre = [_]i32{ 1, 2, 3 };
    var skewIn = [_]i32{ 3, 2, 1 };
    const l = buildTree(&skewPre, 3, &skewIn, 3);
    try std.testing.expectEqual(@as(i32, 1), l.?.val);
    try std.testing.expectEqual(@as(i32, 2), l.?.left.?.val);
    try std.testing.expectEqual(@as(i32, 3), l.?.left.?.left.?.val);
    try std.testing.expect(l.?.right == null);

    // duplicate-free: preorder [1,2,4,5,3,6,7], inorder [4,2,5,1,6,3,7]
    var deepPre = [_]i32{ 1, 2, 4, 5, 3, 6, 7 };
    var deepIn = [_]i32{ 4, 2, 5, 1, 6, 3, 7 };
    const r = buildTree(&deepPre, 7, &deepIn, 7);
    const want = mk(1, mk(2, mk(4, null, null), mk(5, null, null)), mk(3, mk(6, null, null), mk(7, null, null)));
    try std.testing.expect(sameShape(r, want));
}

// Test-only deep comparison (not translated: only reachable from tests).
fn sameShape(a: ?*TreeNode, b: ?*TreeNode) bool {
    if (a == null and b == null) return true;
    if (a == null or b == null) return false;
    if (a.?.val != b.?.val) return false;
    return sameShape(a.?.left, b.?.left) and sameShape(a.?.right, b.?.right);
}
