#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[5] = { 3, 0, 6, 1, 5 };
        CHECK(hIndex(a, 5) == 3);
    }
    {
        int b[3] = { 1, 3, 1 };
        CHECK(hIndex(b, 3) == 1);
    }
    {
        int empty[1] = { 0 };
        CHECK(hIndex(empty, 0) == 0);
    }
    {
        int one[1] = { 0 };
        CHECK(hIndex(one, 1) == 0);
    }
    {
        int all[3] = { 100, 100, 100 };
        CHECK(hIndex(all, 3) == 3);
    }
    {
        int zeros[3] = { 0, 0, 0 };
        CHECK(hIndex(zeros, 3) == 0);
    }
    {
        int oneHundred[1] = { 100 };
        CHECK(hIndex(oneHundred, 1) == 1);
    }
    printf("h_index: OK\n");
    return 0;
}
