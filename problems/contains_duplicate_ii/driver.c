#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[4] = { 1, 2, 3, 1 };
        CHECK(containsNearbyDuplicate(a, 4, 3));
    }
    {
        int b[4] = { 1, 0, 1, 1 };
        CHECK(containsNearbyDuplicate(b, 4, 1));
    }
    {
        int c[6] = { 1, 2, 3, 1, 2, 3 };
        CHECK(!containsNearbyDuplicate(c, 6, 2));
    }
    {
        int d[1] = { 1 };
        CHECK(!containsNearbyDuplicate(d, 1, 100));
    }
    {
        int e[3] = { 1, 1, 1 };
        CHECK(!containsNearbyDuplicate(e, 3, 0));
        CHECK(containsNearbyDuplicate(e, 3, 1));
    }
    {
        int f[3] = { -7, 3, -7 };
        CHECK(containsNearbyDuplicate(f, 3, 2));
        CHECK(!containsNearbyDuplicate(f, 3, 1));
    }
    printf("contains_duplicate_ii: OK\n");
    return 0;
}
