// LeetCode 68. Text Justification
// C signature:  char** fullJustify(char** words, int wordsSize, int maxWidth,
//                                 int* returnSize);
//
// Greedily pack words into a line while they fit with single spaces. The last
// line and any line holding a single word are left-justified; every other line
// spreads the leftover spaces as evenly as possible, giving the extra spaces to
// the leftmost gaps. Each returned string is exactly maxWidth bytes long.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn wlen(w: [*]u8) usize {
    return std.mem.sliceTo(w, 0).len;
}

fn putWord(dst: [*]u8, pos: *usize, w: [*]u8) void {
    const s = std.mem.sliceTo(w, 0);
    var j: usize = 0;
    while (j < s.len) : (j += 1) {
        dst[pos.*] = s[j];
        pos.* += 1;
    }
}

pub fn fullJustify(words: [*][*]u8, wordsSize: i32, maxWidth: i32, returnSize: *i32) ?[*][*]u8 {
    const mw: usize = @intCast(maxWidth);
    const out = allocator.alloc([*]u8, @intCast(wordsSize)) catch unreachable;

    var lineCount: i32 = 0;
    var idx: i32 = 0;
    while (idx < wordsSize) {
        // Pack the line [idx, end): words separated by a single space.
        var end = idx;
        var letters: usize = 0;
        var curWidth: usize = 0;
        while (end < wordsSize) {
            const l = wlen(words[@intCast(end)]);
            var add = l;
            if (end > idx) add += 1;
            if (curWidth + add > mw) break;
            curWidth += add;
            letters += l;
            end += 1;
        }
        if (end == idx) end = idx + 1; // a word always fits on its own line

        const cnt: usize = @intCast(end - idx);
        const line = allocator.alloc(u8, mw + 1) catch unreachable;
        var pos: usize = 0;

        if (end == wordsSize or cnt == 1) {
            // Left-justified: single spaces, padding on the right.
            var i = idx;
            while (i < end) : (i += 1) {
                if (i > idx) {
                    line[pos] = ' ';
                    pos += 1;
                }
                putWord(line.ptr, &pos, words[@intCast(i)]);
            }
            while (pos < mw) : (pos += 1) line[pos] = ' ';
        } else {
            // Fully justified: distribute maxWidth - letters spaces over cnt-1 gaps.
            const totalSpaces = mw - letters;
            const base = totalSpaces / (cnt - 1);
            const extra = totalSpaces % (cnt - 1);
            var g: usize = 0;
            var i = idx;
            while (i < end) : (i += 1) {
                if (i > idx) {
                    var s = base;
                    if (g < extra) s += 1;
                    g += 1;
                    var q: usize = 0;
                    while (q < s) : (q += 1) {
                        line[pos] = ' ';
                        pos += 1;
                    }
                }
                putWord(line.ptr, &pos, words[@intCast(i)]);
            }
        }

        line[mw] = 0;
        out[@intCast(lineCount)] = line.ptr;
        lineCount += 1;
        idx = end;
    }

    returnSize.* = lineCount;
    return out.ptr;
}

test "fullJustify example 1" {
    var w = [_][*]u8{
        @constCast("This"),     @constCast("is"),   @constCast("an"),
        @constCast("example"),  @constCast("of"),   @constCast("text"),
        @constCast("justification."),
    };
    var rs: i32 = 0;
    const r = fullJustify(&w, 7, 16, &rs).?;
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqualStrings("This    is    an", std.mem.sliceTo(r[0], 0));
    try std.testing.expectEqualStrings("example  of text", std.mem.sliceTo(r[1], 0));
    try std.testing.expectEqualStrings("justification.  ", std.mem.sliceTo(r[2], 0));
}

test "fullJustify example 2" {
    var w = [_][*]u8{
        @constCast("What"),           @constCast("must"), @constCast("be"),
        @constCast("acknowledgment"), @constCast("shall"), @constCast("be"),
    };
    var rs: i32 = 0;
    const r = fullJustify(&w, 6, 16, &rs).?;
    try std.testing.expectEqual(@as(i32, 3), rs);
    try std.testing.expectEqualStrings("What   must   be", std.mem.sliceTo(r[0], 0));
    try std.testing.expectEqualStrings("acknowledgment  ", std.mem.sliceTo(r[1], 0));
    try std.testing.expectEqualStrings("shall be        ", std.mem.sliceTo(r[2], 0));
}

test "fullJustify example 3" {
    var w = [_][*]u8{
        @constCast("Science"), @constCast("is"),       @constCast("what"),
        @constCast("we"),      @constCast("understand"), @constCast("well"),
        @constCast("enough"),  @constCast("to"),       @constCast("explain"),
        @constCast("to"),      @constCast("a"),        @constCast("computer."),
        @constCast("Art"),     @constCast("is"),       @constCast("everything"),
        @constCast("else"),    @constCast("we"),       @constCast("do"),
    };
    var rs: i32 = 0;
    const r = fullJustify(&w, 18, 20, &rs).?;
    try std.testing.expectEqual(@as(i32, 6), rs);
    try std.testing.expectEqualStrings("Science  is  what we", std.mem.sliceTo(r[0], 0));
    try std.testing.expectEqualStrings("understand      well", std.mem.sliceTo(r[1], 0));
    try std.testing.expectEqualStrings("enough to explain to", std.mem.sliceTo(r[2], 0));
    try std.testing.expectEqualStrings("a  computer.  Art is", std.mem.sliceTo(r[3], 0));
    try std.testing.expectEqualStrings("everything  else  we", std.mem.sliceTo(r[4], 0));
    try std.testing.expectEqualStrings("do                  ", std.mem.sliceTo(r[5], 0));
}

test "fullJustify edges" {
    // single word that must be padded, not the last line
    var w = [_][*]u8{ @constCast("abc"), @constCast("de") };
    var rs: i32 = 0;
    const r = fullJustify(&w, 2, 3, &rs).?;
    try std.testing.expectEqual(@as(i32, 2), rs);
    try std.testing.expectEqualStrings("abc", std.mem.sliceTo(r[0], 0));
    try std.testing.expectEqualStrings("de ", std.mem.sliceTo(r[1], 0));

    // exactly one line
    var w2 = [_][*]u8{ @constCast("a") };
    var rs2: i32 = 0;
    const r2 = fullJustify(&w2, 1, 1, &rs2).?;
    try std.testing.expectEqual(@as(i32, 1), rs2);
    try std.testing.expectEqualStrings("a", std.mem.sliceTo(r2[0], 0));

    // two/three words with uneven leftover space: extra goes to the left gap
    var w3 = [_][*]u8{ @constCast("a"), @constCast("b"), @constCast("c"), @constCast("d") };
    var rs3: i32 = 0;
    const r3 = fullJustify(&w3, 4, 6, &rs3).?;
    try std.testing.expectEqual(@as(i32, 2), rs3);
    try std.testing.expectEqualStrings("a  b c", std.mem.sliceTo(r3[0], 0));
    try std.testing.expectEqualStrings("d     ", std.mem.sliceTo(r3[1], 0));
}
