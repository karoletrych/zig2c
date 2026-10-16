// LeetCode 155. Min Stack
// C signatures:
//   MinStack* minStackCreate();
//   void minStackPush(MinStack* obj, int val);
//   void minStackPop(MinStack* obj);
//   int minStackTop(MinStack* obj);
//   int minStackGetMin(MinStack* obj);
//
// The judge makes at most 3 * 10^4 calls, so fixed arrays are enough. A parallel
// `mins` array stores the minimum of the stack up to and including each depth,
// making getMin O(1).
const std = @import("std");
const allocator = std.heap.c_allocator;

pub const MinStack = struct {
    vals: [30001]i32,
    mins: [30001]i32,
    top: usize,
};

pub fn minStackCreate() ?*MinStack {
    const obj = allocator.create(MinStack) catch unreachable;
    obj.top = 0;
    return obj;
}

pub fn minStackPush(obj: *MinStack, val: i32) void {
    var m = val;
    if (obj.top > 0 and obj.mins[obj.top - 1] < val) m = obj.mins[obj.top - 1];
    obj.vals[obj.top] = val;
    obj.mins[obj.top] = m;
    obj.top += 1;
}

pub fn minStackPop(obj: *MinStack) void {
    if (obj.top > 0) obj.top -= 1;
}

pub fn minStackTop(obj: *MinStack) i32 {
    return obj.vals[obj.top - 1];
}

pub fn minStackGetMin(obj: *MinStack) i32 {
    return obj.mins[obj.top - 1];
}

test "minStack example" {
    const obj = minStackCreate().?;
    minStackPush(obj, -2);
    minStackPush(obj, 0);
    minStackPush(obj, -3);
    try std.testing.expectEqual(@as(i32, -3), minStackGetMin(obj));
    minStackPop(obj);
    try std.testing.expectEqual(@as(i32, 0), minStackTop(obj));
    try std.testing.expectEqual(@as(i32, -2), minStackGetMin(obj));
}

test "minStack repeats and extremes" {
    const obj = minStackCreate().?;
    minStackPush(obj, 2147483647);
    minStackPush(obj, -2147483648);
    minStackPush(obj, 0);
    try std.testing.expectEqual(@as(i32, -2147483648), minStackGetMin(obj));
    try std.testing.expectEqual(@as(i32, 0), minStackTop(obj));
    minStackPop(obj);
    minStackPop(obj);
    try std.testing.expectEqual(@as(i32, 2147483647), minStackGetMin(obj));
    try std.testing.expectEqual(@as(i32, 2147483647), minStackTop(obj));

    minStackPush(obj, 5);
    minStackPush(obj, 5);
    try std.testing.expectEqual(@as(i32, 5), minStackGetMin(obj));
    minStackPop(obj);
    try std.testing.expectEqual(@as(i32, 5), minStackGetMin(obj));
}
