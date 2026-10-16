#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(!canConstruct("a", "b"));
    CHECK(!canConstruct("aa", "ab"));
    CHECK(canConstruct("aa", "aab"));
    CHECK(canConstruct("", "anything"));
    CHECK(!canConstruct("x", ""));
    CHECK(canConstruct("abc", "cbad"));
    CHECK(!canConstruct("aaa", "aa"));
    printf("ransom_note: OK\n");
    return 0;
}
