#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[3] = { 2, 4, 1 };
        CHECK(maxProfit(2, a, 3) == 2);
    }
    {
        int a[6] = { 3, 2, 6, 5, 0, 3 };
        CHECK(maxProfit(2, a, 6) == 7);
    }
    {
        int a[5] = { 1, 2, 3, 4, 5 };
        CHECK(maxProfit(0, a, 5) == 0);
        CHECK(maxProfit(1, a, 5) == 4);
        CHECK(maxProfit(100, a, 5) == 4);
    }
    {
        int a[6] = { 7, 1, 5, 3, 6, 4 };
        CHECK(maxProfit(100, a, 6) == 7);
    }
    {
        int a[4] = { 9, 8, 7, 6 };
        CHECK(maxProfit(2, a, 4) == 0);
    }
    {
        int a[1] = { 5 };
        CHECK(maxProfit(3, a, 1) == 0);
    }
    {
        int a[3] = { 4, 4, 4 };
        CHECK(maxProfit(2, a, 3) == 0);
    }
    {
        int a[8] = { 3, 3, 5, 0, 0, 3, 1, 4 };
        CHECK(maxProfit(2, a, 8) == 6);
    }
    printf("stock_iv: OK\n");
    return 0;
}
