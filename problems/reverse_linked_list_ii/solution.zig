// LeetCode 92. Reverse Linked List II
// C signature:
//   struct ListNode* reverseBetween(struct ListNode* head, int left, int right);
//
// Walk to the node just before `left`, then repeatedly move the node after it
// to the front of the sub-list until `right` is reached.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const ListNode = struct {
    val: i32,
    next: ?*ListNode,
};

pub fn reverseBetween(head: ?*ListNode, left: i32, right: i32) ?*ListNode {
    if (head == null or left == right) return head;
    var dummy = ListNode{ .val = 0, .next = head };
    var prev: *ListNode = &dummy;
    var i: i32 = 1;
    while (i < left) : (i += 1) {
        prev = prev.next.?;
    }
    var cur = prev.next;
    var j: i32 = 0;
    const moves = right - left;
    while (j < moves) : (j += 1) {
        const nxt = cur.?.next;
        cur.?.next = nxt.?.next;
        nxt.?.next = prev.next;
        prev.next = nxt;
    }
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

test "reverseBetween example" {
    try std.testing.expect(listEq(reverseBetween(make(&[_]i32{ 1, 2, 3, 4, 5 }), 2, 4), &[_]i32{ 1, 4, 3, 2, 5 }));
    try std.testing.expect(listEq(reverseBetween(make(&[_]i32{5}), 1, 1), &[_]i32{5}));
}

test "reverseBetween edges" {
    // left == right leaves the list unchanged
    try std.testing.expect(listEq(reverseBetween(make(&[_]i32{ 1, 2, 3 }), 2, 2), &[_]i32{ 1, 2, 3 }));
    // the whole list
    try std.testing.expect(listEq(reverseBetween(make(&[_]i32{ 1, 2, 3, 4 }), 1, 4), &[_]i32{ 4, 3, 2, 1 }));
    // a two-element prefix
    try std.testing.expect(listEq(reverseBetween(make(&[_]i32{ 3, 5 }), 1, 2), &[_]i32{ 5, 3 }));
    // the last two elements
    try std.testing.expect(listEq(reverseBetween(make(&[_]i32{ 1, 2, 3 }), 2, 3), &[_]i32{ 1, 3, 2 }));
    // empty list
    try std.testing.expect(reverseBetween(null, 1, 1) == null);
    // negative values
    try std.testing.expect(listEq(reverseBetween(make(&[_]i32{ -1, -2, -3, -4 }), 1, 3), &[_]i32{ -3, -2, -1, -4 }));
}
