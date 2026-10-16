#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int nums[4] = { 1, 2, 3, 4 };
    int rs = 0;
    int *r = productExceptSelf(nums, 4, &rs);
    CHECK(rs == 4);
    int want[4] = { 24, 12, 8, 6 };
    for (int i = 0; i < 4; i++) CHECK(r[i] == want[i]);
    printf("product_except_self: OK\n");
    return 0;
}
