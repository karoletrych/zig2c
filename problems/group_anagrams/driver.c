#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        char *strs[6] = { "eat", "tea", "tan", "ate", "nat", "bat" };
        int rs = 0;
        int *cols = NULL;
        char ***r = groupAnagrams(strs, 6, &rs, &cols);
        CHECK(rs == 3);
        CHECK(cols[0] == 3);
        CHECK(cols[1] == 2);
        CHECK(cols[2] == 1);
        CHECK(strcmp(r[0][0], "eat") == 0);
        CHECK(strcmp(r[0][1], "tea") == 0);
        CHECK(strcmp(r[0][2], "ate") == 0);
        CHECK(strcmp(r[1][0], "tan") == 0);
        CHECK(strcmp(r[1][1], "nat") == 0);
        CHECK(strcmp(r[2][0], "bat") == 0);
    }
    {
        char *one[1] = { "a" };
        int rs = 0;
        int *cols = NULL;
        char ***r = groupAnagrams(one, 1, &rs, &cols);
        CHECK(rs == 1);
        CHECK(cols[0] == 1);
        CHECK(strcmp(r[0][0], "a") == 0);
    }
    {
        int rs = 0;
        int *cols = NULL;
        char ***r = groupAnagrams(NULL, 0, &rs, &cols);
        CHECK(rs == 0);
        (void)r;
    }
    {
        char *dup[4] = { "", "", "ab", "ba" };
        int rs = 0;
        int *cols = NULL;
        char ***r = groupAnagrams(dup, 4, &rs, &cols);
        CHECK(rs == 2);
        CHECK(cols[0] == 2);
        CHECK(cols[1] == 2);
        CHECK(strcmp(r[0][0], "") == 0);
        CHECK(strcmp(r[1][0], "ab") == 0);
        CHECK(strcmp(r[1][1], "ba") == 0);
    }
    printf("group_anagrams: OK\n");
    return 0;
}
