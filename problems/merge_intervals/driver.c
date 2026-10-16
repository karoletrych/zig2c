#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static int check_row(int *row, int a, int b) {
    if (row[0] != a || row[1] != b) {
        printf("FAIL: row [%d,%d] != [%d,%d] (line %d)\n", row[0], row[1], a, b, __LINE__);
        return 1;
    }
    return 0;
}

int main(void) {
    {
        int a0[2] = { 1, 3 };
        int a1[2] = { 2, 6 };
        int a2[2] = { 8, 10 };
        int a3[2] = { 15, 18 };
        int *iv[4] = { a0, a1, a2, a3 };
        int cols[4] = { 2, 2, 2, 2 };
        int rs = 0;
        int *cb = NULL;
        int **r = merge(iv, 4, cols, &rs, &cb);
        CHECK(rs == 3);
        CHECK(cb[0] == 2);
        CHECK(check_row(r[0], 1, 6) == 0);
        CHECK(check_row(r[1], 8, 10) == 0);
        CHECK(check_row(r[2], 15, 18) == 0);
    }
    {
        int a0[2] = { 1, 4 };
        int a1[2] = { 4, 5 };
        int *iv[2] = { a0, a1 };
        int cols[2] = { 2, 2 };
        int rs = 0;
        int *cb = NULL;
        int **r = merge(iv, 2, cols, &rs, &cb);
        CHECK(rs == 1);
        CHECK(check_row(r[0], 1, 5) == 0);
    }
    {
        int a0[2] = { 1, 4 };
        int a1[2] = { 0, 4 };
        int *iv[2] = { a0, a1 };
        int cols[2] = { 2, 2 };
        int rs = 0;
        int *cb = NULL;
        int **r = merge(iv, 2, cols, &rs, &cb);
        CHECK(rs == 1);
        CHECK(check_row(r[0], 0, 4) == 0);
    }
    {
        int cols[1] = { 2 };
        int rs = 0;
        int *cb = NULL;
        int **r = merge(NULL, 0, cols, &rs, &cb);
        CHECK(rs == 0);
        (void)r;
    }
    {
        int a0[2] = { -2147483647 - 1, 2147483647 };
        int a1[2] = { 0, 5 };
        int *iv[2] = { a0, a1 };
        int cols[2] = { 2, 2 };
        int rs = 0;
        int *cb = NULL;
        int **r = merge(iv, 2, cols, &rs, &cb);
        CHECK(rs == 1);
        CHECK(check_row(r[0], -2147483647 - 1, 2147483647) == 0);
    }
    printf("merge_intervals: OK\n");
    return 0;
}
