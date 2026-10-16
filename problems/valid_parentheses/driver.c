#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(isValid("()[]{}"));
    CHECK(isValid("{[]}"));
    CHECK(!isValid("(]"));
    CHECK(!isValid("([)]"));
    CHECK(!isValid("("));
    CHECK(isValid(""));
    printf("valid_parentheses: OK\n");
    return 0;
}
