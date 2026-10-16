#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(climbStairs(2) == 2);
    CHECK(climbStairs(3) == 3);
    CHECK(climbStairs(1) == 1);
    CHECK(climbStairs(4) == 5);
    CHECK(climbStairs(5) == 8);
    CHECK(climbStairs(10) == 89);
    CHECK(climbStairs(45) == 1836311903);
    printf("climbing_stairs: OK\n");
    return 0;
}
