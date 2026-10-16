// LeetCode 224. Basic Calculator
// C signature:  int calculate(char* s);
//
// Classic sign-stack evaluation: keep the running result, the pending signed
// number and the current sign. A '(' pushes the outer result and sign; a ')'
// pops them and folds the inner result back in.
const std = @import("std");
const allocator = std.heap.c_allocator;

// '(' and ')' written numerically, with the readable form in the comment.
const LPAREN: u8 = 40;
const RPAREN: u8 = 41;

pub fn calculate(s: [*]u8) i32 {
    const str = std.mem.sliceTo(s, 0);
    const stk = allocator.alloc(i32, str.len + 1) catch unreachable;
    defer allocator.free(stk);

    var top: usize = 0;
    var res: i32 = 0;
    var num: i32 = 0;
    var sign: i32 = 1;

    for (str) |ch| {
        if (ch >= '0' and ch <= '9') {
            num = num * 10 + @as(i32, @intCast(ch - '0'));
        } else if (ch == '+') {
            res += sign * num;
            num = 0;
            sign = 1;
        } else if (ch == '-') {
            res += sign * num;
            num = 0;
            sign = -1;
        } else if (ch == LPAREN) {
            stk[top] = res;
            top += 1;
            stk[top] = sign;
            top += 1;
            res = 0;
            sign = 1;
        } else if (ch == RPAREN) {
            res += sign * num;
            num = 0;
            top -= 1;
            const prevSign = stk[top];
            top -= 1;
            res = res * prevSign + stk[top];
        }
        // spaces and any other character are ignored
    }
    return res + sign * num;
}

test "calculate example" {
    try std.testing.expectEqual(@as(i32, 2), calculate(@constCast("1 + 1")));
    try std.testing.expectEqual(@as(i32, 3), calculate(@constCast(" 2-1 + 2 ")));
    try std.testing.expectEqual(@as(i32, 23), calculate(@constCast("(1+(4+5+2)-3)+(6+8)")));
}

test "calculate edges" {
    try std.testing.expectEqual(@as(i32, 0), calculate(@constCast("")));
    try std.testing.expectEqual(@as(i32, 0), calculate(@constCast("0")));
    try std.testing.expectEqual(@as(i32, 30), calculate(@constCast("  30")));
    try std.testing.expectEqual(@as(i32, 1), calculate(@constCast("(1)")));
    try std.testing.expectEqual(@as(i32, -10), calculate(@constCast("1-11")));
    try std.testing.expectEqual(@as(i32, 3), calculate(@constCast("2-(5-6)")));
    try std.testing.expectEqual(@as(i32, -1), calculate(@constCast("-2+ 1")));
    try std.testing.expectEqual(@as(i32, 3), calculate(@constCast("1-(     -2)")));
    try std.testing.expectEqual(@as(i32, 2147483647), calculate(@constCast("2147483647")));
}
