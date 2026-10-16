// LeetCode 206. Reverse Linked List
// C signature:  struct ListNode* reverseList(struct ListNode* head);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const ListNode = struct {
    val: i32,
    next: ?*ListNode,
};

pub fn reverseList(head: ?*ListNode) ?*ListNode {
    var prev: ?*ListNode = null;
    var cur = head;
    while (cur) |node| {
        const nxt = node.next;
        node.next = prev;
        prev = node;
        cur = nxt;
    }
    return prev;
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

test "reverseList" {
    try std.testing.expect(listEq(reverseList(make(&[_]i32{ 1, 2, 3, 4, 5 })), &[_]i32{ 5, 4, 3, 2, 1 }));
    try std.testing.expect(listEq(reverseList(make(&[_]i32{ 1, 2 })), &[_]i32{ 2, 1 }));
    try std.testing.expect(listEq(reverseList(make(&[_]i32{1})), &[_]i32{1}));
    try std.testing.expect(listEq(reverseList(null), &[_]i32{}));
}
