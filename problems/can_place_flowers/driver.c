#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a[5] = { 1, 0, 0, 0, 1 };
    CHECK(canPlaceFlowers(a, 5, 1) == true);

    int b[5] = { 1, 0, 0, 0, 1 };
    CHECK(canPlaceFlowers(b, 5, 2) == false);

    int c[1] = { 0 };
    CHECK(canPlaceFlowers(c, 1, 1) == true);

    int d[1] = { 1 };
    CHECK(canPlaceFlowers(d, 1, 1) == false);

    int e[2] = { 0, 0 };
    CHECK(canPlaceFlowers(e, 2, 1) == true);

    int f[6] = { 1, 0, 0, 0, 0, 1 };
    CHECK(canPlaceFlowers(f, 6, 1) == true);

    int g[5] = { 0, 0, 0, 0, 0 };
    CHECK(canPlaceFlowers(g, 5, 3) == true);

    printf("can_place_flowers: OK\n");
    return 0;
}
