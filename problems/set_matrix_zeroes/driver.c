#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int r0[] = { 1, 1, 1 };
        int r1[] = { 1, 0, 1 };
        int r2[] = { 1, 1, 1 };
        int *m[] = { r0, r1, r2 };
        int cols[] = { 3, 3, 3 };
        setZeroes(m, 3, cols);
        CHECK(r0[0] == 1 && r0[1] == 0 && r0[2] == 1);
        CHECK(r1[0] == 0 && r1[1] == 0 && r1[2] == 0);
        CHECK(r2[0] == 1 && r2[1] == 0 && r2[2] == 1);
    }
    {
        int r0[] = { 0, 1, 2, 0 };
        int r1[] = { 3, 4, 5, 2 };
        int r2[] = { 1, 3, 1, 5 };
        int *m[] = { r0, r1, r2 };
        int cols[] = { 4, 4, 4 };
        setZeroes(m, 3, cols);
        CHECK(r0[0] == 0 && r0[1] == 0 && r0[2] == 0 && r0[3] == 0);
        CHECK(r1[0] == 0 && r1[1] == 4 && r1[2] == 5 && r1[3] == 0);
        CHECK(r2[0] == 0 && r2[1] == 3 && r2[2] == 1 && r2[3] == 0);
    }
    {
        int r0[] = { 0, 2 };
        int r1[] = { 3, 4 };
        int *m[] = { r0, r1 };
        int cols[] = { 2, 2 };
        setZeroes(m, 2, cols);
        CHECK(r0[0] == 0 && r0[1] == 0);
        CHECK(r1[0] == 0 && r1[1] == 4);
    }
    {
        int s0[] = { 1, 0, 3 };
        int *m[] = { s0 };
        int cols[] = { 3 };
        setZeroes(m, 1, cols);
        CHECK(s0[0] == 0 && s0[1] == 0 && s0[2] == 0);
    }
    printf("set_matrix_zeroes: OK\n");
    return 0;
}
