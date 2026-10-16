// LeetCode 6. Zigzag Conversion
// C signature:  char* convert(char* s, int numRows);
//
// Visit the string once per row. Within a full zigzag period of
// cycle = 2*numRows - 2 characters, a middle row contributes the character at
// the row offset and one on the rising diagonal (cycle - 2*row later).
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn convert(s: [*]u8, numRows: i32) [*]u8 {
    const a = std.mem.sliceTo(s, 0);
    const n = a.len;
    const buf = allocator.alloc(u8, n + 1) catch unreachable;

    if (numRows <= 1) {
        var i: usize = 0;
        while (i < n) : (i += 1) buf[i] = a[i];
        buf[n] = 0;
        return buf.ptr;
    }

    const rows: usize = @intCast(numRows);
    const cycle: usize = rows * 2 - 2;
    var k: usize = 0;
    var r: usize = 0;
    while (r < rows) : (r += 1) {
        var idx: usize = r;
        while (idx < n) {
            buf[k] = a[idx];
            k += 1;
            if (r != 0 and r != rows - 1) {
                const diag = idx + (cycle - 2 * r);
                if (diag < n) {
                    buf[k] = a[diag];
                    k += 1;
                }
            }
            idx += cycle;
        }
    }
    buf[n] = 0;
    return buf.ptr;
}

test "convert examples" {
    try std.testing.expectEqualStrings("PAHNAPLSIIGYIR", std.mem.sliceTo(convert(@constCast("PAYPALISHIRING"), 3), 0));
    try std.testing.expectEqualStrings("PINALSIGYAHRPI", std.mem.sliceTo(convert(@constCast("PAYPALISHIRING"), 4), 0));
}

test "convert edges" {
    try std.testing.expectEqualStrings("A", std.mem.sliceTo(convert(@constCast("A"), 1), 0));
    try std.testing.expectEqualStrings("AB", std.mem.sliceTo(convert(@constCast("AB"), 1), 0));
    try std.testing.expectEqualStrings("ABC", std.mem.sliceTo(convert(@constCast("ABC"), 5), 0));
    try std.testing.expectEqualStrings("ACB", std.mem.sliceTo(convert(@constCast("ABC"), 2), 0));
    try std.testing.expectEqualStrings("", std.mem.sliceTo(convert(@constCast(""), 3), 0));
}
