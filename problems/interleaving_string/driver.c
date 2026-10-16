#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(isInterleave("aabcc", "dbbca", "aadbbcbcac"));
    CHECK(!isInterleave("aabcc", "dbbca", "aadbbbaccc"));
    CHECK(isInterleave("", "", ""));
    CHECK(isInterleave("abc", "", "abc"));
    CHECK(!isInterleave("abc", "", "abd"));
    CHECK(isInterleave("", "xyz", "xyz"));
    CHECK(!isInterleave("a", "b", "abc"));
    CHECK(!isInterleave("ab", "bc", "babcx"));
    CHECK(isInterleave("a", "b", "ab"));
    CHECK(isInterleave("a", "b", "ba"));
    CHECK(!isInterleave("a", "b", "aa"));
    CHECK(isInterleave("ab", "bc", "babc"));
    CHECK(!isInterleave("ab", "cd", "badc"));
    printf("interleaving_string: OK\n");
    return 0;
}
