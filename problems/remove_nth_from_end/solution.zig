// LeetCode 19. Remove Nth Node From End of List
// C signature:
//   struct ListNode* removeNthFromEnd(struct ListNode* head, int n);
//
// A dummy head plus two pointers n apart: advance `fast` n steps, then walk
// both until `fast` reaches the last node. `slow` then sits just before the
// node to delete.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const ListNode = struct {
    val: i32,
    next: ?*ListNode,
};

pub fn removeNthFromEnd(head: ?*ListNode, n: i32) ?*ListNode {
    var dummy = ListNode{ .val = 0, .next = head };
    var fast: *ListNode = &dummy;
    var i: i32 = 0;
    while (i < n) : (i += 1) {
        fast = fast.next.?;
    }
    var slow: *ListNode = &dummy;
    while (fast.next != null) {
        fast = fast.next.?;
        slow = slow.next.?;
    }
    if (slow.next != null) slow.next = slow.next.?.next;
    return dummy.next;
}

fn make(vals: []const i32) ?*ListNode {
    var head: ?*ListNode = null;
    var i: usize = vals.len;
    while (i > 0) {
        i -= 1;
        const n = allocator.create(ListNode) catch unreachable;
        n.val = vals[i];
        n.next = head;
        head = n;
    }
    return head;
}

fn listEq(got: ?*ListNode, want: []const i32) bool {
    var k: usize = 0;
    var cur = got;
    while (cur) |node| : (k += 1) {
        if (k >= want.len) return false;
        if (node.val != want[k]) return false;
        cur = node.next;
    }
    return k == want.len;
}

test "removeNthFromEnd example" {
    try std.testing.expect(listEq(removeNthFromEnd(make(&[_]i32{ 1, 2, 3, 4, 5 }), 2), &[_]i32{ 1, 2, 3, 5 }));
    try std.testing.expect(listEq(removeNthFromEnd(make(&[_]i32{1}), 1), &[_]i32{}));
    try std.testing.expect(listEq(removeNthFromEnd(make(&[_]i32{ 1, 2 }), 1), &[_]i32{1}));
}

test "removeNthFromEnd edges" {
    // remove the head (n == length)
    try std.testing.expect(listEq(removeNthFromEnd(make(&[_]i32{ 1, 2, 3, 4, 5 }), 5), &[_]i32{ 2, 3, 4, 5 }));
    // remove the tail
    try std.testing.expect(listEq(removeNthFromEnd(make(&[_]i32{ 1, 2, 3 }), 1), &[_]i32{ 1, 2 }));
    // two nodes, remove the second
    try std.testing.expect(listEq(removeNthFromEnd(make(&[_]i32{ 1, 2 }), 2), &[_]i32{2}));
    // three nodes, remove the middle
    try std.testing.expect(listEq(removeNthFromEnd(make(&[_]i32{ 1, 2, 3 }), 2), &[_]i32{ 1, 3 }));
    // negative values
    try std.testing.expect(listEq(removeNthFromEnd(make(&[_]i32{ -5, -4, -3 }), 3), &[_]i32{ -4, -3 }));
}
