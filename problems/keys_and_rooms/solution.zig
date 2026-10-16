// LeetCode 841. Keys and Rooms
// C signature:  bool canVisitAllRooms(int** rooms, int roomsSize, int* roomsColSize);
//
// Iterative depth-first traversal from room 0. We can visit every room iff the
// traversal reaches all `roomsSize` rooms.
const std = @import("std");
const allocator = std.heap.c_allocator;

pub fn canVisitAllRooms(rooms: [*][*]i32, roomsSize: i32, roomsColSize: [*]i32) bool {
    const n: usize = @intCast(roomsSize);

    const visited = allocator.alloc(bool, n) catch unreachable;
    defer allocator.free(visited);
    var i: usize = 0;
    while (i < n) : (i += 1) visited[i] = false;

    const stack = allocator.alloc(i32, n) catch unreachable;
    defer allocator.free(stack);

    var top: i32 = 0;
    stack[0] = 0;
    visited[0] = true;
    var reached: i32 = 1;

    while (top >= 0) {
        const room: i32 = stack[@intCast(top)];
        top -= 1;

        const keys: i32 = roomsColSize[@intCast(room)];
        var j: i32 = 0;
        while (j < keys) : (j += 1) {
            const key: i32 = rooms[@intCast(room)][@intCast(j)];
            const k: usize = @intCast(key);
            if (!visited[k]) {
                visited[k] = true;
                reached += 1;
                top += 1;
                stack[@intCast(top)] = key;
            }
        }
    }
    return reached == roomsSize;
}

test "canVisitAllRooms" {
    var a0 = [_]i32{1};
    var a1 = [_]i32{2};
    var a2 = [_]i32{3};
    var a3 = [_]i32{};
    var rooms = [_][*]i32{ &a0, &a1, &a2, &a3 };
    var cols = [_]i32{ 1, 1, 1, 0 };
    try std.testing.expect(canVisitAllRooms(&rooms, 4, &cols));

    var b0 = [_]i32{ 1, 3 };
    var b1 = [_]i32{ 3, 0, 1 };
    var b2 = [_]i32{2};
    var b3 = [_]i32{0};
    var rooms2 = [_][*]i32{ &b0, &b1, &b2, &b3 };
    var cols2 = [_]i32{ 2, 3, 1, 1 };
    try std.testing.expect(!canVisitAllRooms(&rooms2, 4, &cols2));

    var c0 = [_]i32{};
    var rooms3 = [_][*]i32{&c0};
    var cols3 = [_]i32{0};
    try std.testing.expect(canVisitAllRooms(&rooms3, 1, &cols3));

    var d0 = [_]i32{1};
    var d1 = [_]i32{};
    var rooms4 = [_][*]i32{ &d0, &d1 };
    var cols4 = [_]i32{ 1, 0 };
    try std.testing.expect(canVisitAllRooms(&rooms4, 2, &cols4));
}
