#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a[4] = { 1, 2, 3, 4 };
    CHECK(maxOperations(a, 4, 5) == 2);

    int b[5] = { 3, 1, 3, 4, 3 };
    CHECK(maxOperations(b, 5, 6) == 1);

    int c[4] = { 1, 2, 3, 4 };
    CHECK(maxOperations(c, 4, 100) == 0);

    int d[4] = { 2, 2, 2, 2 };
    CHECK(maxOperations(d, 4, 4) == 2);

    int e[13] = { 4, 4, 1, 3, 1, 3, 2, 2, 5, 5, 5, 5, 5 };
    CHECK(maxOperations(e, 13, 6) == 5);

    int f[1] = { 1 };
    CHECK(maxOperations(f, 1, 2) == 0);

    printf("max_k_sum_pairs: OK\n");
    return 0;
}
