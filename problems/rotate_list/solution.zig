// LeetCode 61. Rotate List
// C signature:  struct ListNode* rotateRight(struct ListNode* head, int k);
//
// Measure the length, reduce k, close the list into a ring, then break it at
// the new tail (len - k - 1 steps from the head).
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const ListNode = struct {
    val: i32,
    next: ?*ListNode,
};

pub fn rotateRight(head: ?*ListNode, k: i32) ?*ListNode {
    if (head == null or head.?.next == null) return head;
    var len: i32 = 1;
    var tail = head.?;
    while (tail.next != null) {
        tail = tail.next.?;
        len += 1;
    }
    // Reduce k modulo len. Written with @divTrunc (rather than @mod) so the Zig
    // and the generated C agree for negative k as well.
    const q = @divTrunc(k, len);
    var kk = k - q * len;
    if (kk < 0) kk += len;
    if (kk == 0) return head;

    tail.next = head; // make it a ring
    var newTail = head.?;
    const steps = len - kk - 1;
    var i: i32 = 0;
    while (i < steps) : (i += 1) {
        newTail = newTail.next.?;
    }
    const newHead = newTail.next;
    newTail.next = null;
    return newHead;
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

test "rotateRight example" {
    try std.testing.expect(listEq(rotateRight(make(&[_]i32{ 1, 2, 3, 4, 5 }), 2), &[_]i32{ 4, 5, 1, 2, 3 }));
    try std.testing.expect(listEq(rotateRight(make(&[_]i32{ 0, 1, 2 }), 4), &[_]i32{ 2, 0, 1 }));
}

test "rotateRight edges" {
    // k == 0 leaves the list alone
    try std.testing.expect(listEq(rotateRight(make(&[_]i32{ 1, 2, 3 }), 0), &[_]i32{ 1, 2, 3 }));
    // k == length leaves the list alone
    try std.testing.expect(listEq(rotateRight(make(&[_]i32{ 1, 2, 3 }), 3), &[_]i32{ 1, 2, 3 }));
    // k bigger than the length wraps
    try std.testing.expect(listEq(rotateRight(make(&[_]i32{ 1, 2, 3 }), 2000000000), &[_]i32{ 2, 3, 1 }));
    // empty list
    try std.testing.expect(rotateRight(null, 3) == null);
    // single node
    try std.testing.expect(listEq(rotateRight(make(&[_]i32{9}), 5), &[_]i32{9}));
    // rotate by the full length minus one
    try std.testing.expect(listEq(rotateRight(make(&[_]i32{ 1, 2, 3 }), 2), &[_]i32{ 2, 3, 1 }));
    // rotate by one
    try std.testing.expect(listEq(rotateRight(make(&[_]i32{ 1, 2 }), 1), &[_]i32{ 2, 1 }));
    // negative k reduces the same way in Zig and in C
    try std.testing.expect(listEq(rotateRight(make(&[_]i32{ 1, 2, 3, 4, 5 }), -1), &[_]i32{ 2, 3, 4, 5, 1 }));
    try std.testing.expect(listEq(rotateRight(make(&[_]i32{ 1, 2, 3 }), -4), &[_]i32{ 2, 3, 1 }));
    try std.testing.expect(listEq(rotateRight(make(&[_]i32{ 1, 2, 3 }), -3), &[_]i32{ 1, 2, 3 }));
}
