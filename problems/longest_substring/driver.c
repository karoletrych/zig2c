#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(lengthOfLongestSubstring("abcabcbb") == 3);
    CHECK(lengthOfLongestSubstring("bbbbb") == 1);
    CHECK(lengthOfLongestSubstring("pwwkew") == 3);
    CHECK(lengthOfLongestSubstring("") == 0);
    printf("longest_substring: OK\n");
    return 0;
}
