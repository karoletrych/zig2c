#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static int cols[9] = { 9, 9, 9, 9, 9, 9, 9, 9, 9 };

int main(void) {
    {
        char *board[] = {
            "53..7....", "6..195...", ".98....6.",
            "8...6...3", "4..8.3..1", "7...2...6",
            ".6....28.", "...419..5", "....8..79",
        };
        CHECK(isValidSudoku(board, 9, cols) == true);
    }
    {
        char *board[] = {
            "53..7....", "68.195...", ".98....6.",
            "8...6...3", "4..8.3..1", "7...2...6",
            ".6....28.", "...419..5", "....8..79",
        };
        CHECK(isValidSudoku(board, 9, cols) == false);
    }
    {
        char *board[] = {
            "8........", ".........", ".........",
            "8........", ".........", ".........",
            ".........", ".........", ".........",
        };
        CHECK(isValidSudoku(board, 9, cols) == false);
    }
    {
        char *board[] = {
            ".........", ".........", ".........",
            ".........", ".........", ".........",
            ".........", ".........", "2.......2",
        };
        CHECK(isValidSudoku(board, 9, cols) == false);
    }
    {
        char *board[] = {
            ".........", ".........", ".........",
            ".........", ".........", ".........",
            ".........", ".........", ".........",
        };
        CHECK(isValidSudoku(board, 9, cols) == true);
    }
    printf("valid_sudoku: OK\n");
    return 0;
}
