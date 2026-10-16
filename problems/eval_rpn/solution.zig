// LeetCode 150. Evaluate Reverse Polish Notation
// C signature:  int evalRPN(char** tokens, int tokensSize);
//
// A single i32 stack. Numbers are parsed by hand (they may be negative and
// multi-digit); operators pop two operands and push the result. Division
// truncates toward zero, which is exactly C's `/` and Zig's @divTrunc.
const std = @import("std");
const allocator = std.heap.c_allocator;

fn parseInt(s: [*]u8) i32 {
    const str = std.mem.sliceTo(s, 0);
    var neg = false;
    var i: usize = 0;
    if (str.len > 0 and str[0] == '-') {
        neg = true;
        i = 1;
    }
    var v: i32 = 0;
    while (i < str.len) : (i += 1) {
        v = v * 10 + @as(i32, @intCast(str[i] - '0'));
    }
    if (neg) v = -v;
    return v;
}

pub fn evalRPN(tokens: [*][*]u8, tokensSize: i32) i32 {
    const n: usize = @intCast(tokensSize);
    const stk = allocator.alloc(i32, n) catch unreachable;
    defer allocator.free(stk);

    var top: usize = 0;
    var i: usize = 0;
    while (i < n) : (i += 1) {
        const t = std.mem.sliceTo(tokens[i], 0);
        if (t.len == 1 and (t[0] == '+' or t[0] == '-' or t[0] == '*' or t[0] == '/')) {
            const b = stk[top - 1];
            const a = stk[top - 2];
            top -= 2;
            var r: i32 = 0;
            if (t[0] == '+') {
                r = a + b;
            } else if (t[0] == '-') {
                r = a - b;
            } else if (t[0] == '*') {
                r = a * b;
            } else {
                r = @divTrunc(a, b);
            }
            stk[top] = r;
            top += 1;
        } else {
            stk[top] = parseInt(tokens[i]);
            top += 1;
        }
    }
    return stk[0];
}

test "evalRPN examples" {
    var a = [_][*]u8{ @constCast("2"), @constCast("1"), @constCast("+"), @constCast("3"), @constCast("*") };
    try std.testing.expectEqual(@as(i32, 9), evalRPN(&a, 5));

    var b = [_][*]u8{ @constCast("4"), @constCast("13"), @constCast("5"), @constCast("/"), @constCast("+") };
    try std.testing.expectEqual(@as(i32, 6), evalRPN(&b, 5));

    var c = [_][*]u8{
        @constCast("10"), @constCast("6"),  @constCast("9"),  @constCast("3"), @constCast("+"),
        @constCast("-11"), @constCast("*"), @constCast("/"),  @constCast("*"), @constCast("17"),
        @constCast("+"),  @constCast("5"),  @constCast("+"),
    };
    try std.testing.expectEqual(@as(i32, 22), evalRPN(&c, 13));
}

test "evalRPN edges" {
    var a = [_][*]u8{@constCast("42")};
    try std.testing.expectEqual(@as(i32, 42), evalRPN(&a, 1));

    // Truncation toward zero for negative quotients.
    var b = [_][*]u8{ @constCast("-7"), @constCast("2"), @constCast("/") };
    try std.testing.expectEqual(@as(i32, -3), evalRPN(&b, 3));

    var c = [_][*]u8{ @constCast("0"), @constCast("3"), @constCast("/") };
    try std.testing.expectEqual(@as(i32, 0), evalRPN(&c, 3));

    var d = [_][*]u8{ @constCast("-128"), @constCast("-2"), @constCast("*") };
    try std.testing.expectEqual(@as(i32, 256), evalRPN(&d, 3));

    var e = [_][*]u8{ @constCast("3"), @constCast("4"), @constCast("+"), @constCast("2"), @constCast("*"), @constCast("7"), @constCast("-") };
    try std.testing.expectEqual(@as(i32, 7), evalRPN(&e, 7));
}
