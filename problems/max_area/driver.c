#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a[9] = { 1, 8, 6, 2, 5, 4, 8, 3, 7 };
    CHECK(maxArea(a, 9) == 49);
    int b[2] = { 1, 1 };
    CHECK(maxArea(b, 2) == 1);
    printf("max_area: OK\n");
    return 0;
}
