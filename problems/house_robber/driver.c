#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a[4] = { 1, 2, 3, 1 };
    CHECK(rob(a, 4) == 4);

    int b[5] = { 2, 7, 9, 3, 1 };
    CHECK(rob(b, 5) == 12);

    int one[1] = { 5 };
    CHECK(rob(one, 1) == 5);

    int two[2] = { 2, 1 };
    CHECK(rob(two, 2) == 2);

    int same[4] = { 4, 4, 4, 4 };
    CHECK(rob(same, 4) == 8);

    int z[3] = { 0, 0, 0 };
    CHECK(rob(z, 3) == 0);
    printf("house_robber: OK\n");
    return 0;
}
