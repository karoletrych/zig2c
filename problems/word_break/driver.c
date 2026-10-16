#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        char *d[] = { "leet", "code" };
        CHECK(wordBreak("leetcode", d, 2));
    }
    {
        char *d[] = { "apple", "pen" };
        CHECK(wordBreak("applepenapple", d, 2));
    }
    {
        char *d[] = { "cats", "dog", "sand", "and", "cat" };
        CHECK(!wordBreak("catsandog", d, 5));
    }
    {
        char *d[] = { "a" };
        CHECK(wordBreak("a", d, 1));
    }
    {
        char *d[] = { "b" };
        CHECK(!wordBreak("a", d, 1));
    }
    {
        char *d[] = { "aaaa", "aaa" };
        CHECK(wordBreak("aaaaaaa", d, 2));
    }
    {
        char *d[] = { "ab", "cd" };
        CHECK(wordBreak("abcd", d, 2));
        CHECK(!wordBreak("abcde", d, 2));
    }
    {
        char *d[] = { "" };
        CHECK(wordBreak("", d, 1));
    }
    {
        char *d[] = { "x" };
        CHECK(!wordBreak("abc", d, 0));
    }
    printf("word_break: OK\n");
    return 0;
}
