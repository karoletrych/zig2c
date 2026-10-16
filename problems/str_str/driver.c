#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(strStr("sadbutsad", "sad") == 0);
    CHECK(strStr("leetcode", "leeto") == -1);
    CHECK(strStr("hello", "ll") == 2);
    CHECK(strStr("abc", "") == 0);
    CHECK(strStr("mississippi", "issip") == 4);
    CHECK(strStr("aaa", "aaaa") == -1);
    CHECK(strStr("a", "a") == 0);
    CHECK(strStr("", "a") == -1);
    printf("str_str: OK\n");
    return 0;
}
