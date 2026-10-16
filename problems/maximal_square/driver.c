#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        char *g[] = { "10100", "10111", "11111", "10010" };
        int cols[] = { 5, 5, 5, 5 };
        CHECK(maximalSquare(g, 4, cols) == 4);
    }
    {
        char *g[] = { "01", "10" };
        int cols[] = { 2, 2 };
        CHECK(maximalSquare(g, 2, cols) == 1);
    }
    {
        char *g[] = { "0" };
        int cols[] = { 1 };
        CHECK(maximalSquare(g, 1, cols) == 0);
    }
    {
        char *g[] = { "11", "11" };
        int cols[] = { 2, 2 };
        CHECK(maximalSquare(g, 2, cols) == 4);
    }
    {
        char *g[] = { "1" };
        int cols[] = { 1 };
        CHECK(maximalSquare(g, 1, cols) == 1);
    }
    {
        char *g[] = { "101" };
        int cols[] = { 3 };
        CHECK(maximalSquare(g, 1, cols) == 1);
    }
    {
        char *g[] = { "111", "111", "111" };
        int cols[] = { 3, 3, 3 };
        CHECK(maximalSquare(g, 3, cols) == 9);
    }
    {
        char *g[] = { "1111", "1111", "1111", "1111" };
        int cols[] = { 4, 4, 4, 4 };
        CHECK(maximalSquare(g, 4, cols) == 16);
    }
    printf("maximal_square: OK\n");
    return 0;
}
