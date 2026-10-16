#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(strcmp(minWindow("ADOBECODEBANC", "ABC"), "BANC") == 0);
    CHECK(strcmp(minWindow("a", "a"), "a") == 0);
    CHECK(strcmp(minWindow("a", "aa"), "") == 0);
    CHECK(strcmp(minWindow("", "a"), "") == 0);
    CHECK(strcmp(minWindow("abc", ""), "") == 0);
    CHECK(strcmp(minWindow("aaab", "aa"), "aa") == 0);
    CHECK(strcmp(minWindow("abbcabb", "b"), "b") == 0);
    CHECK(strcmp(minWindow("ab", "ab"), "ab") == 0);
    CHECK(strcmp(minWindow("bba", "ab"), "ba") == 0);
    CHECK(strcmp(minWindow("abc", "xyz"), "") == 0);
    printf("minimum_window_substring: OK\n");
    return 0;
}
