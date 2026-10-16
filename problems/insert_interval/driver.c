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
        int a1[2] = { 6, 9 };
        int *iv[2] = { a0, a1 };
        int cols[2] = { 2, 2 };
        int ni[2] = { 2, 5 };
        int rs = 0;
        int *cb = NULL;
        int **r = insert(iv, 2, cols, ni, 2, &rs, &cb);
        CHECK(rs == 2);
        CHECK(check_row(r[0], 1, 5) == 0);
        CHECK(check_row(r[1], 6, 9) == 0);
    }
    {
        int a0[2] = { 1, 2 };
        int a1[2] = { 3, 5 };
        int a2[2] = { 6, 7 };
        int a3[2] = { 8, 10 };
        int a4[2] = { 12, 16 };
        int *iv[5] = { a0, a1, a2, a3, a4 };
        int cols[5] = { 2, 2, 2, 2, 2 };
        int ni[2] = { 4, 8 };
        int rs = 0;
        int *cb = NULL;
        int **r = insert(iv, 5, cols, ni, 2, &rs, &cb);
        CHECK(rs == 3);
        CHECK(check_row(r[0], 1, 2) == 0);
        CHECK(check_row(r[1], 3, 10) == 0);
        CHECK(check_row(r[2], 12, 16) == 0);
    }
    {
        int cols[1] = { 2 };
        int ni[2] = { 5, 7 };
        int rs = 0;
        int *cb = NULL;
        int **r = insert(NULL, 0, cols, ni, 2, &rs, &cb);
        CHECK(rs == 1);
        CHECK(check_row(r[0], 5, 7) == 0);
    }
    {
        int a0[2] = { 1, 5 };
        int *iv[1] = { a0 };
        int cols[1] = { 2 };
        int ni[2] = { 2, 3 };
        int rs = 0;
        int *cb = NULL;
        int **r = insert(iv, 1, cols, ni, 2, &rs, &cb);
        CHECK(rs == 1);
        CHECK(check_row(r[0], 1, 5) == 0);
    }
    {
        int a0[2] = { 1, 5 };
        int *iv[1] = { a0 };
        int cols[1] = { 2 };
        int ni[2] = { 6, 8 };
        int rs = 0;
        int *cb = NULL;
        int **r = insert(iv, 1, cols, ni, 2, &rs, &cb);
        CHECK(rs == 2);
        CHECK(check_row(r[0], 1, 5) == 0);
        CHECK(check_row(r[1], 6, 8) == 0);
    }
    {
        int cols[1] = { 2 };
        int ni[2] = { -2147483647 - 1, 2147483647 };
        int rs = 0;
        int *cb = NULL;
        int **r = insert(NULL, 0, cols, ni, 2, &rs, &cb);
        CHECK(rs == 1);
        CHECK(check_row(r[0], -2147483647 - 1, 2147483647) == 0);
    }
    printf("insert_interval: OK\n");
    return 0;
}
