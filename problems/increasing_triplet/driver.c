#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a[5] = { 1, 2, 3, 4, 5 };
    CHECK(increasingTriplet(a, 5) == true);

    int b[5] = { 5, 4, 3, 2, 1 };
    CHECK(increasingTriplet(b, 5) == false);

    int c[6] = { 2, 1, 5, 0, 4, 6 };
    CHECK(increasingTriplet(c, 6) == true);

    int d[3] = { 1, 1, 1 };
    CHECK(increasingTriplet(d, 3) == false);

    int e[2] = { 1, 2 };
    CHECK(increasingTriplet(e, 2) == false);

    int f[6] = { 20, 100, 10, 12, 5, 13 };
    CHECK(increasingTriplet(f, 6) == true);

    printf("increasing_triplet: OK\n");
    return 0;
}
