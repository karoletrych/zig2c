#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    Pair p = { .a = 1, .b = 2 };
    CHECK(sumPair(p) == 3);
    CHECK(countDigits("a1b2c3") == 3);
    CHECK(stringsEqual("abc", "abc"));
    CHECK(!stringsEqual("abc", "abd"));
    int rs = 0;
    CHECK(sumSquaresBelow(5, &rs) == 5);
    CHECK(rs == 5);
    printf("smoke_std: OK\n");
    return 0;
}
