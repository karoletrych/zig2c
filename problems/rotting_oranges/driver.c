#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int r0[3] = { 2, 1, 1 };
        int r1[3] = { 1, 1, 0 };
        int r2[3] = { 0, 1, 1 };
        int *g[3] = { r0, r1, r2 };
        int cols[3] = { 3, 3, 3 };
        CHECK(orangesRotting(g, 3, cols) == 4);
    }
    {
        int r0[3] = { 2, 1, 1 };
        int r1[3] = { 0, 1, 1 };
        int r2[3] = { 1, 0, 1 };
        int *g[3] = { r0, r1, r2 };
        int cols[3] = { 3, 3, 3 };
        CHECK(orangesRotting(g, 3, cols) == -1);
    }
    {
        int r0[2] = { 0, 2 };
        int *g[1] = { r0 };
        int cols[1] = { 2 };
        CHECK(orangesRotting(g, 1, cols) == 0);
    }
    {
        int r0[1] = { 0 };
        int *g[1] = { r0 };
        int cols[1] = { 1 };
        CHECK(orangesRotting(g, 1, cols) == 0);
    }
    {
        int r0[1] = { 1 };
        int *g[1] = { r0 };
        int cols[1] = { 1 };
        CHECK(orangesRotting(g, 1, cols) == -1);
    }
    {
        int r0[1] = { 2 };
        int *g[1] = { r0 };
        int cols[1] = { 1 };
        CHECK(orangesRotting(g, 1, cols) == 0);
    }
    printf("rotting_oranges: OK\n");
    return 0;
}
