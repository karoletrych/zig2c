// LeetCode 23. Merge k Sorted Lists
// C signature:  struct ListNode* mergeKLists(struct ListNode** lists, int listsSize);
//
// Iterative pairwise merging: fold the array of list heads in place, halving the
// number of live lists every round, for O(N log k) total work. The write index
// never overtakes the read index, so the array can be reused as scratch.
const std = @import("std");

pub const ListNode = struct {
    val: i32,
    next: ?*ListNode,
};

fn mergeTwo(a0: ?*ListNode, b0: ?*ListNode) ?*ListNode {
    var dummy = ListNode{ .val = 0, .next = null };
    var tail: *ListNode = &dummy;
    var a = a0;
    var b = b0;
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

pub fn mergeKLists(lists: [*]?*ListNode, listsSize: i32) ?*ListNode {
    if (listsSize <= 0) return null;
    var n: usize = @intCast(listsSize);
    while (n > 1) {
        var w: usize = 0;
        var i: usize = 0;
        while (i < n) : (i += 2) {
            if (i + 1 < n) {
                lists[w] = mergeTwo(lists[i], lists[i + 1]);
            } else {
                lists[w] = lists[i];
            }
            w += 1;
        }
        n = w;
    }
    return lists[0];
}

fn make(vals: []const i32) ?*ListNode {
    var head: ?*ListNode = null;
    var i: usize = vals.len;
    while (i > 0) {
        i -= 1;
        const n = std.heap.c_allocator.create(ListNode) catch unreachable;
        n.val = vals[i];
        n.next = head;
        head = n;
    }
    return head;
}

fn expectList(start: ?*ListNode, want: []const i32) !void {
    var cur = start;
    var k: usize = 0;
    while (cur) |node| : (k += 1) {
        try std.testing.expect(k < want.len);
        try std.testing.expectEqual(want[k], node.val);
        cur = node.next;
    }
    try std.testing.expectEqual(want.len, k);
}

test "mergeKLists example" {
    var lists = [_]?*ListNode{
        make(&[_]i32{ 1, 4, 5 }),
        make(&[_]i32{ 1, 3, 4 }),
        make(&[_]i32{ 2, 6 }),
    };
    try expectList(mergeKLists(&lists, 3), &[_]i32{ 1, 1, 2, 3, 4, 4, 5, 6 });
}

test "mergeKLists edges" {
    // no lists at all
    var empty = [_]?*ListNode{null};
    try std.testing.expect(mergeKLists(&empty, 0) == null);

    // a single list is returned untouched
    var one = [_]?*ListNode{make(&[_]i32{ 2, 5, 9 })};
    try expectList(mergeKLists(&one, 1), &[_]i32{ 2, 5, 9 });

    // NULL lists interleaved with real ones
    var mixed = [_]?*ListNode{
        null,
        make(&[_]i32{1}),
        null,
        make(&[_]i32{ 0, 2 }),
    };
    try expectList(mergeKLists(&mixed, 4), &[_]i32{ 0, 1, 2 });

    // every list empty
    var allNull = [_]?*ListNode{ null, null, null };
    try std.testing.expect(mergeKLists(&allNull, 3) == null);

    // duplicates and negatives
    var neg = [_]?*ListNode{
        make(&[_]i32{ -5, -1, 3 }),
        make(&[_]i32{ -4, -1, 3, 3 }),
        make(&[_]i32{ -1 }),
    };
    try expectList(mergeKLists(&neg, 3), &[_]i32{ -5, -4, -1, -1, -1, 3, 3, 3 });
}
