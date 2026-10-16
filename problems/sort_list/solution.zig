// LeetCode 148. Sort List
// C signature:  struct ListNode* sortList(struct ListNode* head);
//
// Bottom-up-free top-down merge sort: split the list in half with the
// slow/fast pointer trick, sort each half, then merge with a dummy head.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const ListNode = struct {
    val: i32,
    next: ?*ListNode,
};

fn merge(a: ?*ListNode, b: ?*ListNode) ?*ListNode {
    var dummy = ListNode{ .val = 0, .next = null };
    var tail: *ListNode = &dummy;
    var x = a;
    var y = b;
    while (x != null and y != null) {
        if (x.?.val <= y.?.val) {
            tail.next = x;
            x = x.?.next;
        } else {
            tail.next = y;
            y = y.?.next;
        }
        tail = tail.next.?;
    }
    if (x != null) {
        tail.next = x;
    } else {
        tail.next = y;
    }
    return dummy.next;
}

pub fn sortList(head: ?*ListNode) ?*ListNode {
    if (head == null or head.?.next == null) return head;

    // split: slow ends on the last node of the first half
    var slow: ?*ListNode = head;
    var fast: ?*ListNode = head.?.next;
    while (fast != null and fast.?.next != null) {
        slow = slow.?.next;
        fast = fast.?.next.?.next;
    }
    const mid = slow.?.next;
    slow.?.next = null;

    const left = sortList(head);
    const right = sortList(mid);
    return merge(left, right);
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

test "sortList examples" {
    try std.testing.expect(listEq(sortList(make(&[_]i32{ 4, 2, 1, 3 })), &[_]i32{ 1, 2, 3, 4 }));
    try std.testing.expect(listEq(sortList(make(&[_]i32{ -1, 5, 3, 4, 0 })), &[_]i32{ -1, 0, 3, 4, 5 }));
}

test "sortList edges" {
    // empty and single element
    try std.testing.expect(listEq(sortList(null), &[_]i32{}));
    try std.testing.expect(listEq(sortList(make(&[_]i32{7})), &[_]i32{7}));

    // two elements, both orders
    try std.testing.expect(listEq(sortList(make(&[_]i32{ 2, 1 })), &[_]i32{ 1, 2 }));
    try std.testing.expect(listEq(sortList(make(&[_]i32{ 1, 2 })), &[_]i32{ 1, 2 }));

    // duplicates
    try std.testing.expect(listEq(sortList(make(&[_]i32{ 3, 3, 1, 1, 2, 2 })), &[_]i32{ 1, 1, 2, 2, 3, 3 }));

    // already sorted and reverse sorted
    try std.testing.expect(listEq(sortList(make(&[_]i32{ 1, 2, 3, 4, 5 })), &[_]i32{ 1, 2, 3, 4, 5 }));
    try std.testing.expect(listEq(sortList(make(&[_]i32{ 5, 4, 3, 2, 1 })), &[_]i32{ 1, 2, 3, 4, 5 }));

    // negatives only
    try std.testing.expect(listEq(sortList(make(&[_]i32{ -3, -1, -2 })), &[_]i32{ -3, -2, -1 }));

    // larger reverse list: 12 down to 1
    var big: [12]i32 = undefined;
    var i: usize = 0;
    while (i < 12) : (i += 1) big[i] = 12 - @as(i32, @intCast(i));
    var want: [12]i32 = undefined;
    i = 0;
    while (i < 12) : (i += 1) want[i] = @as(i32, @intCast(i)) + 1;
    try std.testing.expect(listEq(sortList(make(&big)), &want));
}
