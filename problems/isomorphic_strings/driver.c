#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(isIsomorphic("egg", "add"));
    CHECK(!isIsomorphic("foo", "bar"));
    CHECK(isIsomorphic("paper", "title"));
    CHECK(!isIsomorphic("badc", "baba"));
    CHECK(isIsomorphic("", ""));
    CHECK(!isIsomorphic("a", "ab"));
    CHECK(isIsomorphic("abcdefghijklmnopqrstuvwxyz", "zyxwvutsrqponmlkjihgfedcba"));
    printf("isomorphic_strings: OK\n");
    return 0;
}
