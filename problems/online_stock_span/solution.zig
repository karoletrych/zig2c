// LeetCode 901. Online Stock Span
// C signature:
//   StockSpanner* stockSpannerCreate();
//   int stockSpannerNext(StockSpanner* obj, int price);
//   void stockSpannerFree(StockSpanner* obj);
//
// Monotonic stack of (price, span): while the top price is <= the new price it
// is absorbed, so the new span is 1 plus every absorbed span.
const std = @import("std");
const allocator = std.heap.c_allocator;

const CAP: i32 = 10001;

pub const StockSpanner = struct {
    prices: [10001]i32,
    spans: [10001]i32,
    top: i32,
};

pub fn stockSpannerCreate() ?*StockSpanner {
    const obj = allocator.create(StockSpanner) catch unreachable;
    obj.top = 0;
    return obj;
}

pub fn stockSpannerNext(obj: *StockSpanner, price: i32) i32 {
    var span: i32 = 1;
    while (obj.top > 0 and obj.prices[@intCast(obj.top - 1)] <= price) {
        span += obj.spans[@intCast(obj.top - 1)];
        obj.top -= 1;
    }
    obj.prices[@intCast(obj.top)] = price;
    obj.spans[@intCast(obj.top)] = span;
    obj.top += 1;
    return span;
}

pub fn stockSpannerFree(obj: *StockSpanner) void {
    allocator.destroy(obj);
}

test "stockSpanner example" {
    const obj = stockSpannerCreate().?;
    try std.testing.expectEqual(@as(i32, 1), stockSpannerNext(obj, 100));
    try std.testing.expectEqual(@as(i32, 1), stockSpannerNext(obj, 80));
    try std.testing.expectEqual(@as(i32, 1), stockSpannerNext(obj, 60));
    try std.testing.expectEqual(@as(i32, 2), stockSpannerNext(obj, 70));
    try std.testing.expectEqual(@as(i32, 1), stockSpannerNext(obj, 60));
    try std.testing.expectEqual(@as(i32, 4), stockSpannerNext(obj, 75));
    try std.testing.expectEqual(@as(i32, 6), stockSpannerNext(obj, 85));
    stockSpannerFree(obj);
}

test "stockSpanner increases and repeats" {
    const obj = stockSpannerCreate().?;
    try std.testing.expectEqual(@as(i32, 1), stockSpannerNext(obj, 10));
    try std.testing.expectEqual(@as(i32, 2), stockSpannerNext(obj, 20));
    try std.testing.expectEqual(@as(i32, 3), stockSpannerNext(obj, 30));
    try std.testing.expectEqual(@as(i32, 4), stockSpannerNext(obj, 40));
    stockSpannerFree(obj);

    const obj2 = stockSpannerCreate().?;
    try std.testing.expectEqual(@as(i32, 1), stockSpannerNext(obj2, 5));
    try std.testing.expectEqual(@as(i32, 2), stockSpannerNext(obj2, 5));
    try std.testing.expectEqual(@as(i32, 3), stockSpannerNext(obj2, 5));
    try std.testing.expectEqual(@as(i32, 1), stockSpannerNext(obj2, 4));
    stockSpannerFree(obj2);
}
