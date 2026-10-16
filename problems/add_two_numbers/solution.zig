// LeetCode 2. Add Two Numbers
// C signature:
//   struct ListNode* addTwoNumbers(struct ListNode* l1, struct ListNode* l2);
//
// Digits are stored least-significant first, so a single pass with a carry does
// the whole job.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const ListNode = struct {
    val: i32,
    next: ?*ListNode,
};

pub fn addTwoNumbers(l1: ?*ListNode, l2: ?*ListNode) ?*ListNode {
    var dummy = ListNode{ .val = 0, .next = null };
    var tail: *ListNode = &dummy;
    var a = l1;
    var b = l2;
    var carry: i32 = 0;
    while (a != null or b != null or carry != 0) {
        var sum = carry;
        if (a != null) {
            sum += a.?.val;
            a = a.?.next;
        }
        if (b != null) {
            sum += b.?.val;
            b = b.?.next;
        }
        carry = @divTrunc(sum, 10);
        const node = allocator.create(ListNode) catch unreachable;
        node.val = sum - carry * 10;
        node.next = null;
        tail.next = node;
        tail = node;
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

test "addTwoNumbers example" {
    // 342 + 465 = 807  ->  [7,0,8]
    try std.testing.expect(listEq(addTwoNumbers(make(&[_]i32{ 2, 4, 3 }), make(&[_]i32{ 5, 6, 4 })), &[_]i32{ 7, 0, 8 }));
    // 0 + 0 = 0
    try std.testing.expect(listEq(addTwoNumbers(make(&[_]i32{0}), make(&[_]i32{0})), &[_]i32{0}));
    // 9999999 + 9999 = 10009998
    try std.testing.expect(listEq(addTwoNumbers(make(&[_]i32{ 9, 9, 9, 9, 9, 9, 9 }), make(&[_]i32{ 9, 9, 9, 9 })), &[_]i32{ 8, 9, 9, 9, 0, 0, 0, 1 }));
    // 1 + 99 = 100
    try std.testing.expect(listEq(addTwoNumbers(make(&[_]i32{1}), make(&[_]i32{ 9, 9 })), &[_]i32{ 0, 0, 1 }));
    // 5 + 5 = 10 -> [0,1]
    try std.testing.expect(listEq(addTwoNumbers(make(&[_]i32{5}), make(&[_]i32{5})), &[_]i32{ 0, 1 }));
}

test "addTwoNumbers empty and single" {
    try std.testing.expect(addTwoNumbers(null, null) == null);
    try std.testing.expect(listEq(addTwoNumbers(null, make(&[_]i32{ 1, 2, 3 })), &[_]i32{ 1, 2, 3 }));
    try std.testing.expect(listEq(addTwoNumbers(make(&[_]i32{ 4, 5 }), null), &[_]i32{ 4, 5 }));
    try std.testing.expect(listEq(addTwoNumbers(null, make(&[_]i32{9})), &[_]i32{9}));
    // 9 + 9 = 18 -> [8,1]
    try std.testing.expect(listEq(addTwoNumbers(make(&[_]i32{9}), make(&[_]i32{9})), &[_]i32{ 8, 1 }));
}
