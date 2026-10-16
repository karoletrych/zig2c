#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[4] = { 3, 6, 7, 11 };
        CHECK(minEatingSpeed(a, 4, 8) == 4);
    }
    {
        int a[5] = { 30, 11, 23, 4, 20 };
        CHECK(minEatingSpeed(a, 5, 5) == 30);
    }
    {
        int a[5] = { 30, 11, 23, 4, 20 };
        CHECK(minEatingSpeed(a, 5, 6) == 23);
    }
    {
        int a[1] = { 1 };
        CHECK(minEatingSpeed(a, 1, 1) == 1);
    }
    {
        int a[1] = { 1000000000 };
        CHECK(minEatingSpeed(a, 1, 1) == 1000000000);
    }
    {
        int a[3] = { 10, 10, 10 };
        CHECK(minEatingSpeed(a, 3, 1000) == 1);
    }
    {
        int a[4] = { 3, 6, 7, 11 };
        CHECK(minEatingSpeed(a, 4, 4) == 11);
    }
    printf("koko_eating_bananas: OK\n");
    return 0;
}
