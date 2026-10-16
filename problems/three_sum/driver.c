#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int nums[] = { -1, 0, 1, 2, -1, -4 };
        int rs = 0;
        int *cb = NULL;
        int **r = threeSum(nums, 6, &rs, &cb);
        CHECK(rs == 2);
        CHECK(cb[0] == 3 && cb[1] == 3);
        CHECK(r[0][0] == -1 && r[0][1] == -1 && r[0][2] == 2);
        CHECK(r[1][0] == -1 && r[1][1] == 0 && r[1][2] == 1);
    }
    {
        int nums[] = { 0, 1, 1 };
        int rs = 3;
        int *cb = NULL;
        int **r = threeSum(nums, 3, &rs, &cb);
        CHECK(rs == 0);
        (void)r;
    }
    {
        int nums[] = { 0, 0, 0 };
        int rs = 0;
        int *cb = NULL;
        int **r = threeSum(nums, 3, &rs, &cb);
        CHECK(rs == 1);
        CHECK(cb[0] == 3);
        CHECK(r[0][0] == 0 && r[0][1] == 0 && r[0][2] == 0);
    }
    {
        int nums[] = { 0, 0, 0, 0, 0, 0 };
        int rs = 0;
        int *cb = NULL;
        int **r = threeSum(nums, 6, &rs, &cb);
        CHECK(rs == 1);
        CHECK(cb[0] == 3);
        (void)r;
    }
    {
        int nums[] = { 0, 0 };
        int rs = 9;
        int *cb = NULL;
        int **r = threeSum(nums, 2, &rs, &cb);
        CHECK(rs == 0);
        (void)r;
    }
    {
        int nums[] = { -2, 0, 0, 2, 2 };
        int rs = 0;
        int *cb = NULL;
        int **r = threeSum(nums, 5, &rs, &cb);
        CHECK(rs == 1);
        CHECK(cb[0] == 3);
        CHECK(r[0][0] == -2 && r[0][1] == 0 && r[0][2] == 2);
    }
    printf("three_sum: OK\n");
    return 0;
}
