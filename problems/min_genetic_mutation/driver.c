#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        char *b[1] = { "AACCGGTA" };
        CHECK(minMutation("AACCGGTT", "AACCGGTA", b, 1) == 1);
    }
    {
        char *b[3] = { "AACCGGTA", "AACCGCTA", "AAACGGTA" };
        CHECK(minMutation("AACCGGTT", "AAACGGTA", b, 3) == 2);
    }
    {
        char *b[3] = { "AAAACCCC", "AAACCCCC", "AACCCCCC" };
        CHECK(minMutation("AAAAACCC", "AACCCCCC", b, 3) == 3);
    }
    {
        char *b[1] = { "AACCGGTA" };
        CHECK(minMutation("AACCGGTT", "AACCGGTC", b, 1) == -1);
    }
    {
        char *b[1] = { NULL };
        CHECK(minMutation("AACCGGTT", "AACCGGTA", b, 0) == -1);
        CHECK(minMutation("AACCGGTT", "AACCGGTT", b, 0) == 0);
    }
    {
        char *b[1] = { "CCCCCCCC" };
        CHECK(minMutation("AAAAAAAA", "CCCCCCCC", b, 1) == -1);
    }
    {
        char *b[4] = { "AACCGGTA", "AACCGGTC", "AACCGGCC", "AACCGCCC" };
        CHECK(minMutation("AACCGGTT", "AACCGCCC", b, 4) == 3);
    }
    printf("min_genetic_mutation: OK\n");
    return 0;
}
