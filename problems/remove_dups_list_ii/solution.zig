// LeetCode 82. Remove Duplicates from Sorted List II
// C signature:  struct ListNode* deleteDuplicates(struct ListNode* head);
//
// When `prev.next` starts a run of equal values, skip the whole run at once;
// otherwise advance. A dummy head makes deleting the first node uniform.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const ListNode = struct {
    val: i32,
    next: ?*ListNode,
};

pub fn deleteDuplicates(head: ?*ListNode) ?*ListNode {
    var dummy = ListNode{ .val = 0, .next = head };
    var prev: *ListNode = &dummy;
    while (prev.next != null) {
        const cur = prev.next.?;
        if (cur.next != null and cur.next.?.val == cur.val) {
            const v = cur.val;
            var x: ?*ListNode = prev.next;
            while (x != null and x.?.val == v) {
                x = x.?.next;
            }
            prev.next = x;
        } else {
            prev = cur;
        }
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

test "deleteDuplicates example" {
    try std.testing.expect(listEq(deleteDuplicates(make(&[_]i32{ 1, 2, 3, 3, 4, 4, 5 })), &[_]i32{ 1, 2, 5 }));
    try std.testing.expect(listEq(deleteDuplicates(make(&[_]i32{ 1, 1, 1, 2, 3 })), &[_]i32{ 2, 3 }));
}

test "deleteDuplicates edges" {
    // empty list
    try std.testing.expect(deleteDuplicates(null) == null);
    // single node
    try std.testing.expect(listEq(deleteDuplicates(make(&[_]i32{1})), &[_]i32{1}));
    // everything duplicated -> empty
    try std.testing.expect(listEq(deleteDuplicates(make(&[_]i32{ 1, 1 })), &[_]i32{}));
    try std.testing.expect(listEq(deleteDuplicates(make(&[_]i32{ 1, 1, 2, 2 })), &[_]i32{}));
    // no duplicates at all
    try std.testing.expect(listEq(deleteDuplicates(make(&[_]i32{ 1, 2, 3 })), &[_]i32{ 1, 2, 3 }));
    // leading run of two
    try std.testing.expect(listEq(deleteDuplicates(make(&[_]i32{ 1, 1, 2 })), &[_]i32{2}));
    // trailing run of two
    try std.testing.expect(listEq(deleteDuplicates(make(&[_]i32{ 1, 2, 2 })), &[_]i32{1}));
    // negative values
    try std.testing.expect(listEq(deleteDuplicates(make(&[_]i32{ -3, -1, -1, 0, 0, 2 })), &[_]i32{ -3, 2 }));
}
