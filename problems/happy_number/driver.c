#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(isHappy(19));
    CHECK(!isHappy(2));
    CHECK(isHappy(1));
    CHECK(isHappy(7));
    CHECK(!isHappy(4));
    CHECK(!isHappy(2147483647));
    printf("happy_number: OK\n");
    return 0;
}
