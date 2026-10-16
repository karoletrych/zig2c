#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int nums[4] = { 2, 7, 11, 15 };
    int rs = 0;
    int *r = twoSum(nums, 4, 9, &rs);
    CHECK(rs == 2);
    CHECK(r[0] == 0 && r[1] == 1);

    int nums2[3] = { 3, 2, 4 };
    rs = 0;
    r = twoSum(nums2, 3, 6, &rs);
    CHECK(rs == 2);
    CHECK(r[0] == 1 && r[1] == 2);

    printf("two_sum: OK\n");
    return 0;
}
