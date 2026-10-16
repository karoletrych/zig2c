#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[6] = { 100, 4, 200, 1, 3, 2 };
        CHECK(longestConsecutive(a, 6) == 4);
    }
    {
        int b[10] = { 0, 3, 7, 2, 5, 8, 4, 6, 0, 1 };
        CHECK(longestConsecutive(b, 10) == 9);
    }
    {
        int c[1] = { 0 };
        CHECK(longestConsecutive(c, 1) == 1);
    }
    {
        int z[3] = { 0, 0, 0 };
        CHECK(longestConsecutive(z, 3) == 1);
    }
    CHECK(longestConsecutive(NULL, 0) == 0);
    {
        int e[2] = { -2147483647 - 1, 2147483647 };
        CHECK(longestConsecutive(e, 2) == 1);
    }
    {
        int n[2] = { 2147483646, 2147483647 };
        CHECK(longestConsecutive(n, 2) == 2);
    }
    printf("longest_consecutive: OK\n");
    return 0;
}
