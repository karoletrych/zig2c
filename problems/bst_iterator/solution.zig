// LeetCode 173. Binary Search Tree Iterator
// C signatures:
//   BSTIterator* bSTIteratorCreate(struct TreeNode* root);
//   int bSTIteratorNext(BSTIterator* obj);
//   bool bSTIteratorHasNext(BSTIterator* obj);
//
// The iterator is built by flattening the tree with an in-order walk into an
// array of at most `n` values; `next` then just walks that array. (The classic
// stack-of-left-spines iterator would also work, but an array keeps the mapping
// to C trivial and uses no per-call allocation.)
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

pub const BSTIterator = struct {
    vals: [*]i32,
    n: i32,
    idx: i32,
};

fn countNodes(root: ?*TreeNode) i32 {
    if (root == null) return 0;
    return 1 + countNodes(root.?.left) + countNodes(root.?.right);
}

fn inorder(node: ?*TreeNode, buf: [*]i32, k: *i32) void {
    if (node == null) return;
    inorder(node.?.left, buf, k);
    buf[@intCast(k.*)] = node.?.val;
    k.* += 1;
    inorder(node.?.right, buf, k);
}

pub fn bSTIteratorCreate(root: ?*TreeNode) ?*BSTIterator {
    const obj = allocator.create(BSTIterator) catch unreachable;
    const cnt = countNodes(root);
    // at least one element so the allocation is never zero-sized
    const cap: i32 = @max(cnt, 1);
    obj.vals = (allocator.alloc(i32, @intCast(cap)) catch unreachable).ptr;
    var k: i32 = 0;
    inorder(root, obj.vals, &k);
    obj.n = k;
    obj.idx = 0;
    return obj;
}

pub fn bSTIteratorNext(obj: *BSTIterator) i32 {
    const v = obj.vals[@intCast(obj.idx)];
    obj.idx += 1;
    return v;
}

pub fn bSTIteratorHasNext(obj: *BSTIterator) bool {
    return obj.idx < obj.n;
}

fn mk(v: i32, l: ?*TreeNode, r: ?*TreeNode) ?*TreeNode {
    const n = allocator.create(TreeNode) catch unreachable;
    n.val = v;
    n.left = l;
    n.right = r;
    return n;
}

test "BSTIterator example" {
    // [7,3,15,null,null,9,20]
    const root = mk(7, mk(3, null, null), mk(15, mk(9, null, null), mk(20, null, null)));
    const it = bSTIteratorCreate(root).?;
    try std.testing.expect(bSTIteratorHasNext(it));
    try std.testing.expectEqual(@as(i32, 3), bSTIteratorNext(it));
    try std.testing.expectEqual(@as(i32, 7), bSTIteratorNext(it));
    try std.testing.expect(bSTIteratorHasNext(it));
    try std.testing.expectEqual(@as(i32, 9), bSTIteratorNext(it));
    try std.testing.expect(bSTIteratorHasNext(it));
    try std.testing.expectEqual(@as(i32, 15), bSTIteratorNext(it));
    try std.testing.expect(bSTIteratorHasNext(it));
    try std.testing.expectEqual(@as(i32, 20), bSTIteratorNext(it));
    try std.testing.expect(!bSTIteratorHasNext(it));
}

test "BSTIterator edges" {
    // single node
    const solo = bSTIteratorCreate(mk(42, null, null)).?;
    try std.testing.expect(bSTIteratorHasNext(solo));
    try std.testing.expectEqual(@as(i32, 42), bSTIteratorNext(solo));
    try std.testing.expect(!bSTIteratorHasNext(solo));

    // right-skewed chain: in-order is sorted already
    const rsk = bSTIteratorCreate(mk(1, null, mk(2, null, mk(3, null, null)))).?;
    try std.testing.expectEqual(@as(i32, 1), bSTIteratorNext(rsk));
    try std.testing.expectEqual(@as(i32, 2), bSTIteratorNext(rsk));
    try std.testing.expectEqual(@as(i32, 3), bSTIteratorNext(rsk));
    try std.testing.expect(!bSTIteratorHasNext(rsk));

    // left-skewed chain
    const lsk = bSTIteratorCreate(mk(3, mk(2, mk(1, null, null), null), null)).?;
    try std.testing.expectEqual(@as(i32, 1), bSTIteratorNext(lsk));
    try std.testing.expectEqual(@as(i32, 2), bSTIteratorNext(lsk));
    try std.testing.expectEqual(@as(i32, 3), bSTIteratorNext(lsk));
    try std.testing.expect(!bSTIteratorHasNext(lsk));
}
