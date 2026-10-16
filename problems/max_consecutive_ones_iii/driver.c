#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a[11] = { 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0 };
    CHECK(longestOnes(a, 11, 2) == 6);

    int b[7] = { 0, 0, 1, 1, 1, 0, 0 };
    CHECK(longestOnes(b, 7, 0) == 3);

    int c[4] = { 1, 1, 1, 1 };
    CHECK(longestOnes(c, 4, 0) == 4);

    int d[3] = { 0, 0, 0 };
    CHECK(longestOnes(d, 3, 5) == 3);

    printf("max_consecutive_ones_iii: OK\n");
    return 0;
}
