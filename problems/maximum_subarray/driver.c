#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[9] = { -2, 1, -3, 4, -1, 2, 1, -5, 4 };
        CHECK(maxSubArray(a, 9) == 6);
    }
    {
        int a[1] = { 1 };
        CHECK(maxSubArray(a, 1) == 1);
    }
    {
        int a[5] = { 5, 4, -1, 7, 8 };
        CHECK(maxSubArray(a, 5) == 23);
    }
    {
        int a[3] = { -3, -1, -2 };
        CHECK(maxSubArray(a, 3) == -1);
    }
    {
        int a[6] = { -8, -3, -6, -2, -5, -4 };
        CHECK(maxSubArray(a, 6) == -2);
    }
    {
        int a[4] = { 7, 7, 7, 7 };
        CHECK(maxSubArray(a, 4) == 28);
    }
    {
        int a[1] = { -5 };
        CHECK(maxSubArray(a, 1) == -5);
    }
    {
        int a[3] = { 0, 0, 0 };
        CHECK(maxSubArray(a, 3) == 0);
    }
    printf("maximum_subarray: OK\n");
    return 0;
}
