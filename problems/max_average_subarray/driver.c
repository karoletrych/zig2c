#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static int approx(double a, double b) { return (a - b) < 1e-9 && (b - a) < 1e-9; }

int main(void) {
    int nums[6] = { 1, 12, -5, -6, 50, 3 };
    CHECK(approx(findMaxAverage(nums, 6, 4), 12.75));

    int one[1] = { 5 };
    CHECK(approx(findMaxAverage(one, 1, 1), 5.0));

    int neg[4] = { -1, -2, -3, -4 };
    CHECK(approx(findMaxAverage(neg, 4, 2), -1.5));

    printf("max_average_subarray: OK\n");
    return 0;
}
