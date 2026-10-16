#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[4] = { 1, 3, 3, 2 };
        int b[4] = { 2, 1, 3, 4 };
        CHECK(maxScore(a, 4, b, 4, 3) == 12);
    }
    {
        int a[5] = { 4, 2, 3, 1, 1 };
        int b[5] = { 7, 5, 10, 9, 6 };
        CHECK(maxScore(a, 5, b, 5, 1) == 30);
    }
    {
        int a[4] = { 2, 1, 14, 12 };
        int b[4] = { 11, 7, 13, 6 };
        CHECK(maxScore(a, 4, b, 4, 3) == 168);
    }
    {
        int a[3] = { 5, 6, 7 };
        int b[3] = { 3, 9, 4 };
        CHECK(maxScore(a, 3, b, 3, 3) == 54);
    }
    {
        int a[1] = { 10 };
        int b[1] = { 2 };
        CHECK(maxScore(a, 1, b, 1, 1) == 20);
    }
    printf("max_subsequence_score: OK\n");
    return 0;
}
