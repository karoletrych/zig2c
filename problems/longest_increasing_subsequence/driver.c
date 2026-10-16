#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[] = { 10, 9, 2, 5, 3, 7, 101, 18 };
        CHECK(lengthOfLIS(a, 8) == 4);
    }
    {
        int a[] = { 0, 1, 0, 3, 2, 3 };
        CHECK(lengthOfLIS(a, 6) == 4);
    }
    {
        int a[] = { 7, 7, 7, 7, 7, 7, 7 };
        CHECK(lengthOfLIS(a, 7) == 1);
    }
    {
        int a[] = { 1 };
        CHECK(lengthOfLIS(a, 1) == 1);
    }
    {
        int a[] = { 2, 1 };
        CHECK(lengthOfLIS(a, 2) == 1);
    }
    {
        int a[] = { 1, 2, 3, 4, 5 };
        CHECK(lengthOfLIS(a, 5) == 5);
    }
    {
        int a[] = { 5, 4, 3, 2, 1 };
        CHECK(lengthOfLIS(a, 5) == 1);
    }
    {
        int a[] = { -3, -2, -1, 0 };
        CHECK(lengthOfLIS(a, 4) == 4);
    }
    CHECK(lengthOfLIS(NULL, 0) == 0);
    printf("longest_increasing_subsequence: OK\n");
    return 0;
}
