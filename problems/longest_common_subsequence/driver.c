#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(longestCommonSubsequence("abcde", "ace") == 3);
    CHECK(longestCommonSubsequence("abc", "abc") == 3);
    CHECK(longestCommonSubsequence("abc", "def") == 0);
    CHECK(longestCommonSubsequence("", "") == 0);
    CHECK(longestCommonSubsequence("", "abc") == 0);
    CHECK(longestCommonSubsequence("abc", "") == 0);
    CHECK(longestCommonSubsequence("a", "a") == 1);
    CHECK(longestCommonSubsequence("aaaaaaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaaaaaaa") == 20);
    CHECK(longestCommonSubsequence("abcdefg", "bdfg") == 4);
    printf("longest_common_subsequence: OK\n");
    return 0;
}
