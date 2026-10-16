#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int r0[4] = { 1, 3, 5, 7 };
        int r1[4] = { 10, 11, 16, 20 };
        int r2[4] = { 23, 30, 34, 60 };
        int *m[3] = { r0, r1, r2 };
        int cols[3] = { 4, 4, 4 };
        CHECK(searchMatrix(m, 3, cols, 3));
        CHECK(!searchMatrix(m, 3, cols, 13));
        CHECK(searchMatrix(m, 3, cols, 1));
        CHECK(searchMatrix(m, 3, cols, 60));
        CHECK(!searchMatrix(m, 3, cols, 0));
        CHECK(!searchMatrix(m, 3, cols, 61));
        CHECK(searchMatrix(m, 3, cols, 10));
        CHECK(searchMatrix(m, 3, cols, 23));
    }
    {
        int r0[3] = { 1, 2, 3 };
        int *m[1] = { r0 };
        int cols[1] = { 3 };
        CHECK(searchMatrix(m, 1, cols, 2));
        CHECK(!searchMatrix(m, 1, cols, 4));
    }
    {
        int r0[1] = { 1 };
        int r1[1] = { 3 };
        int r2[1] = { 5 };
        int *m[3] = { r0, r1, r2 };
        int cols[3] = { 1, 1, 1 };
        CHECK(searchMatrix(m, 3, cols, 3));
        CHECK(!searchMatrix(m, 3, cols, 4));
    }
    {
        int r0[1] = { 5 };
        int *m[1] = { r0 };
        int cols[1] = { 1 };
        CHECK(searchMatrix(m, 1, cols, 5));
        CHECK(!searchMatrix(m, 1, cols, -5));
    }
    printf("search_2d_matrix: OK\n");
    return 0;
}
