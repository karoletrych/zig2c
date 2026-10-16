#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a0[2] = { 1, 0 };
        int *p[1] = { a0 };
        int cols[1] = { 2 };
        CHECK(canFinish(2, p, 1, cols));
    }
    {
        int a0[2] = { 1, 0 };
        int a1[2] = { 0, 1 };
        int *p[2] = { a0, a1 };
        int cols[2] = { 2, 2 };
        CHECK(!canFinish(2, p, 2, cols));
    }
    {
        int *p[1] = { NULL };
        int cols[1] = { 0 };
        CHECK(canFinish(1, p, 0, cols));
        CHECK(canFinish(5, p, 0, cols));
    }
    {
        int e0[2] = { 1, 0 };
        int e1[2] = { 2, 1 };
        int e2[2] = { 3, 2 };
        int *p[3] = { e0, e1, e2 };
        int cols[3] = { 2, 2, 2 };
        CHECK(canFinish(4, p, 3, cols));
    }
    {
        int f0[2] = { 1, 0 };
        int f1[2] = { 2, 0 };
        int f2[2] = { 3, 1 };
        int f3[2] = { 3, 2 };
        int *p[4] = { f0, f1, f2, f3 };
        int cols[4] = { 2, 2, 2, 2 };
        CHECK(canFinish(4, p, 4, cols));
    }
    {
        int g0[2] = { 0, 0 };
        int *p[1] = { g0 };
        int cols[1] = { 2 };
        CHECK(!canFinish(1, p, 1, cols));
    }
    {
        int h0[2] = { 1, 0 };
        int h1[2] = { 3, 2 };
        int h2[2] = { 2, 3 };
        int *p[3] = { h0, h1, h2 };
        int cols[3] = { 2, 2, 2 };
        CHECK(!canFinish(4, p, 3, cols));
    }
    printf("course_schedule: OK\n");
    return 0;
}
