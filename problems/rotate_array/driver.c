#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[7] = { 1, 2, 3, 4, 5, 6, 7 };
        rotate(a, 7, 3);
        CHECK(a[0] == 5 && a[1] == 6 && a[2] == 7 && a[3] == 1 && a[4] == 2 && a[5] == 3 && a[6] == 4);
    }
    {
        int b[4] = { -1, -100, 3, 99 };
        rotate(b, 4, 2);
        CHECK(b[0] == 3 && b[1] == 99 && b[2] == -1 && b[3] == -100);
    }
    {
        int a[3] = { 1, 2, 3 };
        rotate(a, 3, 4);
        CHECK(a[0] == 3 && a[1] == 1 && a[2] == 2);
    }
    {
        int one[1] = { 7 };
        rotate(one, 1, 5);
        CHECK(one[0] == 7);
    }
    {
        int same[3] = { 1, 2, 3 };
        rotate(same, 3, 3);
        CHECK(same[0] == 1 && same[1] == 2 && same[2] == 3);
    }
    printf("rotate_array: OK\n");
    return 0;
}
