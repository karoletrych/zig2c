#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int p[3] = { 1, 2, 3 };
        int c[3] = { 0, 1, 1 };
        CHECK(findMaximizedCapital(2, 0, p, 3, c, 3) == 4);
    }
    {
        int p[3] = { 1, 2, 3 };
        int c[3] = { 0, 1, 2 };
        CHECK(findMaximizedCapital(3, 0, p, 3, c, 3) == 6);
    }
    {
        int p[3] = { 1, 2, 3 };
        int c[3] = { 0, 0, 0 };
        CHECK(findMaximizedCapital(0, 5, p, 3, c, 3) == 5);
        CHECK(findMaximizedCapital(1, 0, p, 3, c, 3) == 3);
    }
    {
        int p[1] = { 5 };
        int c[1] = { 10 };
        CHECK(findMaximizedCapital(1, 0, p, 1, c, 1) == 0);
    }
    {
        int p[2] = { 1, 2 };
        int c[2] = { 0, 0 };
        CHECK(findMaximizedCapital(5, 0, p, 2, c, 2) == 3);
    }
    {
        int p[3] = { 1, 2, 3 };
        int c[3] = { 0, 1, 1 };
        CHECK(findMaximizedCapital(3, 1, p, 3, c, 3) == 7);
    }
    {
        int p[3] = { 1, 2, 3 };
        int c[3] = { 0, 1, 2 };
        CHECK(findMaximizedCapital(1, 0, p, 3, c, 3) == 1);
    }
    {
        int p[1] = { 4 };
        int c[1] = { 0 };
        CHECK(findMaximizedCapital(3, 0, p, 1, c, 1) == 4);
    }
    {
        int p[2] = { 0, 0 };
        int c[2] = { 0, 0 };
        CHECK(findMaximizedCapital(2, 5, p, 2, c, 2) == 5);
    }
    printf("ipo: OK\n");
    return 0;
}
