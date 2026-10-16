// LeetCode 20. Valid Parentheses
// C signature:  bool isValid(char* s);
const std = @import("std");

pub fn isValid(s: [*]u8) bool {
    const str = std.mem.sliceTo(s, 0);
    var stack: [10000]u8 = undefined;
    var top: usize = 0;
    for (str) |c| {
        if (c == '(' or c == '[' or c == '{') {
            stack[top] = c;
            top += 1;
        } else {
            if (top == 0) return false;
            top -= 1;
            const o = stack[top];
            if (c == ')' and o != '(') return false;
            if (c == ']' and o != '[') return false;
            if (c == '}' and o != '{') return false;
        }
    }
    return top == 0;
}

test "isValid" {
    try std.testing.expect(isValid(@constCast("()[]{}")));
    try std.testing.expect(isValid(@constCast("{[]}")));
    try std.testing.expect(!isValid(@constCast("(]")));
    try std.testing.expect(!isValid(@constCast("([)]")));
    try std.testing.expect(!isValid(@constCast("(")));
    try std.testing.expect(isValid(@constCast("")));
}
