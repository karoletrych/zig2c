#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[5] = { 2, 3, 1, 1, 4 };
        CHECK(jump(a, 5) == 2);
    }
    {
        int b[5] = { 2, 3, 0, 1, 4 };
        CHECK(jump(b, 5) == 2);
    }
    {
        int empty[1] = { 0 };
        CHECK(jump(empty, 0) == 0);
    }
    {
        int one[1] = { 0 };
        CHECK(jump(one, 1) == 0);
    }
    {
        int two[2] = { 1, 1 };
        CHECK(jump(two, 2) == 1);
    }
    {
        int allOnes[4] = { 1, 1, 1, 1 };
        CHECK(jump(allOnes, 4) == 3);
    }
    {
        int big[10] = { 9, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        CHECK(jump(big, 10) == 1);
    }
    printf("jump_game_ii: OK\n");
    return 0;
}
