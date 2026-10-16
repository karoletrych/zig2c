#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int r0[1] = { 1 };
        int r1[1] = { 2 };
        int r2[1] = { 3 };
        int r3[1] = { 0 };
        int *rooms[4] = { r0, r1, r2, r3 };
        int cols[4] = { 1, 1, 1, 0 };
        CHECK(canVisitAllRooms(rooms, 4, cols));
    }
    {
        int r0[2] = { 1, 3 };
        int r1[3] = { 3, 0, 1 };
        int r2[1] = { 2 };
        int r3[1] = { 0 };
        int *rooms[4] = { r0, r1, r2, r3 };
        int cols[4] = { 2, 3, 1, 1 };
        CHECK(!canVisitAllRooms(rooms, 4, cols));
    }
    {
        int r0[1] = { 0 };
        int *rooms[1] = { r0 };
        int cols[1] = { 0 };
        CHECK(canVisitAllRooms(rooms, 1, cols));
    }
    {
        int r0[1] = { 1 };
        int r1[1] = { 0 };
        int *rooms[2] = { r0, r1 };
        int cols[2] = { 1, 0 };
        CHECK(canVisitAllRooms(rooms, 2, cols));
    }
    printf("keys_and_rooms: OK\n");
    return 0;
}
