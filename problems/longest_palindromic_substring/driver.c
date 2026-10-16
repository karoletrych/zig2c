#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(strcmp(longestPalindrome("babad"), "bab") == 0);
    CHECK(strcmp(longestPalindrome("cbbd"), "bb") == 0);
    CHECK(strcmp(longestPalindrome("a"), "a") == 0);
    CHECK(strcmp(longestPalindrome(""), "") == 0);
    CHECK(strcmp(longestPalindrome("ac"), "a") == 0);
    CHECK(strcmp(longestPalindrome("ab"), "a") == 0);
    CHECK(strcmp(longestPalindrome("abacdfgdcaba"), "aba") == 0);
    CHECK(strcmp(longestPalindrome("abccabccba"), "abccba") == 0);
    CHECK(strcmp(longestPalindrome("aaaa"), "aaaa") == 0);
    printf("longest_palindromic_substring: OK\n");
    return 0;
}
