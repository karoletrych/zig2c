#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a[6] = { 1, 7, 3, 6, 5, 6 };
    CHECK(pivotIndex(a, 6) == 3);

    int b[3] = { 1, 2, 3 };
    CHECK(pivotIndex(b, 3) == -1);

    int c[3] = { 2, 1, -1 };
    CHECK(pivotIndex(c, 3) == 0);

    int d[1] = { 0 };
    CHECK(pivotIndex(d, 1) == 0);

    int e[6] = { -1, -1, -1, -1, -1, 0 };
    CHECK(pivotIndex(e, 6) == 2);

    printf("pivot_index: OK\n");
    return 0;
}
