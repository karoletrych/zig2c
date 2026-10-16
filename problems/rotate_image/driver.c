#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int r0[] = { 1, 2, 3 };
        int r1[] = { 4, 5, 6 };
        int r2[] = { 7, 8, 9 };
        int *m[] = { r0, r1, r2 };
        int cols[] = { 3, 3, 3 };
        rotate(m, 3, cols);
        CHECK(r0[0] == 7 && r0[1] == 4 && r0[2] == 1);
        CHECK(r1[0] == 8 && r1[1] == 5 && r1[2] == 2);
        CHECK(r2[0] == 9 && r2[1] == 6 && r2[2] == 3);
    }
    {
        int r0[] = { 5, 1, 9, 11 };
        int r1[] = { 2, 4, 8, 10 };
        int r2[] = { 13, 3, 6, 7 };
        int r3[] = { 15, 14, 12, 16 };
        int *m[] = { r0, r1, r2, r3 };
        int cols[] = { 4, 4, 4, 4 };
        rotate(m, 4, cols);
        CHECK(r0[0] == 15 && r0[1] == 13 && r0[2] == 2 && r0[3] == 5);
        CHECK(r1[0] == 14 && r1[1] == 3 && r1[2] == 4 && r1[3] == 1);
        CHECK(r2[0] == 12 && r2[1] == 6 && r2[2] == 8 && r2[3] == 9);
        CHECK(r3[0] == 16 && r3[1] == 7 && r3[2] == 10 && r3[3] == 11);
    }
    {
        int r0[] = { 42 };
        int *m[] = { r0 };
        int cols[] = { 1 };
        rotate(m, 1, cols);
        CHECK(r0[0] == 42);
    }
    printf("rotate_image: OK\n");
    return 0;
}
