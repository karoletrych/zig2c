#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int r0[] = { 1, 3, 1 };
        int r1[] = { 1, 5, 1 };
        int r2[] = { 4, 2, 1 };
        int *g[] = { r0, r1, r2 };
        int cols[] = { 3, 3, 3 };
        CHECK(minPathSum(g, 3, cols) == 7);
    }
    {
        int r0[] = { 1, 2, 3 };
        int r1[] = { 4, 5, 6 };
        int *g[] = { r0, r1 };
        int cols[] = { 3, 3 };
        CHECK(minPathSum(g, 2, cols) == 12);
    }
    {
        int r0[] = { 1 };
        int *g[] = { r0 };
        int cols[] = { 1 };
        CHECK(minPathSum(g, 1, cols) == 1);
    }
    {
        int r0[] = { 5, 6, 7 };
        int *g[] = { r0 };
        int cols[] = { 3 };
        CHECK(minPathSum(g, 1, cols) == 18);
    }
    {
        int r0[] = { 5 };
        int r1[] = { 6 };
        int r2[] = { 7 };
        int *g[] = { r0, r1, r2 };
        int cols[] = { 1 };
        CHECK(minPathSum(g, 3, cols) == 18);
    }
    {
        int r0[] = { 0, 0 };
        int r1[] = { 0, 0 };
        int *g[] = { r0, r1 };
        int cols[] = { 2, 2 };
        CHECK(minPathSum(g, 2, cols) == 0);
    }
    printf("min_path_sum: OK\n");
    return 0;
}
