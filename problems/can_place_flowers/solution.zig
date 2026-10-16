// LeetCode 605. Can Place Flowers
// C signature:  bool canPlaceFlowers(int* flowerbed, int flowerbedSize, int n);
const std = @import("std");

pub fn canPlaceFlowers(flowerbed: [*]i32, flowerbedSize: i32, n: i32) bool {
    const size: usize = @intCast(flowerbedSize);
    var count: i32 = 0;
    var i: usize = 0;
    while (i < size) : (i += 1) {
        if (flowerbed[i] == 0) {
            const left = (i == 0) or (flowerbed[i - 1] == 0);
            const right = (i + 1 == size) or (flowerbed[i + 1] == 0);
            if (left and right) {
                flowerbed[i] = 1;
                count += 1;
            }
        }
    }
    return count >= n;
}

test "canPlaceFlowers examples" {
    var a = [_]i32{ 1, 0, 0, 0, 1 };
    try std.testing.expect(canPlaceFlowers(&a, 5, 1));

    var b = [_]i32{ 1, 0, 0, 0, 1 };
    try std.testing.expect(!canPlaceFlowers(&b, 5, 2));
}

test "canPlaceFlowers edges" {
    var a = [_]i32{0};
    try std.testing.expect(canPlaceFlowers(&a, 1, 1));

    var b = [_]i32{1};
    try std.testing.expect(!canPlaceFlowers(&b, 1, 1));

    var c = [_]i32{ 0, 0 };
    try std.testing.expect(canPlaceFlowers(&c, 2, 1));

    var d = [_]i32{ 1, 0, 0, 0, 0, 1 };
    try std.testing.expect(canPlaceFlowers(&d, 6, 1));

    var e = [_]i32{ 0, 0, 0, 0, 0 };
    try std.testing.expect(canPlaceFlowers(&e, 5, 3));
}
