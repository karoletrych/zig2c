#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[3] = { 2, 2, 1 };
        CHECK(singleNumber(a, 3) == 1);
    }
    {
        int a[5] = { 4, 1, 2, 1, 2 };
        CHECK(singleNumber(a, 5) == 4);
    }
    {
        int a[1] = { 1 };
        CHECK(singleNumber(a, 1) == 1);
    }
    {
        int a[5] = { -3, 5, 5, -3, -8 };
        CHECK(singleNumber(a, 5) == -8);
    }
    {
        int a[3] = { 100000, 100000, -100000 };
        CHECK(singleNumber(a, 3) == -100000);
    }
    printf("single_number: OK\n");
    return 0;
}
