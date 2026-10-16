#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    char *a[] = { "flower", "flow", "flight" };
    CHECK(strcmp(longestCommonPrefix(a, 3), "fl") == 0);
    char *b[] = { "dog", "racecar", "car" };
    CHECK(strcmp(longestCommonPrefix(b, 3), "") == 0);
    char *c[] = { "single" };
    CHECK(strcmp(longestCommonPrefix(c, 1), "single") == 0);
    char *d[] = { "ab", "a" };
    CHECK(strcmp(longestCommonPrefix(d, 2), "a") == 0);
    char *e[] = { "", "b" };
    CHECK(strcmp(longestCommonPrefix(e, 2), "") == 0);
    char *f[] = { "cir", "car" };
    CHECK(strcmp(longestCommonPrefix(f, 2), "c") == 0);
    char *g[] = { "abc", "abc", "abc" };
    CHECK(strcmp(longestCommonPrefix(g, 3), "abc") == 0);
    printf("longest_common_prefix: OK\n");
    return 0;
}
