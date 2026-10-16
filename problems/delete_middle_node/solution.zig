// LeetCode 2095. Delete the Middle Node of a Linked List
// C signature:  struct ListNode* deleteMiddle(struct ListNode* head);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const ListNode = struct {
    val: i32,
    next: ?*ListNode,
};

pub fn deleteMiddle(head: ?*ListNode) ?*ListNode {
    var dummy = ListNode{ .val = 0, .next = head };
    var slow: *ListNode = &dummy;
    var fast: ?*ListNode = head;
    while (fast != null and fast.?.next != null) {
        slow = slow.next.?;
        fast = fast.?.next.?.next;
    }
    slow.next = slow.next.?.next;
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

test "deleteMiddle" {
    try std.testing.expect(listEq(deleteMiddle(make(&[_]i32{ 1, 2, 3, 4, 5 })), &[_]i32{ 1, 2, 4, 5 }));
    try std.testing.expect(listEq(deleteMiddle(make(&[_]i32{ 1, 2, 3, 4 })), &[_]i32{ 1, 2, 4 }));
    try std.testing.expect(listEq(deleteMiddle(make(&[_]i32{ 1, 2, 3 })), &[_]i32{ 1, 3 }));
    try std.testing.expect(listEq(deleteMiddle(make(&[_]i32{ 1, 2 })), &[_]i32{1}));
    try std.testing.expect(listEq(deleteMiddle(make(&[_]i32{1})), &[_]i32{}));
}
