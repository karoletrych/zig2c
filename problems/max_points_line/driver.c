#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int p0[] = { 1, 1 }, p1[] = { 2, 2 }, p2[] = { 3, 3 };
        int *pts[] = { p0, p1, p2 };
        int cols[] = { 2 };
        CHECK(maxPoints(pts, 3, cols) == 3);
    }
    {
        int q0[] = { 1, 1 }, q1[] = { 3, 2 }, q2[] = { 5, 3 };
        int q3[] = { 4, 1 }, q4[] = { 2, 3 }, q5[] = { 1, 4 };
        int *pts[] = { q0, q1, q2, q3, q4, q5 };
        int cols[] = { 2 };
        CHECK(maxPoints(pts, 6, cols) == 4);
    }
    {
        int p0[] = { 0, 0 };
        int *pts[] = { p0 };
        int cols[] = { 2 };
        CHECK(maxPoints(pts, 1, cols) == 1);
    }
    {
        int r0[] = { 1, 1 }, r1[] = { 1, 1 }, r2[] = { 2, 2 };
        int *pts[] = { r0, r1, r2 };
        int cols[] = { 2 };
        CHECK(maxPoints(pts, 3, cols) == 3);
    }
    {
        int s0[] = { 0, 0 }, s1[] = { 0, 0 }, s2[] = { 0, 0 };
        int *pts[] = { s0, s1, s2 };
        int cols[] = { 2 };
        CHECK(maxPoints(pts, 3, cols) == 3);
    }
    {
        int t0[] = { 0, 0 }, t1[] = { 1, 0 }, t2[] = { 2, 0 }, t3[] = { 0, 1 };
        int *pts[] = { t0, t1, t2, t3 };
        int cols[] = { 2 };
        CHECK(maxPoints(pts, 4, cols) == 3);
    }
    {
        int u0[] = { 0, 0 }, u1[] = { 0, 1 }, u2[] = { 0, 2 }, u3[] = { 1, 0 };
        int *pts[] = { u0, u1, u2, u3 };
        int cols[] = { 2 };
        CHECK(maxPoints(pts, 4, cols) == 3);
    }
    {
        int v0[] = { 0, 0 }, v1[] = { 1, 0 };
        int *pts[] = { v0, v1 };
        int cols[] = { 2 };
        CHECK(maxPoints(pts, 2, cols) == 2);
    }
    {
        int cols[] = { 2 };
        CHECK(maxPoints(NULL, 0, cols) == 0);
    }
    {
        int w0[] = { 0, 0 }, w1[] = { 1, 0 }, w2[] = { 1, 1 };
        int w3[] = { 0, 1 }, w4[] = { 0, 0 };
        int *pts[] = { w0, w1, w2, w3, w4 };
        int cols[] = { 2 };
        CHECK(maxPoints(pts, 5, cols) == 3);
    }
    printf("max_points_line: OK\n");
    return 0;
}
