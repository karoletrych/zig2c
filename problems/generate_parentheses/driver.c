#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int rs = 0;
        char **r = generateParenthesis(1, &rs);
        CHECK(rs == 1);
        CHECK(strcmp(r[0], "()") == 0);
    }
    {
        int rs = 0;
        char **r = generateParenthesis(2, &rs);
        CHECK(rs == 2);
        CHECK(strcmp(r[0], "(())") == 0);
        CHECK(strcmp(r[1], "()()") == 0);
    }
    {
        int rs = 0;
        char **r = generateParenthesis(3, &rs);
        CHECK(rs == 5);
        CHECK(strcmp(r[0], "((()))") == 0);
        CHECK(strcmp(r[1], "(()())") == 0);
        CHECK(strcmp(r[2], "(())()") == 0);
        CHECK(strcmp(r[3], "()(())") == 0);
        CHECK(strcmp(r[4], "()()()") == 0);
    }
    {
        int rs = 0;
        char **r = generateParenthesis(4, &rs);
        CHECK(rs == 14);
        CHECK(strlen(r[0]) == 8);
        CHECK(strcmp(r[0], "(((())))") == 0);
    }
    {
        int rs = 0;
        char **r = generateParenthesis(8, &rs);
        CHECK(rs == 1430);
        CHECK(strlen(r[0]) == 16);
        CHECK(strcmp(r[0], "(((((((())))))))") == 0);
        CHECK(strcmp(r[rs - 1], "()()()()()()()()") == 0);
    }
    printf("generate_parentheses: OK\n");
    return 0;
}
