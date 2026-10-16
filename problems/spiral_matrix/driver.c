#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int r0[] = { 1, 2, 3 };
        int r1[] = { 4, 5, 6 };
        int r2[] = { 7, 8, 9 };
        int *m[] = { r0, r1, r2 };
        int cols[] = { 3, 3, 3 };
        int rs = 0;
        int *out = spiralOrder(m, 3, cols, &rs);
        int want[] = { 1, 2, 3, 6, 9, 8, 7, 4, 5 };
        int i;
        CHECK(rs == 9);
        for (i = 0; i < 9; i++) CHECK(out[i] == want[i]);
    }
    {
        int r0[] = { 1, 2, 3, 4 };
        int r1[] = { 5, 6, 7, 8 };
        int r2[] = { 9, 10, 11, 12 };
        int *m[] = { r0, r1, r2 };
        int cols[] = { 4, 4, 4 };
        int rs = 0;
        int *out = spiralOrder(m, 3, cols, &rs);
        int want[] = { 1, 2, 3, 4, 8, 12, 11, 10, 9, 5, 6, 7 };
        int i;
        CHECK(rs == 12);
        for (i = 0; i < 12; i++) CHECK(out[i] == want[i]);
    }
    {
        int s0[] = { 1, 2, 3 };
        int *m[] = { s0 };
        int cols[] = { 3 };
        int rs = 0;
        int *out = spiralOrder(m, 1, cols, &rs);
        CHECK(rs == 3);
        CHECK(out[0] == 1 && out[1] == 2 && out[2] == 3);
    }
    {
        int c0[] = { 1 };
        int c1[] = { 2 };
        int c2[] = { 3 };
        int *m[] = { c0, c1, c2 };
        int cols[] = { 1, 1, 1 };
        int rs = 0;
        int *out = spiralOrder(m, 3, cols, &rs);
        CHECK(rs == 3);
        CHECK(out[0] == 1 && out[1] == 2 && out[2] == 3);
    }
    {
        int rs = 5;
        int *out = spiralOrder(NULL, 0, NULL, &rs);
        CHECK(rs == 0);
        (void)out;
    }
    printf("spiral_matrix: OK\n");
    return 0;
}
