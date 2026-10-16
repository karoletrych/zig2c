#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[3] = { 1, 7, 11 };
        int b[3] = { 2, 4, 6 };
        int rs = 0;
        int *cb = NULL;
        int **r = kSmallestPairs(a, 3, b, 3, 3, &rs, &cb);
        CHECK(rs == 3);
        CHECK(cb[0] == 2 && cb[1] == 2 && cb[2] == 2);
        CHECK(r[0][0] == 1 && r[0][1] == 2);
        CHECK(r[1][0] == 1 && r[1][1] == 4);
        CHECK(r[2][0] == 1 && r[2][1] == 6);
    }
    {
        int a[3] = { 1, 1, 2 };
        int b[3] = { 1, 2, 3 };
        int rs = 0;
        int *cb = NULL;
        int **r = kSmallestPairs(a, 3, b, 3, 2, &rs, &cb);
        CHECK(rs == 2);
        CHECK(r[0][0] == 1 && r[0][1] == 1);
        CHECK(r[1][0] == 1 && r[1][1] == 1);
    }
    {
        int a[2] = { 1, 2 };
        int b[1] = { 3 };
        int rs = 0;
        int *cb = NULL;
        int **r = kSmallestPairs(a, 2, b, 1, 5, &rs, &cb);
        CHECK(rs == 2);
        CHECK(r[0][0] == 1 && r[0][1] == 3);
        CHECK(r[1][0] == 2 && r[1][1] == 3);
    }
    {
        int a[1] = { 2 };
        int b[1] = { 4 };
        int rs = 0;
        int *cb = NULL;
        int **r = kSmallestPairs(a, 1, b, 1, 100, &rs, &cb);
        CHECK(rs == 1);
        CHECK(r[0][0] == 2 && r[0][1] == 4);
    }
    {
        int a[2] = { 1, 2 };
        int b[1] = { 3 };
        int rs = 7;
        int *cb = NULL;
        int **r = kSmallestPairs(a, 2, b, 1, 0, &rs, &cb);
        CHECK(rs == 0);
        (void)r;
    }
    {
        int n1[3] = { -3, -1, 5 };
        int n2[2] = { -2, 4 };
        int rs = 0;
        int *cb = NULL;
        int **r = kSmallestPairs(n1, 3, n2, 2, 3, &rs, &cb);
        CHECK(rs == 3);
        CHECK(r[0][0] == -3 && r[0][1] == -2);
        CHECK(r[1][0] == -1 && r[1][1] == -2);
        CHECK(r[2][0] == -3 && r[2][1] == 4);
    }
    printf("k_pairs_smallest_sums: OK\n");
    return 0;
}
