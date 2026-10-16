#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(wordPattern("abba", "dog cat cat dog"));
    CHECK(!wordPattern("abba", "dog cat cat fish"));
    CHECK(!wordPattern("aaaa", "dog cat cat dog"));
    CHECK(!wordPattern("ab", "dog dog"));
    CHECK(wordPattern("a", "dog"));
    CHECK(!wordPattern("a", "dog cat"));
    CHECK(wordPattern("", ""));
    CHECK(!wordPattern("a", ""));
    CHECK(!wordPattern("abc", "b c a a"));
    printf("word_pattern: OK\n");
    return 0;
}
