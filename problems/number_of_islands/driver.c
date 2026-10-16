#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        char r0[] = "11110";
        char r1[] = "11010";
        char r2[] = "11000";
        char r3[] = "00000";
        char *g[4] = { r0, r1, r2, r3 };
        int cols[4] = { 5, 5, 5, 5 };
        CHECK(numIslands(g, 4, cols) == 1);
    }
    {
        char r0[] = "11000";
        char r1[] = "11000";
        char r2[] = "00100";
        char r3[] = "00011";
        char *g[4] = { r0, r1, r2, r3 };
        int cols[4] = { 5, 5, 5, 5 };
        CHECK(numIslands(g, 4, cols) == 3);
    }
    {
        char r0[] = "00";
        char r1[] = "00";
        char *g[2] = { r0, r1 };
        int cols[2] = { 2, 2 };
        CHECK(numIslands(g, 2, cols) == 0);
    }
    {
        char r0[] = "1";
        char *g[1] = { r0 };
        int cols[1] = { 1 };
        CHECK(numIslands(g, 1, cols) == 1);
    }
    {
        char r0[] = "10";
        char r1[] = "01";
        char *g[2] = { r0, r1 };
        int cols[2] = { 2, 2 };
        CHECK(numIslands(g, 2, cols) == 2);
    }
    {
        char r0[] = "100";
        char r1[] = "100";
        char r2[] = "111";
        char *g[3] = { r0, r1, r2 };
        int cols[3] = { 3, 3, 3 };
        CHECK(numIslands(g, 3, cols) == 1);
    }
    printf("number_of_islands: OK\n");
    return 0;
}
