#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static int rowEq(const int *r, int len, const int *want, int wantLen) {
    if (len != wantLen) return 0;
    for (int i = 0; i < wantLen; i++) if (r[i] != want[i]) return 0;
    return 1;
}

int main(void) {
    {
        int cands[4] = { 2, 3, 6, 7 };
        int rs = 0;
        int *cb[1] = { NULL };
        int **r = combinationSum(cands, 4, 7, &rs, cb);
        CHECK(rs == 2);
        CHECK(cb[0] != NULL);
        static const int w0[3] = { 2, 2, 3 };
        static const int w1[1] = { 7 };
        CHECK(rowEq(r[0], cb[0][0], w0, 3));
        CHECK(rowEq(r[1], cb[0][1], w1, 1));
    }
    {
        int c[3] = { 2, 3, 5 };
        int rs = 0;
        int *cb[1] = { NULL };
        int **r = combinationSum(c, 3, 8, &rs, cb);
        CHECK(rs == 3);
        static const int v0[4] = { 2, 2, 2, 2 };
        static const int v1[3] = { 2, 3, 3 };
        static const int v2[2] = { 3, 5 };
        CHECK(rowEq(r[0], cb[0][0], v0, 4));
        CHECK(rowEq(r[1], cb[0][1], v1, 3));
        CHECK(rowEq(r[2], cb[0][2], v2, 2));
    }
    {
        int c[1] = { 2 };
        int rs = 0;
        int *cb[1] = { NULL };
        int **r = combinationSum(c, 1, 3, &rs, cb);
        CHECK(r != NULL && rs == 0);
    }
    {
        int c[1] = { 5 };
        int rs = 0;
        int *cb[1] = { NULL };
        int **r = combinationSum(c, 1, 5, &rs, cb);
        CHECK(rs == 1 && cb[0][0] == 1 && r[0][0] == 5);
    }
    {
        int c[1] = { 1 };
        int rs = 0;
        int *cb[1] = { NULL };
        int **r = combinationSum(c, 1, 4, &rs, cb);
        CHECK(rs == 1 && cb[0][0] == 4);
        for (int i = 0; i < 4; i++) CHECK(r[0][i] == 1);
    }
    {
        int c[3] = { 3, 2, 5 };
        int rs = 0;
        int *cb[1] = { NULL };
        int **r = combinationSum(c, 3, 8, &rs, cb);
        CHECK(rs == 3);
        static const int u0[3] = { 3, 3, 2 };
        static const int u1[2] = { 3, 5 };
        static const int u2[4] = { 2, 2, 2, 2 };
        CHECK(rowEq(r[0], cb[0][0], u0, 3));
        CHECK(rowEq(r[1], cb[0][1], u1, 2));
        CHECK(rowEq(r[2], cb[0][2], u2, 4));
    }
    printf("combination_sum: OK\n");
    return 0;
}
