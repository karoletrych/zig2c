#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        char r0[] = "ABCE";
        char r1[] = "SFCS";
        char r2[] = "ADEE";
        char *b[3] = { r0, r1, r2 };
        int cols[3] = { 4, 4, 4 };
        CHECK(exist(b, 3, cols, "ABCCED"));
        CHECK(exist(b, 3, cols, "SEE"));
        CHECK(!exist(b, 3, cols, "ABCB"));
    }
    {
        char r0[] = "a";
        char *b[1] = { r0 };
        int cols[1] = { 1 };
        CHECK(exist(b, 1, cols, "a"));
        CHECK(!exist(b, 1, cols, "b"));
        CHECK(!exist(b, 1, cols, "aa"));
    }
    {
        char r0[] = "ab";
        char r1[] = "cd";
        char *b[2] = { r0, r1 };
        int cols[2] = { 2, 2 };
        CHECK(exist(b, 2, cols, "ab"));
        CHECK(exist(b, 2, cols, "abd"));
        CHECK(exist(b, 2, cols, "abdc"));
        CHECK(!exist(b, 2, cols, "aba"));
    }
    {
        char r0[] = "aa";
        char *b[1] = { r0 };
        int cols[1] = { 2 };
        CHECK(!exist(b, 1, cols, "aaa"));
        CHECK(exist(b, 1, cols, "aa"));
        CHECK(!exist(b, 1, cols, "aaaa"));
    }
    printf("word_search: OK\n");
    return 0;
}
