#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static int approx(double a, double b) { return (a - b) < 1e-9 && (b - a) < 1e-9; }

int main(void) {
    {
        int a[2] = { 1, 3 };
        int b[1] = { 2 };
        CHECK(approx(findMedianSortedArrays(a, 2, b, 1), 2.0));
    }
    {
        int a[2] = { 1, 2 };
        int b[2] = { 3, 4 };
        CHECK(approx(findMedianSortedArrays(a, 2, b, 2), 2.5));
    }
    {
        int e[1] = { 0 };
        int o[3] = { 1, 2, 3 };
        CHECK(approx(findMedianSortedArrays(e, 0, o, 3), 2.0));
        int v[4] = { 1, 2, 3, 4 };
        CHECK(approx(findMedianSortedArrays(v, 4, e, 0), 2.5));
    }
    {
        int a[1] = { 5 };
        int b[1] = { 7 };
        CHECK(approx(findMedianSortedArrays(a, 1, b, 1), 6.0));
        int c[1] = { 4 };
        CHECK(approx(findMedianSortedArrays(c, 1, c, 1), 4.0));
    }
    {
        int p[4] = { 1, 3, 5, 7 };
        int q[4] = { 2, 4, 6, 8 };
        CHECK(approx(findMedianSortedArrays(p, 4, q, 4), 4.5));
    }
    {
        int lo[3] = { 1, 2, 3 };
        int hi[3] = { 10, 20, 30 };
        CHECK(approx(findMedianSortedArrays(lo, 3, hi, 3), 6.5));
    }
    {
        int n1[3] = { -5, -3, -1 };
        int n2[3] = { -4, -2, 0 };
        CHECK(approx(findMedianSortedArrays(n1, 3, n2, 3), -2.5));
    }
    printf("median_two_sorted: OK\n");
    return 0;
}
