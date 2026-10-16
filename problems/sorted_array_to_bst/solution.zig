// LeetCode 108. Convert Sorted Array to Binary Search Tree
// C signature:  struct TreeNode* sortedArrayToBST(int* nums, int numsSize);
//
// Build the middle element at each step; both halves are then the same size
// (up to one), so the resulting tree is height balanced.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const TreeNode = struct {
    val: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,
};

fn build(nums: [*]i32, lo: i32, hi: i32) ?*TreeNode {
    if (lo > hi) return null;
    const mid = lo + @divTrunc(hi - lo, 2);
    const node = allocator.create(TreeNode) catch unreachable;
    node.val = nums[@intCast(mid)];
    node.left = build(nums, lo, mid - 1);
    node.right = build(nums, mid + 1, hi);
    return node;
}

pub fn sortedArrayToBST(nums: [*]i32, numsSize: i32) ?*TreeNode {
    return build(nums, 0, numsSize - 1);
}

fn inorderOk(node: ?*TreeNode, nums: [*]i32, idx: *i32) bool {
    if (node == null) return true;
    if (!inorderOk(node.?.left, nums, idx)) return false;
    if (node.?.val != nums[@intCast(idx.*)]) return false;
    idx.* += 1;
    return inorderOk(node.?.right, nums, idx);
}

fn height(node: ?*TreeNode) i32 {
    if (node == null) return 0;
    return 1 + @max(height(node.?.left), height(node.?.right));
}

fn balanced(node: ?*TreeNode) bool {
    if (node == null) return true;
    const dl = height(node.?.left);
    const dr = height(node.?.right);
    if (@abs(dl - dr) > 1) return false;
    return balanced(node.?.left) and balanced(node.?.right);
}

test "sortedArrayToBST example" {
    // [-10,-3,0,5,9] -> any height-balanced BST whose in-order is the input
    var nums = [_]i32{ -10, -3, 0, 5, 9 };
    const root = sortedArrayToBST(&nums, 5).?;
    try std.testing.expectEqual(@as(i32, 0), root.val); // the middle element is the root
    var idx: i32 = 0;
    try std.testing.expect(inorderOk(root, &nums, &idx));
    try std.testing.expectEqual(@as(i32, 5), idx);
    try std.testing.expect(balanced(root));
}

test "sortedArrayToBST edges" {
    // empty
    try std.testing.expect(sortedArrayToBST(undefined, 0) == null);

    // single element
    var one = [_]i32{42};
    const r1 = sortedArrayToBST(&one, 1).?;
    try std.testing.expectEqual(@as(i32, 42), r1.val);
    try std.testing.expect(r1.left == null and r1.right == null);

    // two elements: root is the first, right child the second
    var two = [_]i32{ 1, 2 };
    const r2 = sortedArrayToBST(&two, 2).?;
    var idx2: i32 = 0;
    try std.testing.expect(inorderOk(r2, &two, &idx2));
    try std.testing.expect(balanced(r2));

    // even length, larger array
    var many = [_]i32{ 1, 2, 3, 4, 5, 6, 7, 8 };
    const r3 = sortedArrayToBST(&many, 8).?;
    var idx3: i32 = 0;
    try std.testing.expect(inorderOk(r3, &many, &idx3));
    try std.testing.expectEqual(@as(i32, 8), idx3);
    try std.testing.expect(balanced(r3));
    try std.testing.expect(height(r3) <= 4);
}
