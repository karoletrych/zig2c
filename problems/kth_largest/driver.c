#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a[6] = { 3, 2, 1, 5, 6, 4 };
    CHECK(findKthLargest(a, 6, 2) == 5);
    int b[9] = { 3, 2, 3, 1, 2, 4, 5, 5, 6 };
    CHECK(findKthLargest(b, 9, 4) == 4);
    printf("kth_largest: OK\n");
    return 0;
}
