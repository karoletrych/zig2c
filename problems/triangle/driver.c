#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int r0[] = { 2 };
        int r1[] = { 3, 4 };
        int r2[] = { 6, 5, 7 };
        int r3[] = { 4, 1, 8, 3 };
        int *t[] = { r0, r1, r2, r3 };
        int cols[] = { 1, 2, 3, 4 };
        CHECK(minimumTotal(t, 4, cols) == 11);
    }
    {
        int r0[] = { -10 };
        int *t[] = { r0 };
        int cols[] = { 1 };
        CHECK(minimumTotal(t, 1, cols) == -10);
    }
    {
        int r0[] = { -1 };
        int r1[] = { 2, 3 };
        int r2[] = { 1, -1, -3 };
        int *t[] = { r0, r1, r2 };
        int cols[] = { 1, 2, 3 };
        CHECK(minimumTotal(t, 3, cols) == -1);
    }
    {
        int r0[] = { 1 };
        int r1[] = { 1, 1 };
        int *t[] = { r0, r1 };
        int cols[] = { 1, 2 };
        CHECK(minimumTotal(t, 2, cols) == 2);
    }
    printf("triangle: OK\n");
    return 0;
}
