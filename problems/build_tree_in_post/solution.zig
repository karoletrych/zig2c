// LeetCode 106. Construct Binary Tree from Inorder and Postorder Traversal
// C signature:
//   struct TreeNode* buildTree(int* inorder, int inorderSize, int* postorder, int postorderSize);
//
// Mirror of #105: the last unused postorder value is the current root, and the
// right subtree is finished before the left one.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

fn buildPost(post: []i32, idx: [*]i32, ino: []i32, lo: i32, hi: i32) ?*TreeNode {
    if (lo > hi) return null;
    const v = post[@intCast(idx[0])];
    idx[0] -= 1;
    var mid: i32 = lo;
    while (mid <= hi) : (mid += 1) {
        if (ino[@intCast(mid)] == v) break;
    }
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.right = buildPost(post, idx, ino, mid + 1, hi);
    n.left = buildPost(post, idx, ino, lo, mid - 1);
    return n;
}

pub fn buildTree(inorder: [*]i32, inorderSize: i32, postorder: [*]i32, postorderSize: i32) ?*TreeNode {
    const n: usize = @intCast(inorderSize);
    const m: usize = @intCast(postorderSize);
    const buf = allocator.alloc(i32, 4) catch unreachable;
    defer allocator.free(buf);
    buf[0] = postorderSize - 1;
    const ino = inorder[0..n];
    const post = postorder[0..m];
    return buildPost(post, buf.ptr, ino, 0, inorderSize - 1);
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

// Test-only deep comparison (not translated: only reachable from tests).
fn sameShape(a: ?*TreeNode, b: ?*TreeNode) bool {
    if (a == null and b == null) return true;
    if (a == null or b == null) return false;
    if (a.?.val != b.?.val) return false;
    return sameShape(a.?.left, b.?.left) and sameShape(a.?.right, b.?.right);
}

test "buildTree inorder/postorder example" {
    var ino = [_]i32{ 9, 3, 15, 20, 7 };
    var post = [_]i32{ 9, 15, 7, 20, 3 };
    const root = buildTree(&ino, @intCast(ino.len), &post, @intCast(post.len));
    const want = mk(3, mk(9, null, null), mk(20, mk(15, null, null), mk(7, null, null)));
    try std.testing.expect(sameShape(root, want));
}

test "buildTree inorder/postorder edges" {
    // empty input
    var empty = [_]i32{0};
    try std.testing.expect(buildTree(&empty, 0, &empty, 0) == null);

    // single node
    var oneIn = [_]i32{-1};
    var onePost = [_]i32{-1};
    const one = buildTree(&oneIn, 1, &onePost, 1);
    try std.testing.expect(one != null);
    try std.testing.expectEqual(@as(i32, -1), one.?.val);
    try std.testing.expect(one.?.left == null and one.?.right == null);

    // right-skewed: inorder [1,2,3], postorder [3,2,1]
    var skIn = [_]i32{ 1, 2, 3 };
    var skPost = [_]i32{ 3, 2, 1 };
    const r = buildTree(&skIn, 3, &skPost, 3);
    try std.testing.expectEqual(@as(i32, 1), r.?.val);
    try std.testing.expect(r.?.left == null);
    try std.testing.expectEqual(@as(i32, 2), r.?.right.?.val);
    try std.testing.expectEqual(@as(i32, 3), r.?.right.?.right.?.val);

    // in-order traversal of the rebuilt tree must match the input
    var ino2 = [_]i32{ 4, 2, 5, 1, 6, 3, 7 };
    var post2 = [_]i32{ 4, 5, 2, 6, 7, 3, 1 };
    const root = buildTree(&ino2, 7, &post2, 7);
    const want = mk(1, mk(2, mk(4, null, null), mk(5, null, null)), mk(3, mk(6, null, null), mk(7, null, null)));
    try std.testing.expect(sameShape(root, want));
}
