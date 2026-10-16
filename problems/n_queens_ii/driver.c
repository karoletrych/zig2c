#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(totalNQueens(1) == 1);
    CHECK(totalNQueens(2) == 0);
    CHECK(totalNQueens(3) == 0);
    CHECK(totalNQueens(4) == 2);
    CHECK(totalNQueens(5) == 10);
    CHECK(totalNQueens(6) == 4);
    CHECK(totalNQueens(7) == 40);
    CHECK(totalNQueens(8) == 92);
    CHECK(totalNQueens(9) == 352);
    printf("n_queens_ii: OK\n");
    return 0;
}
