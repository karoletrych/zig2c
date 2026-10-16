#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(rangeBitwiseAnd(5, 7) == 4);
    CHECK(rangeBitwiseAnd(0, 0) == 0);
    CHECK(rangeBitwiseAnd(1, 2147483647) == 0);
    CHECK(rangeBitwiseAnd(5, 5) == 5);
    CHECK(rangeBitwiseAnd(6, 7) == 6);
    CHECK(rangeBitwiseAnd(0, 1) == 0);
    CHECK(rangeBitwiseAnd(8, 15) == 8);
    CHECK(rangeBitwiseAnd(2147483646, 2147483647) == 2147483646);
    CHECK(rangeBitwiseAnd(0, 2147483647) == 0);
    CHECK(rangeBitwiseAnd(12, 13) == 12);
    printf("range_bitwise_and: OK\n");
    return 0;
}
