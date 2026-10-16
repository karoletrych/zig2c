// LeetCode 25. Reverse Nodes in k-Group
// C signature:
//   struct ListNode* reverseKGroup(struct ListNode* head, int k);
//
// For each group of k: find the k-th node (if it does not exist, stop), reverse
// the k nodes, then splice the group back after `groupPrev`.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const ListNode = struct {
    val: i32,
    next: ?*ListNode,
};

pub fn reverseKGroup(head: ?*ListNode, k: i32) ?*ListNode {
    if (head == null or k <= 1) return head;
    var dummy = ListNode{ .val = 0, .next = head };
    var groupPrev: *ListNode = &dummy;
    while (true) {
        // locate the k-th node of this group
        var kth: ?*ListNode = groupPrev;
        var i: i32 = 0;
        while (i < k and kth != null) : (i += 1) {
            kth = kth.?.next;
        }
        if (kth == null) break;
        const groupNext = kth.?.next;

        // reverse the k nodes after groupPrev
        var prev: ?*ListNode = groupNext;
        var cur = groupPrev.next;
        var j: i32 = 0;
        while (j < k) : (j += 1) {
            const nxt = cur.?.next;
            cur.?.next = prev;
            prev = cur;
            cur = nxt;
        }

        const newTail = groupPrev.next;
        groupPrev.next = kth;
        groupPrev = newTail.?;
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

test "reverseKGroup example" {
    try std.testing.expect(listEq(reverseKGroup(make(&[_]i32{ 1, 2, 3, 4, 5 }), 2), &[_]i32{ 2, 1, 4, 3, 5 }));
    try std.testing.expect(listEq(reverseKGroup(make(&[_]i32{ 1, 2, 3, 4, 5 }), 3), &[_]i32{ 3, 2, 1, 4, 5 }));
}

test "reverseKGroup edges" {
    // k == 1 (and k == 0) leave the list untouched
    try std.testing.expect(listEq(reverseKGroup(make(&[_]i32{ 1, 2, 3 }), 1), &[_]i32{ 1, 2, 3 }));
    try std.testing.expect(listEq(reverseKGroup(make(&[_]i32{ 1, 2, 3 }), 0), &[_]i32{ 1, 2, 3 }));
    // empty list
    try std.testing.expect(reverseKGroup(null, 2) == null);
    // single node
    try std.testing.expect(listEq(reverseKGroup(make(&[_]i32{7}), 2), &[_]i32{7}));
    // k larger than the list
    try std.testing.expect(listEq(reverseKGroup(make(&[_]i32{ 1, 2, 3 }), 9), &[_]i32{ 1, 2, 3 }));
    // exact multiple of k
    try std.testing.expect(listEq(reverseKGroup(make(&[_]i32{ 1, 2, 3, 4, 5, 6 }), 3), &[_]i32{ 3, 2, 1, 6, 5, 4 }));
    // single full group
    try std.testing.expect(listEq(reverseKGroup(make(&[_]i32{ 1, 2, 3 }), 3), &[_]i32{ 3, 2, 1 }));
    // no leftover
    try std.testing.expect(listEq(reverseKGroup(make(&[_]i32{ 1, 2, 3, 4, 5 }), 5), &[_]i32{ 5, 4, 3, 2, 1 }));
}
