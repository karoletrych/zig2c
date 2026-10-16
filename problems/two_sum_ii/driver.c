#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[] = { 2, 7, 11, 15 };
        int rs = 0;
        int *r = twoSum(a, 4, 9, &rs);
        CHECK(rs == 2);
        CHECK(r[0] == 1 && r[1] == 2);
    }
    {
        int a[] = { 2, 3, 4 };
        int rs = 0;
        int *r = twoSum(a, 3, 6, &rs);
        CHECK(rs == 2);
        CHECK(r[0] == 1 && r[1] == 3);
    }
    {
        int a[] = { -1, 0 };
        int rs = 0;
        int *r = twoSum(a, 2, -1, &rs);
        CHECK(rs == 2);
        CHECK(r[0] == 1 && r[1] == 2);
    }
    {
        int a[] = { 1, 2, 3 };
        int rs = 7;
        int *r = twoSum(a, 3, 100, &rs);
        CHECK(rs == 0);
        (void)r;
    }
    printf("two_sum_ii: OK\n");
    return 0;
}
