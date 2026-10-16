#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(mySqrt(4) == 2);
    CHECK(mySqrt(8) == 2);
    CHECK(mySqrt(0) == 0);
    CHECK(mySqrt(1) == 1);
    CHECK(mySqrt(2) == 1);
    CHECK(mySqrt(3) == 1);
    CHECK(mySqrt(9) == 3);
    CHECK(mySqrt(15) == 3);
    CHECK(mySqrt(16) == 4);
    CHECK(mySqrt(2147395599) == 46339);
    CHECK(mySqrt(2147483647) == 46340);
    printf("sqrt_x: OK\n");
    return 0;
}
