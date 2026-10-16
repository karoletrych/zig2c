#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[5] = { 2, 3, 1, 1, 4 };
        CHECK(canJump(a, 5));
    }
    {
        int b[5] = { 3, 2, 1, 0, 4 };
        CHECK(!canJump(b, 5));
    }
    {
        int empty[1] = { 0 };
        CHECK(canJump(empty, 0));
    }
    {
        int one[1] = { 0 };
        CHECK(canJump(one, 1));
    }
    {
        int zero[2] = { 0, 1 };
        CHECK(!canJump(zero, 2));
    }
    {
        int zeroAll[3] = { 0, 0, 0 };
        CHECK(!canJump(zeroAll, 3));
    }
    {
        int big[6] = { 5, 0, 0, 0, 0, 0 };
        CHECK(canJump(big, 6));
    }
    printf("jump_game: OK\n");
    return 0;
}
