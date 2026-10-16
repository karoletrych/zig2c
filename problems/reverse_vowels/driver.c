#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(strcmp(reverseVowels("IceCreAm"), "AceCreIm") == 0);
    CHECK(strcmp(reverseVowels("leetcode"), "leotcede") == 0);
    CHECK(strcmp(reverseVowels("aA"), "Aa") == 0);
    CHECK(strcmp(reverseVowels("bcdfg"), "bcdfg") == 0);
    CHECK(strcmp(reverseVowels(""), "") == 0);
    CHECK(strcmp(reverseVowels("Ea"), "aE") == 0);
    printf("reverse_vowels: OK\n");
    return 0;
}
