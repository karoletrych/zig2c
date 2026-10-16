#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(trailingZeroes(3) == 0);
    CHECK(trailingZeroes(5) == 1);
    CHECK(trailingZeroes(0) == 0);
    CHECK(trailingZeroes(10) == 2);
    CHECK(trailingZeroes(25) == 6);
    CHECK(trailingZeroes(30) == 7);
    CHECK(trailingZeroes(100) == 24);
    CHECK(trailingZeroes(1000) == 249);
    CHECK(trailingZeroes(10000) == 2499);
    printf("factorial_trailing_zeroes: OK\n");
    return 0;
}
