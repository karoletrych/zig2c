#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        char *t[5] = { "2", "1", "+", "3", "*" };
        CHECK(evalRPN(t, 5) == 9);
    }
    {
        char *t[5] = { "4", "13", "5", "/", "+" };
        CHECK(evalRPN(t, 5) == 6);
    }
    {
        char *t[13] = { "10", "6", "9", "3", "+", "-11", "*", "/", "*", "17", "+", "5", "+" };
        CHECK(evalRPN(t, 13) == 22);
    }
    {
        char *t[1] = { "42" };
        CHECK(evalRPN(t, 1) == 42);
    }
    {
        char *t[3] = { "-7", "2", "/" };
        CHECK(evalRPN(t, 3) == -3);
    }
    {
        char *t[3] = { "0", "3", "/" };
        CHECK(evalRPN(t, 3) == 0);
    }
    {
        char *t[3] = { "-128", "-2", "*" };
        CHECK(evalRPN(t, 3) == 256);
    }
    {
        char *t[7] = { "3", "4", "+", "2", "*", "7", "-" };
        CHECK(evalRPN(t, 7) == 7);
    }
    printf("eval_rpn: OK\n");
    return 0;
}
