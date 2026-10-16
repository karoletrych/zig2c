// LeetCode 328. Odd Even Linked List
// C signature:  struct ListNode* oddEvenList(struct ListNode* head);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const ListNode = struct {
    val: i32,
    next: ?*ListNode,
};

pub fn oddEvenList(head: ?*ListNode) ?*ListNode {
    if (head == null) return null;
    var odd: ?*ListNode = head;
    var even: ?*ListNode = head.?.next;
    const evenHead = even;
    while (even != null and even.?.next != null) {
        odd.?.next = even.?.next;
        odd = odd.?.next;
        even.?.next = odd.?.next;
        even = even.?.next;
    }
    odd.?.next = evenHead;
    return head;
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

test "oddEvenList" {
    try std.testing.expect(listEq(oddEvenList(make(&[_]i32{ 1, 2, 3, 4, 5 })), &[_]i32{ 1, 3, 5, 2, 4 }));
    try std.testing.expect(listEq(oddEvenList(make(&[_]i32{ 2, 1, 3, 5, 6, 4, 7 })), &[_]i32{ 2, 3, 6, 7, 1, 5, 4 }));
    try std.testing.expect(listEq(oddEvenList(make(&[_]i32{ 1, 2 })), &[_]i32{ 1, 2 }));
    try std.testing.expect(listEq(oddEvenList(make(&[_]i32{1})), &[_]i32{1}));
    try std.testing.expect(listEq(oddEvenList(null), &[_]i32{}));
}
