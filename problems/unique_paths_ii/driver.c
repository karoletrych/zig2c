#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int r0[] = { 0, 0, 0 };
        int r1[] = { 0, 1, 0 };
        int r2[] = { 0, 0, 0 };
        int *g[] = { r0, r1, r2 };
        int cols[] = { 3, 3, 3 };
        CHECK(uniquePathsWithObstacles(g, 3, cols) == 2);
    }
    {
        int r0[] = { 0, 1 };
        int r1[] = { 0, 0 };
        int *g[] = { r0, r1 };
        int cols[] = { 2, 2 };
        CHECK(uniquePathsWithObstacles(g, 2, cols) == 1);
    }
    {
        int r0[] = { 0 };
        int *g[] = { r0 };
        int cols[] = { 1 };
        CHECK(uniquePathsWithObstacles(g, 1, cols) == 1);
    }
    {
        int r0[] = { 1 };
        int *g[] = { r0 };
        int cols[] = { 1 };
        CHECK(uniquePathsWithObstacles(g, 1, cols) == 0);
    }
    {
        int r0[] = { 1, 0 };
        int *g[] = { r0 };
        int cols[] = { 2 };
        CHECK(uniquePathsWithObstacles(g, 1, cols) == 0);
    }
    {
        int r0[] = { 0, 0 };
        int *g[] = { r0 };
        int cols[] = { 2 };
        CHECK(uniquePathsWithObstacles(g, 1, cols) == 1);
    }
    {
        int r0[] = { 1, 0 };
        int r1[] = { 0, 0 };
        int *g[] = { r0, r1 };
        int cols[] = { 2, 2 };
        CHECK(uniquePathsWithObstacles(g, 2, cols) == 0);
    }
    {
        int r0[] = { 0, 0 };
        int r1[] = { 1, 0 };
        int r2[] = { 0, 0 };
        int *g[] = { r0, r1, r2 };
        int cols[] = { 2, 2, 2 };
        CHECK(uniquePathsWithObstacles(g, 3, cols) == 1);
    }
    {
        int r0[] = { 1, 1, 1 };
        int r1[] = { 1, 1, 1 };
        int *g[] = { r0, r1 };
        int cols[] = { 3, 3 };
        CHECK(uniquePathsWithObstacles(g, 2, cols) == 0);
    }
    printf("unique_paths_ii: OK\n");
    return 0;
}
