#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(strcmp(gcdOfStrings("ABCABC", "ABC"), "ABC") == 0);
    CHECK(strcmp(gcdOfStrings("ABABAB", "ABAB"), "AB") == 0);
    CHECK(strcmp(gcdOfStrings("LEET", "CODE"), "") == 0);
    CHECK(strcmp(gcdOfStrings("AAAA", "AA"), "AA") == 0);
    CHECK(strcmp(gcdOfStrings("ABC", "ABC"), "ABC") == 0);
    CHECK(strcmp(gcdOfStrings("", ""), "") == 0);
    CHECK(strcmp(gcdOfStrings("A", "AA"), "A") == 0);
    printf("gcd_of_strings: OK\n");
    return 0;
}
