#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int r0[3] = { 3, 2, 1 };
        int r1[3] = { 1, 7, 6 };
        int r2[3] = { 2, 7, 7 };
        int *grid[3] = { r0, r1, r2 };
        int cols[1] = { 3 };
        CHECK(equalPairs(grid, 3, cols) == 1);
    }
    {
        int r0[2] = { 11, 1 };
        int r1[2] = { 1, 11 };
        int *grid[2] = { r0, r1 };
        int cols[1] = { 2 };
        CHECK(equalPairs(grid, 2, cols) == 2);
    }
    {
        int r0[2] = { 4, 4 };
        int r1[2] = { 4, 4 };
        int *grid[2] = { r0, r1 };
        int cols[1] = { 2 };
        CHECK(equalPairs(grid, 2, cols) == 4);
    }
    {
        int r0[1] = { 5 };
        int *grid[1] = { r0 };
        int cols[1] = { 1 };
        CHECK(equalPairs(grid, 1, cols) == 1);
    }
    printf("equal_row_col_pairs: OK\n");
    return 0;
}
