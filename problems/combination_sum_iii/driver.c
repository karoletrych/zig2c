#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int rs = 0;
        int *cb = NULL;
        int **r = combinationSum3(3, 7, &rs, &cb);
        CHECK(rs == 1);
        CHECK(cb[0] == 3);
        CHECK(r[0][0] == 1);
        CHECK(r[0][1] == 2);
        CHECK(r[0][2] == 4);
    }
    {
        int rs = 0;
        int *cb = NULL;
        int **r = combinationSum3(3, 9, &rs, &cb);
        CHECK(rs == 3);
        CHECK(cb[0] == 3);
        CHECK(cb[2] == 3);
        CHECK(r[0][0] == 1 && r[0][1] == 2 && r[0][2] == 6);
        CHECK(r[1][0] == 1 && r[1][1] == 3 && r[1][2] == 5);
        CHECK(r[2][0] == 2 && r[2][1] == 3 && r[2][2] == 4);
    }
    {
        int rs = 0;
        int *cb = NULL;
        int **r = combinationSum3(4, 1, &rs, &cb);
        CHECK(rs == 0);
        (void)r;
    }
    {
        int rs = 0;
        int *cb = NULL;
        int **r = combinationSum3(2, 18, &rs, &cb);
        CHECK(rs == 0);
        (void)r;
    }
    {
        int rs = 0;
        int *cb = NULL;
        int **r = combinationSum3(9, 45, &rs, &cb);
        CHECK(rs == 1);
        CHECK(cb[0] == 9);
        int i;
        for (i = 0; i < 9; i++) CHECK(r[0][i] == i + 1);
    }
    {
        int rs = 0;
        int *cb = NULL;
        int **r = combinationSum3(4, 20, &rs, &cb);
        CHECK(rs == 12);
        CHECK(cb[0] == 4);
        CHECK(cb[11] == 4);
        CHECK(r[0][0] == 1 && r[0][1] == 2 && r[0][2] == 8 && r[0][3] == 9);
    }
    printf("combination_sum_iii: OK\n");
    return 0;
}
