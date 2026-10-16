#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    /* LeetCode examples */
    CHECK(calculate("1 + 1") == 2);
    CHECK(calculate(" 2-1 + 2 ") == 3);
    CHECK(calculate("(1+(4+5+2)-3)+(6+8)") == 23);

    /* edge cases */
    CHECK(calculate("") == 0);
    CHECK(calculate("0") == 0);
    CHECK(calculate("  30") == 30);
    CHECK(calculate("(1)") == 1);
    CHECK(calculate("1-11") == -10);
    CHECK(calculate("2-(5-6)") == 3);
    CHECK(calculate("-2+ 1") == -1);
    CHECK(calculate("1-(     -2)") == 3);
    CHECK(calculate("2147483647") == 2147483647);

    printf("basic_calculator: OK\n");
    return 0;
}
