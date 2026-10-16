#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a1[3] = { 5, 10, -5 };
    int rs = 0;
    int *r = asteroidCollision(a1, 3, &rs);
    CHECK(rs == 2 && r[0] == 5 && r[1] == 10);

    int a2[2] = { 8, -8 };
    rs = 0;
    r = asteroidCollision(a2, 2, &rs);
    CHECK(rs == 0);

    int a3[3] = { 10, 2, -5 };
    rs = 0;
    r = asteroidCollision(a3, 3, &rs);
    CHECK(rs == 1 && r[0] == 10);

    int a4[4] = { -2, -1, 1, 2 };
    rs = 0;
    r = asteroidCollision(a4, 4, &rs);
    CHECK(rs == 4 && r[0] == -2 && r[1] == -1 && r[2] == 1 && r[3] == 2);

    int a5[4] = { 1, -1, -2, -2 };
    rs = 0;
    r = asteroidCollision(a5, 4, &rs);
    CHECK(rs == 2 && r[0] == -2 && r[1] == -2);

    printf("asteroid_collision: OK\n");
    return 0;
}
