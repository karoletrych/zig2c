#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int nums[3] = { 1, 2, 3 };
        int rs = 0;
        int *cb[1] = { NULL };
        int **r = permute(nums, 3, &rs, cb);
        CHECK(rs == 6);
        CHECK(cb[0] != NULL && cb[0][0] == 3);
        static const int want[6][3] = {
            { 1, 2, 3 }, { 1, 3, 2 }, { 2, 1, 3 },
            { 2, 3, 1 }, { 3, 1, 2 }, { 3, 2, 1 },
        };
        for (int i = 0; i < 6; i++)
            for (int j = 0; j < 3; j++) CHECK(r[i][j] == want[i][j]);
    }
    {
        int one[1] = { 7 };
        int rs = 0;
        int *cb[1] = { NULL };
        int **r = permute(one, 1, &rs, cb);
        CHECK(rs == 1 && cb[0][0] == 1 && r[0][0] == 7);
    }
    {
        int two[2] = { -1, 2 };
        int rs = 0;
        int *cb[1] = { NULL };
        int **r = permute(two, 2, &rs, cb);
        CHECK(rs == 2 && cb[0][0] == 2);
        CHECK(r[0][0] == -1 && r[0][1] == 2);
        CHECK(r[1][0] == 2 && r[1][1] == -1);
    }
    {
        int five[5] = { 1, 2, 3, 4, 5 };
        int rs = 0;
        int *cb[1] = { NULL };
        int **r = permute(five, 5, &rs, cb);
        CHECK(rs == 120 && cb[0][0] == 5);
        CHECK(r[0][0] == 1);
        CHECK(r[rs - 1][0] == 5);
    }
    printf("permutations: OK\n");
    return 0;
}
