#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[6] = { 7, 1, 5, 3, 6, 4 };
        CHECK(maxProfit(a, 6) == 7);
    }
    {
        int b[5] = { 1, 2, 3, 4, 5 };
        CHECK(maxProfit(b, 5) == 4);
    }
    {
        int c[5] = { 7, 6, 4, 3, 1 };
        CHECK(maxProfit(c, 5) == 0);
    }
    {
        int empty[1] = { 0 };
        CHECK(maxProfit(empty, 0) == 0);
    }
    {
        int one[1] = { 5 };
        CHECK(maxProfit(one, 1) == 0);
    }
    {
        int same[3] = { 4, 4, 4 };
        CHECK(maxProfit(same, 3) == 0);
    }
    {
        int up[2] = { 1, 2 };
        CHECK(maxProfit(up, 2) == 1);
    }
    printf("buy_sell_stock_ii: OK\n");
    return 0;
}
