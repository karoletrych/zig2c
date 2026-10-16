// LeetCode 205. Isomorphic Strings
// C signature:  bool isIsomorphic(char* s, char* t);
//
// Two 256-slot maps enforce that the correspondence is a bijection: s[i] must
// always map to t[i] and t[i] must always map back to s[i].
const std = @import("std");

pub fn isIsomorphic(s: [*]u8, t: [*]u8) bool {
    const a = std.mem.sliceTo(s, 0);
    const b = std.mem.sliceTo(t, 0);
    if (a.len != b.len) return false;

    var forward: [256]i32 = undefined;
    var backward: [256]i32 = undefined;
    var i: usize = 0;
    while (i < 256) : (i += 1) {
        forward[i] = -1;
        backward[i] = -1;
    }

    i = 0;
    while (i < a.len) : (i += 1) {
        const ca = a[i];
        const cb = b[i];
        const ia: usize = @intCast(ca);
        const ib: usize = @intCast(cb);
        if (forward[ia] == -1) {
            if (backward[ib] != -1) return false;
            forward[ia] = cb;
            backward[ib] = ca;
        } else if (forward[ia] != @as(i32, @intCast(cb))) {
            return false;
        }
    }
    return true;
}

test "isIsomorphic examples" {
    try std.testing.expect(isIsomorphic(@constCast("egg"), @constCast("add")));
    try std.testing.expect(!isIsomorphic(@constCast("foo"), @constCast("bar")));
    try std.testing.expect(isIsomorphic(@constCast("paper"), @constCast("title")));
    try std.testing.expect(!isIsomorphic(@constCast("badc"), @constCast("baba")));
    try std.testing.expect(isIsomorphic(@constCast(""), @constCast("")));
    try std.testing.expect(!isIsomorphic(@constCast("a"), @constCast("ab")));
}
