#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[8] = { 3, 3, 5, 0, 0, 3, 1, 4 };
        CHECK(maxProfit(a, 8) == 6);
    }
    {
        int a[5] = { 1, 2, 3, 4, 5 };
        CHECK(maxProfit(a, 5) == 4);
    }
    {
        int a[5] = { 7, 6, 4, 3, 1 };
        CHECK(maxProfit(a, 5) == 0);
    }
    {
        int a[1] = { 5 };
        CHECK(maxProfit(a, 1) == 0);
    }
    {
        int a[2] = { 1, 2 };
        CHECK(maxProfit(a, 2) == 1);
    }
    {
        int a[3] = { 2, 4, 1 };
        CHECK(maxProfit(a, 3) == 2);
    }
    {
        int a[10] = { 1, 2, 4, 2, 5, 7, 2, 4, 9, 0 };
        CHECK(maxProfit(a, 10) == 13);
    }
    {
        int a[4] = { 3, 3, 3, 3 };
        CHECK(maxProfit(a, 4) == 0);
    }
    {
        int a[5] = { 5, 2, 0, 3, 8 };
        CHECK(maxProfit(a, 5) == 8);
    }
    printf("stock_iii: OK\n");
    return 0;
}
