// LeetCode 49. Group Anagrams
// C signature:
//   char*** groupAnagrams(char** strs, int strsSize, int* returnSize,
//                         int** returnColumnSizes);
//
// Every string gets a 26-byte letter-count signature; strings with equal
// signatures are anagrams. Groups are discovered by a quadratic sweep (the
// input is small) and each output row is a fresh copy of the original strings.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn dupeZ(src: [*]u8) [*]u8 {
    const s = std.mem.sliceTo(src, 0);
    const buf = allocator.alloc(u8, s.len + 1) catch unreachable;
    var i: usize = 0;
    while (i < s.len) : (i += 1) buf[i] = s[i];
    buf[s.len] = 0;
    return buf.ptr;
}

pub fn groupAnagrams(strs: [*][*]u8, strsSize: i32, returnSize: *i32, returnColumnSizes: [*][*]i32) ?[*][*][*]u8 {
    const n: usize = @intCast(strsSize);
    if (n == 0) {
        const empty_rows = allocator.alloc([*][*]u8, 1) catch unreachable;
        const empty_cols = allocator.alloc(i32, 1) catch unreachable;
        returnColumnSizes[0] = empty_cols.ptr;
        returnSize.* = 0;
        return empty_rows.ptr;
    }

    const sigs = allocator.alloc(u8, n * 26) catch unreachable;
    var i: usize = 0;
    while (i < n) : (i += 1) {
        var k: usize = 0;
        while (k < 26) : (k += 1) sigs[i * 26 + k] = 0;
        const s = std.mem.sliceTo(strs[i], 0);
        for (s) |c| {
            if (c >= 'a' and c <= 'z') {
                sigs[i * 26 + @as(usize, @intCast(c - 'a'))] += 1;
            }
        }
    }

    const gid = allocator.alloc(i32, n) catch unreachable;
    i = 0;
    while (i < n) : (i += 1) gid[i] = -1;

    var ngroups: usize = 0;
    i = 0;
    while (i < n) : (i += 1) {
        if (gid[i] != -1) continue;
        gid[i] = @intCast(ngroups);
        var j: usize = i + 1;
        while (j < n) : (j += 1) {
            if (gid[j] != -1) continue;
            var same = true;
            var k: usize = 0;
            while (k < 26) : (k += 1) {
                if (sigs[i * 26 + k] != sigs[j * 26 + k]) {
                    same = false;
                    break;
                }
            }
            if (same) gid[j] = @intCast(ngroups);
        }
        ngroups += 1;
    }

    const outer = allocator.alloc([*][*]u8, ngroups) catch unreachable;
    const cols = allocator.alloc(i32, ngroups) catch unreachable;
    const fill = allocator.alloc(i32, ngroups) catch unreachable;

    i = 0;
    while (i < ngroups) : (i += 1) fill[i] = 0;
    i = 0;
    while (i < n) : (i += 1) fill[@intCast(gid[i])] += 1;

    i = 0;
    while (i < ngroups) : (i += 1) {
        cols[i] = fill[i];
        const row = allocator.alloc([*]u8, @intCast(fill[i])) catch unreachable;
        outer[i] = row.ptr;
        fill[i] = 0;
    }

    i = 0;
    while (i < n) : (i += 1) {
        const g: usize = @intCast(gid[i]);
        const f: usize = @intCast(fill[g]);
        outer[g][f] = dupeZ(strs[i]);
        fill[g] += 1;
    }

    returnColumnSizes[0] = cols.ptr;
    returnSize.* = @intCast(ngroups);
    return outer.ptr;
}

test "groupAnagrams example" {
    var strs = [_][*]u8{
        @constCast("eat"),
        @constCast("tea"),
        @constCast("tan"),
        @constCast("ate"),
        @constCast("nat"),
        @constCast("bat"),
    };
    var cb: [1][*]i32 = undefined;
    var rs: i32 = 0;
    const r = groupAnagrams(&strs, 6, &rs, &cb).?;

    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqual(@as(i32, 3), cb[0][0]);
    try std.testing.expectEqual(@as(i32, 2), cb[0][1]);
    try std.testing.expectEqual(@as(i32, 1), cb[0][2]);

    try std.testing.expectEqualStrings("eat", std.mem.span(@as([*:0]u8, @ptrCast(r[0][0]))));
    try std.testing.expectEqualStrings("tea", std.mem.span(@as([*:0]u8, @ptrCast(r[0][1]))));
    try std.testing.expectEqualStrings("ate", std.mem.span(@as([*:0]u8, @ptrCast(r[0][2]))));
    try std.testing.expectEqualStrings("tan", std.mem.span(@as([*:0]u8, @ptrCast(r[1][0]))));
    try std.testing.expectEqualStrings("nat", std.mem.span(@as([*:0]u8, @ptrCast(r[1][1]))));
    try std.testing.expectEqualStrings("bat", std.mem.span(@as([*:0]u8, @ptrCast(r[2][0]))));
}

test "groupAnagrams single and empty groups" {
    var one = [_][*]u8{@constCast("a")};
    var cb: [1][*]i32 = undefined;
    var rs: i32 = 0;
    const r = groupAnagrams(&one, 1, &rs, &cb).?;
    try std.testing.expectEqual(@as(i32, 1), rs);
    try std.testing.expectEqual(@as(i32, 1), cb[0][0]);
    try std.testing.expectEqualStrings("a", std.mem.span(@as([*:0]u8, @ptrCast(r[0][0]))));

    var rs2: i32 = 0;
    var cb2: [1][*]i32 = undefined;
    const r2 = groupAnagrams(undefined, 0, &rs2, &cb2).?;
    try std.testing.expectEqual(@as(i32, 0), rs2);
    _ = r2;

    // Duplicates land in the same group and empty strings form one group.
    var dup = [_][*]u8{ @constCast(""), @constCast(""), @constCast("ab"), @constCast("ba") };
    var cb3: [1][*]i32 = undefined;
    var rs3: i32 = 0;
    const r3 = groupAnagrams(&dup, 4, &rs3, &cb3).?;
    try std.testing.expectEqual(@as(i32, 2), rs3);
    try std.testing.expectEqual(@as(i32, 2), cb3[0][0]);
    try std.testing.expectEqual(@as(i32, 2), cb3[0][1]);
    try std.testing.expectEqualStrings("", std.mem.span(@as([*:0]u8, @ptrCast(r3[0][0]))));
    try std.testing.expectEqualStrings("ab", std.mem.span(@as([*:0]u8, @ptrCast(r3[1][0]))));
    try std.testing.expectEqualStrings("ba", std.mem.span(@as([*:0]u8, @ptrCast(r3[1][1]))));
}
