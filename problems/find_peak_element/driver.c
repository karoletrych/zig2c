#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[4] = { 1, 2, 3, 1 };
        CHECK(findPeakElement(a, 4) == 2);
    }
    {
        int a[7] = { 1, 2, 1, 3, 5, 6, 4 };
        CHECK(findPeakElement(a, 7) == 5);
    }
    {
        int a[1] = { 1 };
        CHECK(findPeakElement(a, 1) == 0);
    }
    {
        int a[3] = { 3, 2, 1 };
        CHECK(findPeakElement(a, 3) == 0);
    }
    {
        int a[3] = { 1, 2, 3 };
        CHECK(findPeakElement(a, 3) == 2);
    }
    {
        int a[2] = { 1, 2 };
        CHECK(findPeakElement(a, 2) == 1);
    }
    {
        int a[2] = { 2, 1 };
        CHECK(findPeakElement(a, 2) == 0);
    }
    printf("find_peak_element: OK\n");
    return 0;
}
