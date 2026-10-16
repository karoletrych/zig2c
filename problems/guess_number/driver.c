#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

/* The judge provides `guess`; here we provide it from a settable target. */
static int g_target = 1;

int guess(int num) {
    if (num > g_target) return -1;
    if (num < g_target) return 1;
    return 0;
}

int main(void) {
    g_target = 6;
    CHECK(guessNumber(10) == 6);
    g_target = 1;
    CHECK(guessNumber(1) == 1);
    g_target = 2;
    CHECK(guessNumber(2) == 2);
    g_target = 1;
    CHECK(guessNumber(2) == 1);
    g_target = 2147483647;
    CHECK(guessNumber(2147483647) == 2147483647);
    g_target = 1702766719;
    CHECK(guessNumber(2126753390) == 1702766719);
    g_target = 999999;
    CHECK(guessNumber(1000000) == 999999);
    printf("guess_number: OK\n");
    return 0;
}
