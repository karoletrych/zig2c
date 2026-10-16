#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        char *w[] = { "foo", "bar" };
        int rs = 0;
        int *r = findSubstring("barfoothefoobarman", w, 2, &rs);
        CHECK(rs == 2);
        CHECK(r[0] == 0 && r[1] == 9);
    }
    {
        char *w[] = { "word", "good", "best", "word" };
        int rs = 0;
        int *r = findSubstring("wordgoodgoodgoodbestword", w, 4, &rs);
        CHECK(rs == 0);
        (void)r;
    }
    {
        char *w[] = { "bar", "foo", "the" };
        int rs = 0;
        int *r = findSubstring("barfoofoobarthefoobarman", w, 3, &rs);
        CHECK(rs == 3);
        CHECK(r[0] == 6 && r[1] == 9 && r[2] == 12);
    }
    {
        char *w[] = { "ab", "ab", "ba" };
        int rs = 0;
        int *r = findSubstring("abababba", w, 3, &rs);
        CHECK(rs == 1);
        CHECK(r[0] == 2);
    }
    {
        char *w[] = { "a" };
        int rs = 0;
        int *r = findSubstring("aaaa", w, 1, &rs);
        CHECK(rs == 4);
        CHECK(r[0] == 0 && r[1] == 1 && r[2] == 2 && r[3] == 3);
    }
    {
        char *w[] = { "xy", "zz" };
        int rs = 0;
        int *r = findSubstring("abcdef", w, 2, &rs);
        CHECK(rs == 0);
        (void)r;
    }
    printf("substring_concatenation: OK\n");
    return 0;
}
