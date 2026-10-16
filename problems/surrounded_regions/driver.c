#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static void expectBoard(char **b, int rows, int cols, const char *want) {
    for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
            if (b[r][c] != want[r * cols + c]) {
                printf("FAIL: board[%d][%d] = '%c', want '%c'\n", r, c, b[r][c], want[r * cols + c]);
                exit(1);
            }
        }
    }
}

int main(void) {
    {
        char r0[] = "XXXX";
        char r1[] = "XOOX";
        char r2[] = "XXOX";
        char r3[] = "XOXX";
        char *b[4] = { r0, r1, r2, r3 };
        int cols[4] = { 4, 4, 4, 4 };
        solve(b, 4, cols);
        expectBoard(b, 4, 4, "XXXXXXXXXXXXXOXX");
    }
    {
        char r0[] = "O";
        char *b[1] = { r0 };
        int cols[1] = { 1 };
        solve(b, 1, cols);
        expectBoard(b, 1, 1, "O");
    }
    {
        char r0[] = "OOO";
        char r1[] = "OXO";
        char r2[] = "OOO";
        char *b[3] = { r0, r1, r2 };
        int cols[3] = { 3, 3, 3 };
        solve(b, 3, cols);
        expectBoard(b, 3, 3, "OOOOXOOOO");
    }
    {
        char r0[] = "XXXXX";
        char r1[] = "XOOOX";
        char r2[] = "XOOOX";
        char r3[] = "XOOOX";
        char r4[] = "XXXXX";
        char *b[5] = { r0, r1, r2, r3, r4 };
        int cols[5] = { 5, 5, 5, 5, 5 };
        solve(b, 5, cols);
        expectBoard(b, 5, 5, "XXXXXXXXXXXXXXXXXXXXXXXXX");
    }
    printf("surrounded_regions: OK\n");
    return 0;
}
