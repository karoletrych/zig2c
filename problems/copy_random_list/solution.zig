// LeetCode 138. Copy List with Random Pointer
// C signature:  struct Node* copyRandomList(struct Node* head);
//
// O(1)-extra-space weave: clone each node in place right after its original
// (A -> A' -> B -> B' ...), wire the copies' `random` pointers using the
// originals' `random.next`, then split the interleaved list back into two.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const Node = struct {
    val: i32,
    next: ?*Node,
    random: ?*Node,
};

pub fn copyRandomList(head: ?*Node) ?*Node {
    if (head == null) return null;

    // 1. weave the copies in
    var cur: ?*Node = head;
    while (cur) |node| {
        const cp = allocator.create(Node) catch unreachable;
        cp.val = node.val;
        cp.next = node.next;
        cp.random = null;
        node.next = cp;
        cur = cp.next;
    }

    // 2. point the copies' random fields at the copies
    cur = head;
    while (cur) |node| {
        const cp = node.next.?;
        if (node.random) |r| {
            cp.random = r.next;
        }
        cur = cp.next;
    }

    // 3. split the interleaving back into the original and the copy
    const newHead = head.?.next;
    cur = head;
    while (cur) |node| {
        const cp = node.next.?;
        const nxt = cp.next;
        node.next = nxt;
        cp.next = null;
        if (nxt) |other| {
            cp.next = other.next;
        }
        cur = nxt;
    }
    return newHead;
}

fn mk(v: i32, nxt: ?*Node, rnd: ?*Node) *Node {
    const n = allocator.create(Node) catch unreachable;
    n.val = v;
    n.next = nxt;
    n.random = rnd;
    return n;
}

// Test-only: the deep structure (values, links and that every copy is a fresh
// node) must match, and none of the copy's pointers may alias the original's.
fn cloneOK(orig: ?*Node, copy: ?*Node) bool {
    var x = orig;
    var y = copy;
    while (x != null and y != null) {
        if (x.?.val != y.?.val) return false;
        if (x == y) return false;
        if (x.?.random == null) {
            if (y.?.random != null) return false;
        } else {
            if (y.?.random == null) return false;
            if (x.?.random.?.val != y.?.random.?.val) return false;
            if (x.?.random == y.?.random) return false;
        }
        x = x.?.next;
        y = y.?.next;
    }
    return x == null and y == null;
}

test "copyRandomList example" {
    // [[7,null],[13,0],[11,4],[10,2],[1,0]]
    var n0 = mk(7, null, null);
    const n1 = mk(13, null, null);
    const n2 = mk(11, null, null);
    const n3 = mk(10, null, null);
    const n4 = mk(1, null, null);
    n0.next = n1;
    n1.next = n2;
    n2.next = n3;
    n3.next = n4;
    n1.random = n0;
    n2.random = n4;
    n3.random = n2;
    n4.random = n0;

    const cp = copyRandomList(n0);
    try std.testing.expect(cloneOK(n0, cp));
    // the original list is unchanged
    try std.testing.expectEqual(@as(i32, 13), n0.next.?.val);
    try std.testing.expect(n0.random == null);
    try std.testing.expect(cp != null);
    try std.testing.expect(cp != n0);
}

test "copyRandomList edges" {
    try std.testing.expect(copyRandomList(null) == null);

    // single node with random pointing at itself
    const solo = mk(-1, null, null);
    solo.random = solo;
    const soloCopy = copyRandomList(solo);
    try std.testing.expect(cloneOK(solo, soloCopy));
    try std.testing.expect(soloCopy.?.random == soloCopy);
    try std.testing.expect(soloCopy.?.random != solo);

    // single node with no random
    const bare = mk(5, null, null);
    const bareCopy = copyRandomList(bare);
    try std.testing.expect(cloneOK(bare, bareCopy));
    try std.testing.expect(bareCopy.?.random == null);
}
