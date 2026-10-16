// LeetCode 443. String Compression
// C signature:  int compress(char* chars, int charsSize, int* returnSize);
const std = @import("std");

pub fn compress(chars: [*]u8, charsSize: i32, returnSize: *i32) i32 {
    const n: usize = @intCast(charsSize);
    var write: usize = 0;
    var i: usize = 0;
    while (i < n) {
        const c = chars[i];
        var j = i;
        while (j < n and chars[j] == c) j += 1;
        const run = j - i;

        chars[write] = c;
        write += 1;

        if (run > 1) {
            var digits: usize = 0;
            var tmp = run;
            while (tmp > 0) : (tmp /= 10) digits += 1;

            var d = write + digits;
            var cnt = run;
            while (cnt > 0) {
                d -= 1;
                chars[d] = '0' + @as(u8, @intCast(cnt % 10));
                cnt /= 10;
            }
            write += digits;
        }
        i = j;
    }
    const res: i32 = @intCast(write);
    returnSize.* = res;
    return res;
}

test "compress examples" {
    var a = [_]u8{ 'a', 'a', 'b', 'b', 'c', 'c', 'c' };
    var rs: i32 = 0;
    const len = compress(&a, 7, &rs);
    try std.testing.expectEqual(@as(i32, 6), len);
    try std.testing.expectEqual(@as(i32, 6), rs);
    try std.testing.expectEqualStrings("a2b2c3", a[0..6]);

    var b = [_]u8{'a'};
    rs = 0;
    const len2 = compress(&b, 1, &rs);
    try std.testing.expectEqual(@as(i32, 1), len2);
    try std.testing.expectEqual(@as(i32, 1), rs);
    try std.testing.expectEqualStrings("a", b[0..1]);

    var c = [_]u8{ 'a', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b' };
    rs = 0;
    const len3 = compress(&c, 13, &rs);
    try std.testing.expectEqual(@as(i32, 4), len3);
    try std.testing.expectEqual(@as(i32, 4), rs);
    try std.testing.expectEqualStrings("ab12", c[0..4]);
}

test "compress runs" {
    var a = [_]u8{ 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a' };
    var rs: i32 = 0;
    const len = compress(&a, 12, &rs);
    try std.testing.expectEqual(@as(i32, 3), len);
    try std.testing.expectEqualStrings("a12", a[0..3]);

    var b = [_]u8{ 'x', 'y', 'z' };
    rs = 0;
    const len2 = compress(&b, 3, &rs);
    try std.testing.expectEqual(@as(i32, 3), len2);
    try std.testing.expectEqualStrings("xyz", b[0..3]);
}
