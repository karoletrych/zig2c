#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(isAnagram("anagram", "nagaram"));
    CHECK(!isAnagram("rat", "car"));
    CHECK(isAnagram("", ""));
    CHECK(!isAnagram("a", ""));
    CHECK(!isAnagram("aacc", "ccac"));
    CHECK(isAnagram("listen", "silent"));
    printf("valid_anagram: OK\n");
    return 0;
}
