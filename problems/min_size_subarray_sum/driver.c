#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[] = { 2, 3, 1, 2, 4, 3 };
        CHECK(minSubArrayLen(7, a, 6) == 2);
    }
    {
        int a[] = { 1, 4, 4 };
        CHECK(minSubArrayLen(4, a, 3) == 1);
    }
    {
        int a[] = { 1, 1, 1, 1, 1, 1, 1, 1 };
        CHECK(minSubArrayLen(11, a, 8) == 0);
    }
    {
        int a[] = { 5 };
        CHECK(minSubArrayLen(5, a, 1) == 1);
        CHECK(minSubArrayLen(6, a, 1) == 0);
    }
    {
        int a[] = { 1, 2, 3, 4, 5 };
        CHECK(minSubArrayLen(15, a, 5) == 5);
        CHECK(minSubArrayLen(9, a, 5) == 2);
    }
    {
        int a[] = { 10, 2, 3 };
        CHECK(minSubArrayLen(10, a, 3) == 1);
    }
    printf("min_size_subarray_sum: OK\n");
    return 0;
}
