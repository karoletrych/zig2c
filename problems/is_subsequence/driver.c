#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(isSubsequence("abc", "ahbgdc") == true);
    CHECK(isSubsequence("axc", "ahbgdc") == false);
    CHECK(isSubsequence("", "") == true);
    CHECK(isSubsequence("", "abc") == true);
    CHECK(isSubsequence("abc", "") == false);
    CHECK(isSubsequence("ace", "abcde") == true);
    CHECK(isSubsequence("aec", "abcde") == false);
    CHECK(isSubsequence("b", "abc") == true);
    printf("is_subsequence: OK\n");
    return 0;
}
