#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static int has(char **res, int count, const char *s) {
    for (int i = 0; i < count; i++) {
        if (strcmp(res[i], s) == 0) return 1;
    }
    return 0;
}

int main(void) {
    {
        char r0[] = "oaan";
        char r1[] = "etae";
        char r2[] = "ihkr";
        char r3[] = "iflv";
        char *b[4] = { r0, r1, r2, r3 };
        int cols[4] = { 4, 4, 4, 4 };
        char *words[4] = { "oath", "pea", "eat", "rain" };
        int rs = 0;
        char **res = findWords(b, 4, cols, words, 4, &rs);
        CHECK(rs == 2);
        CHECK(has(res, rs, "oath"));
        CHECK(has(res, rs, "eat"));
    }
    {
        char r0[] = "ab";
        char r1[] = "cd";
        char *b[2] = { r0, r1 };
        int cols[2] = { 2, 2 };
        char *words[1] = { "abcb" };
        int rs = 0;
        char **res = findWords(b, 2, cols, words, 1, &rs);
        CHECK(res != NULL && rs == 0);
    }
    {
        char r0[] = "aa";
        char *b[1] = { r0 };
        int cols[1] = { 2 };
        char *words[4] = { "a", "aa", "aa", "aaa" };
        int rs = 0;
        char **res = findWords(b, 1, cols, words, 4, &rs);
        CHECK(rs == 2);
        CHECK(has(res, rs, "a"));
        CHECK(has(res, rs, "aa"));
        CHECK(!has(res, rs, "aaa"));
    }
    {
        char r0[] = "ab";
        char *b[1] = { r0 };
        int cols[1] = { 2 };
        char *words[3] = { "ab", "ba", "aba" };
        int rs = 0;
        char **res = findWords(b, 1, cols, words, 3, &rs);
        CHECK(rs == 2);
        CHECK(has(res, rs, "ab"));
        CHECK(has(res, rs, "ba"));
        CHECK(!has(res, rs, "aba"));
    }
    printf("word_search_ii: OK\n");
    return 0;
}
