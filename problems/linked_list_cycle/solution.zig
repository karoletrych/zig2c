// LeetCode 141. Linked List Cycle
// C signature:  bool hasCycle(struct ListNode* head);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const ListNode = struct {
    val: i32,
    next: ?*ListNode,
};

pub fn hasCycle(head: ?*ListNode) bool {
    if (head == null) return false;
    var slow: ?*ListNode = head;
    var fast: ?*ListNode = head;
    while (fast != null and fast.?.next != null) {
        slow = slow.?.next;
        const mid = fast.?.next;
        fast = mid.?.next;
        if (slow == fast) return true;
    }
    return false;
}

fn node(v: i32, nxt: ?*ListNode) *ListNode {
    const x = allocator.create(ListNode) catch unreachable;
    x.val = v;
    x.next = nxt;
    return x;
}

test "hasCycle example" {
    // 3 -> 2 -> 0 -> -4, tail connects back to index 1 (value 2)
    const c = node(-4, null);
    const b = node(0, c);
    const a = node(2, b);
    const h = node(3, a);
    try std.testing.expect(!hasCycle(h));
    c.next = a;
    try std.testing.expect(hasCycle(h));
    c.next = null;
    try std.testing.expect(!hasCycle(h));
}

test "hasCycle edges" {
    try std.testing.expect(!hasCycle(null));
    const solo = node(7, null);
    try std.testing.expect(!hasCycle(solo));
    solo.next = solo; // self loop
    try std.testing.expect(hasCycle(solo));
    solo.next = null;
    try std.testing.expect(!hasCycle(solo));

    // two nodes, cycle at the head
    const two = node(1, null);
    const twoB = node(2, two);
    try std.testing.expect(!hasCycle(twoB));
    two.next = twoB;
    try std.testing.expect(hasCycle(twoB));
    two.next = null;
    try std.testing.expect(!hasCycle(twoB));
}
