#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int rs = 0;
        int *cb[1] = { NULL };
        int **r = combine(4, 2, &rs, cb);
        CHECK(rs == 6);
        CHECK(cb[0] != NULL && cb[0][0] == 2);
        static const int want[6][2] = {
            { 1, 2 }, { 1, 3 }, { 1, 4 }, { 2, 3 }, { 2, 4 }, { 3, 4 },
        };
        for (int i = 0; i < 6; i++) {
            CHECK(r[i][0] == want[i][0]);
            CHECK(r[i][1] == want[i][1]);
        }
    }
    {
        int rs = 0;
        int *cb[1] = { NULL };
        int **r = combine(3, 3, &rs, cb);
        CHECK(rs == 1);
        CHECK(cb[0][0] == 3);
        CHECK(r[0][0] == 1 && r[0][1] == 2 && r[0][2] == 3);
    }
    {
        int rs = 0;
        int *cb[1] = { NULL };
        int **r = combine(4, 1, &rs, cb);
        CHECK(rs == 4);
        CHECK(cb[0][0] == 1);
        for (int i = 0; i < 4; i++) CHECK(r[i][0] == i + 1);
    }
    {
        int rs = 0;
        int *cb[1] = { NULL };
        int **r = combine(2, 3, &rs, cb);
        CHECK(r != NULL && rs == 0);
    }
    {
        int rs = 0;
        int *cb[1] = { NULL };
        int **r = combine(20, 10, &rs, cb);
        CHECK(r != NULL && rs == 184756);
        CHECK(cb[0][0] == 10);
        CHECK(r[0][0] == 1 && r[0][1] == 2 && r[rs - 1][9] == 20);
    }
    printf("combinations: OK\n");
    return 0;
}
