// LeetCode 2130. Maximum Twin Sum of a Linked List
// C signature:  int pairSum(struct ListNode* head);
//
// Slow/fast pointers find the middle, the second half is reversed in place,
// then the two halves are walked together to find the maximum twin sum.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const ListNode = struct {
    val: i32,
    next: ?*ListNode,
};

pub fn pairSum(head: ?*ListNode) i32 {
    var slow: ?*ListNode = head;
    var fast: ?*ListNode = head;
    while (fast != null and fast.?.next != null) {
        slow = slow.?.next;
        fast = fast.?.next.?.next;
    }

    var prev: ?*ListNode = null;
    var cur = slow;
    while (cur) |node| {
        const nxt = node.next;
        node.next = prev;
        prev = node;
        cur = nxt;
    }

    var best: i32 = 0;
    var a: ?*ListNode = head;
    var b: ?*ListNode = prev;
    while (b != null) {
        const s = a.?.val + b.?.val;
        if (s > best) best = s;
        a = a.?.next;
        b = b.?.next;
    }
    return best;
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

test "pairSum" {
    try std.testing.expectEqual(@as(i32, 6), pairSum(make(&[_]i32{ 5, 4, 2, 1 })));
    try std.testing.expectEqual(@as(i32, 7), pairSum(make(&[_]i32{ 4, 2, 2, 3 })));
    try std.testing.expectEqual(@as(i32, 100001), pairSum(make(&[_]i32{ 1, 100000 })));
    try std.testing.expectEqual(@as(i32, 3), pairSum(make(&[_]i32{ 1, 2 })));
    try std.testing.expectEqual(@as(i32, 7), pairSum(make(&[_]i32{ 1, 2, 3, 4, 5, 6 })));
}
