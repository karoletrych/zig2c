#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a[4] = { 1, 1, 0, 1 };
    CHECK(longestSubarray(a, 4) == 3);

    int b[9] = { 0, 1, 1, 1, 0, 1, 1, 0, 1 };
    CHECK(longestSubarray(b, 9) == 5);

    int c[3] = { 1, 1, 1 };
    CHECK(longestSubarray(c, 3) == 2);

    int d[3] = { 0, 0, 0 };
    CHECK(longestSubarray(d, 3) == 0);

    int e[1] = { 1 };
    CHECK(longestSubarray(e, 1) == 0);

    printf("longest_subarray_of_ones: OK\n");
    return 0;
}
