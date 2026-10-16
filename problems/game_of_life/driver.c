#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        /* [[0,1,0],[0,0,1],[1,1,1],[0,0,0]] -> [[0,0,0],[1,0,1],[0,1,1],[0,1,0]] */
        int r0[3] = { 0, 1, 0 };
        int r1[3] = { 0, 0, 1 };
        int r2[3] = { 1, 1, 1 };
        int r3[3] = { 0, 0, 0 };
        int *b[4] = { r0, r1, r2, r3 };
        int cols[1] = { 3 };
        int want[4][3] = { {0,0,0}, {1,0,1}, {0,1,1}, {0,1,0} };
        gameOfLife(b, 4, cols);
        for (int i = 0; i < 4; i++)
            for (int j = 0; j < 3; j++) CHECK(b[i][j] == want[i][j]);
    }
    {
        /* blinker -> vertical */
        int a0[5] = { 0, 0, 0, 0, 0 };
        int a1[5] = { 0, 0, 0, 0, 0 };
        int a2[5] = { 0, 1, 1, 1, 0 };
        int a3[5] = { 0, 0, 0, 0, 0 };
        int a4[5] = { 0, 0, 0, 0, 0 };
        int *b[5] = { a0, a1, a2, a3, a4 };
        int cols[1] = { 5 };
        int want[5][5] = {
            {0,0,0,0,0}, {0,0,1,0,0}, {0,0,1,0,0}, {0,0,1,0,0}, {0,0,0,0,0}
        };
        gameOfLife(b, 5, cols);
        for (int i = 0; i < 5; i++)
            for (int j = 0; j < 5; j++) CHECK(b[i][j] == want[i][j]);
    }
    {
        /* a lone live cell dies */
        int c0[1] = { 1 };
        int *c[1] = { c0 };
        int cols[1] = { 1 };
        gameOfLife(c, 1, cols);
        CHECK(c0[0] == 0);
    }
    printf("game_of_life: OK\n");
    return 0;
}
