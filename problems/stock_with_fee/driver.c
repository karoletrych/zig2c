#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a[6] = { 1, 3, 2, 8, 4, 9 };
    CHECK(maxProfit(a, 6, 2) == 8);

    int b[6] = { 1, 3, 7, 5, 10, 3 };
    CHECK(maxProfit(b, 6, 3) == 6);

    int one[1] = { 5 };
    CHECK(maxProfit(one, 1, 2) == 0);

    int same[4] = { 4, 4, 4, 4 };
    CHECK(maxProfit(same, 4, 1) == 0);

    int down[4] = { 9, 8, 7, 6 };
    CHECK(maxProfit(down, 4, 2) == 0);

    int none[2] = { 1, 4 };
    CHECK(maxProfit(none, 2, 0) == 3);
    printf("stock_with_fee: OK\n");
    return 0;
}
