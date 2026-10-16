// LeetCode 21. Merge Two Sorted Lists  (LeetCode 75)
// C signature:  struct ListNode* mergeTwoLists(struct ListNode* list1, struct ListNode* list2);
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const ListNode = struct {
    val: i32,
    next: ?*ListNode,
};

pub fn mergeTwoLists(list1: ?*ListNode, list2: ?*ListNode) ?*ListNode {
    var dummy = ListNode{ .val = 0, .next = null };
    var tail: *ListNode = &dummy;
    var a = list1;
    var b = list2;
    while (a != null and b != null) {
        if (a.?.val <= b.?.val) {
            tail.next = a;
            a = a.?.next;
        } else {
            tail.next = b;
            b = b.?.next;
        }
        tail = tail.next.?;
    }
    if (a != null) tail.next = a else tail.next = b;
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

test "mergeTwoLists" {
    const a = make(&[_]i32{ 1, 2, 4 });
    const b = make(&[_]i32{ 1, 3, 4 });
    var cur = mergeTwoLists(a, b);
    const want = [_]i32{ 1, 1, 2, 3, 4, 4 };
    var k: usize = 0;
    while (cur) |node| : (k += 1) {
        try std.testing.expectEqual(want[k], node.val);
        cur = node.next;
    }
    try std.testing.expectEqual(@as(usize, 6), k);
}
