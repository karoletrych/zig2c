#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[3] = { 1, 0, 2 };
        CHECK(candy(a, 3) == 5);
    }
    {
        int b[3] = { 1, 2, 2 };
        CHECK(candy(b, 3) == 4);
    }
    {
        int empty[1] = { 0 };
        CHECK(candy(empty, 0) == 0);
    }
    {
        int one[1] = { 9 };
        CHECK(candy(one, 1) == 1);
    }
    {
        int same[4] = { 5, 5, 5, 5 };
        CHECK(candy(same, 4) == 4);
    }
    {
        int up[5] = { 1, 2, 3, 4, 5 };
        CHECK(candy(up, 5) == 15);
    }
    {
        int down[5] = { 5, 4, 3, 2, 1 };
        CHECK(candy(down, 5) == 15);
    }
    {
        int valley[5] = { 3, 2, 1, 2, 3 };
        CHECK(candy(valley, 5) == 11);
    }
    printf("candy: OK\n");
    return 0;
}
