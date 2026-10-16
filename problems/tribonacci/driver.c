#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(tribonacci(4) == 4);
    CHECK(tribonacci(25) == 1389537);
    CHECK(tribonacci(0) == 0);
    CHECK(tribonacci(1) == 1);
    CHECK(tribonacci(2) == 1);
    CHECK(tribonacci(3) == 2);
    CHECK(tribonacci(5) == 7);
    CHECK(tribonacci(10) == 149);
    CHECK(tribonacci(37) == 2082876103);
    printf("tribonacci: OK\n");
    return 0;
}
