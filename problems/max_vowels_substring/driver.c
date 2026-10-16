#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    char s1[] = "abciiidef";
    char s2[] = "aeiou";
    char s3[] = "leetcode";
    char s4[] = "a";
    char s5[] = "bcdfg";

    CHECK(maxVowels(s1, 3) == 3);
    CHECK(maxVowels(s2, 2) == 2);
    CHECK(maxVowels(s3, 3) == 2);
    CHECK(maxVowels(s4, 1) == 1);
    CHECK(maxVowels(s5, 3) == 0);

    printf("max_vowels_substring: OK\n");
    return 0;
}
