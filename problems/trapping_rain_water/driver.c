#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[12] = { 0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1 };
        CHECK(trap(a, 12) == 6);
    }
    {
        int b[6] = { 4, 2, 0, 3, 2, 5 };
        CHECK(trap(b, 6) == 9);
    }
    {
        int empty[1] = { 0 };
        CHECK(trap(empty, 0) == 0);
    }
    {
        int one[1] = { 5 };
        CHECK(trap(one, 1) == 0);
    }
    {
        int two[2] = { 3, 4 };
        CHECK(trap(two, 2) == 0);
    }
    {
        int flat[3] = { 2, 2, 2 };
        CHECK(trap(flat, 3) == 0);
    }
    {
        int bowl[3] = { 5, 0, 5 };
        CHECK(trap(bowl, 3) == 5);
    }
    printf("trapping_rain_water: OK\n");
    return 0;
}
