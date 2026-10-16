#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int rs = 0;
        char **r = letterCombinations("23", &rs);
        CHECK(rs == 9);
        CHECK(strcmp(r[0], "ad") == 0);
        CHECK(strcmp(r[1], "ae") == 0);
        CHECK(strcmp(r[2], "af") == 0);
        CHECK(strcmp(r[3], "bd") == 0);
        CHECK(strcmp(r[4], "be") == 0);
        CHECK(strcmp(r[5], "bf") == 0);
        CHECK(strcmp(r[6], "cd") == 0);
        CHECK(strcmp(r[7], "ce") == 0);
        CHECK(strcmp(r[8], "cf") == 0);
    }
    {
        int rs = 0;
        char **r = letterCombinations("9", &rs);
        CHECK(rs == 4);
        CHECK(strcmp(r[0], "w") == 0);
        CHECK(strcmp(r[1], "x") == 0);
        CHECK(strcmp(r[2], "y") == 0);
        CHECK(strcmp(r[3], "z") == 0);
    }
    {
        int rs = 0;
        char **r = letterCombinations("7", &rs);
        CHECK(rs == 4);
        CHECK(strcmp(r[0], "p") == 0);
        CHECK(strcmp(r[1], "q") == 0);
        CHECK(strcmp(r[2], "r") == 0);
        CHECK(strcmp(r[3], "s") == 0);
    }
    {
        int rs = 1;
        char **r = letterCombinations("", &rs);
        CHECK(rs == 0);
        CHECK(r == NULL);
    }
    {
        int rs = 0;
        char **r = letterCombinations("2345", &rs);
        CHECK(rs == 81);
        CHECK(strcmp(r[0], "adgj") == 0);
        CHECK(strcmp(r[80], "cfil") == 0);
    }
    printf("letter_combinations: OK\n");
    return 0;
}
