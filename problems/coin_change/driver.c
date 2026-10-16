#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int c[] = { 1, 2, 5 };
        CHECK(coinChange(c, 3, 11) == 3);
    }
    {
        int c[] = { 2 };
        CHECK(coinChange(c, 1, 3) == -1);
    }
    {
        int c[] = { 1 };
        CHECK(coinChange(c, 1, 0) == 0);
    }
    {
        int c[] = { 2, 5, 10, 1 };
        CHECK(coinChange(c, 4, 27) == 4);
    }
    {
        int c[] = { 186, 419, 83, 408 };
        CHECK(coinChange(c, 4, 6249) == 20);
    }
    {
        int c[] = { 5 };
        CHECK(coinChange(c, 1, 3) == -1);
        CHECK(coinChange(c, 1, 10) == 2);
    }
    {
        int c[] = { 1, 2, 5 };
        CHECK(coinChange(c, 3, 0) == 0);
        CHECK(coinChange(c, 3, 5) == 1);
        CHECK(coinChange(c, 3, 6) == 2);
    }
    printf("coin_change: OK\n");
    return 0;
}
