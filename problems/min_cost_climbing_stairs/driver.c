#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a[3] = { 10, 15, 20 };
    CHECK(minCostClimbingStairs(a, 3) == 15);

    int b[10] = { 1, 100, 1, 1, 1, 100, 1, 1, 100, 1 };
    CHECK(minCostClimbingStairs(b, 10) == 6);

    int z[2] = { 0, 0 };
    CHECK(minCostClimbingStairs(z, 2) == 0);

    int s[2] = { 5, 5 };
    CHECK(minCostClimbingStairs(s, 2) == 5);

    int c[3] = { 1, 2, 3 };
    CHECK(minCostClimbingStairs(c, 3) == 2);
    printf("min_cost_climbing_stairs: OK\n");
    return 0;
}
