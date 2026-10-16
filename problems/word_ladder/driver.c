#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        char *wl[6] = { "hot", "dot", "dog", "lot", "log", "cog" };
        CHECK(ladderLength("hit", "cog", wl, 6) == 5);
    }
    {
        char *wl[5] = { "hot", "dot", "dog", "lot", "log" };
        CHECK(ladderLength("hit", "cog", wl, 5) == 0);
    }
    {
        char *wl[2] = { "cog", "toolong" };
        CHECK(ladderLength("dog", "cog", wl, 2) == 2);
    }
    {
        char *wl[2] = { "abe", "ade" };
        CHECK(ladderLength("abc", "ade", wl, 2) == 3);
    }
    {
        char *wl[2] = { "xyz", "cog" };
        CHECK(ladderLength("hit", "cog", wl, 2) == 0);
    }
    {
        char *wl[4] = { "hot", "hot", "dot", "dog" };
        CHECK(ladderLength("hit", "dog", wl, 4) == 4);
    }
    printf("word_ladder: OK\n");
    return 0;
}
