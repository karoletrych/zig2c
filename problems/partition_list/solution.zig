// LeetCode 86. Partition List
// C signature:  struct ListNode* partition(struct ListNode* head, int x);
//
// Two dummy-headed chains: values < x go into one, the rest into the other.
// Concatenate at the end, preserving the relative order in each chain.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const ListNode = struct {
    val: i32,
    next: ?*ListNode,
};

pub fn partition(head: ?*ListNode, x: i32) ?*ListNode {
    var less = ListNode{ .val = 0, .next = null };
    var more = ListNode{ .val = 0, .next = null };
    var lt: *ListNode = &less;
    var mt: *ListNode = &more;
    var cur = head;
    while (cur) |node| {
        if (node.val < x) {
            lt.next = node;
            lt = node;
        } else {
            mt.next = node;
            mt = node;
        }
        cur = node.next;
    }
    mt.next = null;
    lt.next = more.next;
    return less.next;
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

test "partition example" {
    try std.testing.expect(listEq(partition(make(&[_]i32{ 1, 4, 3, 2, 5, 2 }), 3), &[_]i32{ 1, 2, 2, 4, 3, 5 }));
    try std.testing.expect(listEq(partition(make(&[_]i32{ 2, 1 }), 2), &[_]i32{ 1, 2 }));
}

test "partition edges" {
    // empty list
    try std.testing.expect(partition(null, 5) == null);
    // single node below / above
    try std.testing.expect(listEq(partition(make(&[_]i32{1}), 2), &[_]i32{1}));
    try std.testing.expect(listEq(partition(make(&[_]i32{5}), 2), &[_]i32{5}));
    // nothing is less than x
    try std.testing.expect(listEq(partition(make(&[_]i32{ 1, 4, 3, 2, 5, 2 }), 0), &[_]i32{ 1, 4, 3, 2, 5, 2 }));
    // everything is less than x
    try std.testing.expect(listEq(partition(make(&[_]i32{ 1, 4, 3, 2, 5, 2 }), 10), &[_]i32{ 1, 4, 3, 2, 5, 2 }));
    // already partitioned
    try std.testing.expect(listEq(partition(make(&[_]i32{ 1, 2, 2, 4, 3, 5 }), 3), &[_]i32{ 1, 2, 2, 4, 3, 5 }));
    // all equal to x
    try std.testing.expect(listEq(partition(make(&[_]i32{ 3, 3, 3 }), 3), &[_]i32{ 3, 3, 3 }));
    // negative values
    try std.testing.expect(listEq(partition(make(&[_]i32{ -1, 2, -3, 4 }), 0), &[_]i32{ -1, -3, 2, 4 }));
}
