#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int r0[3] = { 1, 1, 0 };
        int r1[3] = { 1, 1, 0 };
        int r2[3] = { 0, 0, 1 };
        int *m[3] = { r0, r1, r2 };
        int cols[3] = { 3, 3, 3 };
        CHECK(findCircleNum(m, 3, cols) == 2);
    }
    {
        int r0[3] = { 1, 0, 0 };
        int r1[3] = { 0, 1, 0 };
        int r2[3] = { 0, 0, 1 };
        int *m[3] = { r0, r1, r2 };
        int cols[3] = { 3, 3, 3 };
        CHECK(findCircleNum(m, 3, cols) == 3);
    }
    {
        int r0[1] = { 1 };
        int *m[1] = { r0 };
        int cols[1] = { 1 };
        CHECK(findCircleNum(m, 1, cols) == 1);
    }
    {
        int r0[2] = { 1, 0 };
        int r1[2] = { 0, 1 };
        int *m[2] = { r0, r1 };
        int cols[2] = { 2, 2 };
        CHECK(findCircleNum(m, 2, cols) == 2);
    }
    printf("number_of_provinces: OK\n");
    return 0;
}
