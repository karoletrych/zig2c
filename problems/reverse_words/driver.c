#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(strcmp(reverseWords("the sky is blue"), "blue is sky the") == 0);
    CHECK(strcmp(reverseWords("  hello world  "), "world hello") == 0);
    CHECK(strcmp(reverseWords("a good   example"), "example good a") == 0);
    CHECK(strcmp(reverseWords("a"), "a") == 0);
    CHECK(strcmp(reverseWords("   "), "") == 0);
    CHECK(strcmp(reverseWords(""), "") == 0);
    CHECK(strcmp(reverseWords("one"), "one") == 0);
    printf("reverse_words: OK\n");
    return 0;
}
