#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[9] = { 17, 12, 10, 2, 7, 2, 11, 20, 8 };
        CHECK(totalCost(a, 9, 3, 4) == 11);
    }
    {
        int a[4] = { 1, 2, 4, 1 };
        CHECK(totalCost(a, 4, 3, 3) == 4);
    }
    {
        int a[5] = { 5, 4, 3, 2, 1 };
        CHECK(totalCost(a, 5, 2, 5) == 3);
    }
    {
        int a[8] = { 3, 1, 4, 1, 5, 9, 2, 6 };
        CHECK(totalCost(a, 8, 3, 3) == 4);
    }
    {
        int a[3] = { 1, 1, 1 };
        CHECK(totalCost(a, 3, 3, 1) == 3);
    }
    {
        int a[2] = { 10, 2 };
        CHECK(totalCost(a, 2, 1, 1) == 2);
    }
    printf("total_cost_hire_k: OK\n");
    return 0;
}
