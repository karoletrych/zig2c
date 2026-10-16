#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[4] = { 1, -2, 3, -2 };
        CHECK(maxSubarraySumCircular(a, 4) == 3);
    }
    {
        int a[3] = { 5, -3, 5 };
        CHECK(maxSubarraySumCircular(a, 3) == 10);
    }
    {
        int a[3] = { -3, -2, -3 };
        CHECK(maxSubarraySumCircular(a, 3) == -2);
    }
    {
        int a[1] = { 1 };
        CHECK(maxSubarraySumCircular(a, 1) == 1);
    }
    {
        int a[1] = { -7 };
        CHECK(maxSubarraySumCircular(a, 1) == -7);
    }
    {
        int a[5] = { 3, 1, 4, 1, 5 };
        CHECK(maxSubarraySumCircular(a, 5) == 14);
    }
    {
        int a[4] = { -2, -2, -2, -2 };
        CHECK(maxSubarraySumCircular(a, 4) == -2);
    }
    {
        int a[4] = { 3, -1, 2, -1 };
        CHECK(maxSubarraySumCircular(a, 4) == 4);
    }
    {
        int a[3] = { -1, 40, -1 };
        CHECK(maxSubarraySumCircular(a, 3) == 40);
    }
    {
        int a[4] = { 0, 0, 5, 0 };
        CHECK(maxSubarraySumCircular(a, 4) == 5);
    }
    printf("max_circular_subarray: OK\n");
    return 0;
}
