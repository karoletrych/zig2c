#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[5] = { 3, 4, 5, 1, 2 };
        CHECK(findMin(a, 5) == 1);
    }
    {
        int a[7] = { 4, 5, 6, 7, 0, 1, 2 };
        CHECK(findMin(a, 7) == 0);
    }
    {
        int a[4] = { 11, 13, 15, 17 };
        CHECK(findMin(a, 4) == 11);
    }
    {
        int a[1] = { 1 };
        CHECK(findMin(a, 1) == 1);
    }
    {
        int a[2] = { 2, 1 };
        CHECK(findMin(a, 2) == 1);
    }
    {
        int a[2] = { 1, 2 };
        CHECK(findMin(a, 2) == 1);
    }
    {
        int a[3] = { 2, 3, 1 };
        CHECK(findMin(a, 3) == 1);
    }
    {
        int a[3] = { 3, 1, 2 };
        CHECK(findMin(a, 3) == 1);
    }
    {
        int a[3] = { 2, 1, 0 };
        CHECK(findMin(a, 3) == 0);
    }
    {
        int a[5] = { 5, 1, 2, 3, 4 };
        CHECK(findMin(a, 5) == 1);
    }
    {
        int a[5] = { 3, -2, -1, 0, 1 };
        CHECK(findMin(a, 5) == -2);
    }
    printf("find_min_rotated: OK\n");
    return 0;
}
