#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        /* [["+","+",".","+"],[".",".",".","+"],["+","+","+","."]] entrance [1,2] -> 1 */
        char row0[4] = { '+', '+', '.', '+' };
        char row1[4] = { '.', '.', '.', '+' };
        char row2[4] = { '+', '+', '+', '.' };
        char *maze[3] = { row0, row1, row2 };
        int cols[1] = { 4 };
        int entrance[2] = { 1, 2 };
        CHECK(nearestExit(maze, 3, cols, entrance, 2) == 1);
    }
    {
        /* [["+","+","+"],[".",".","."],["+","+","+"]] entrance [1,0] -> 2 */
        char row0[3] = { '+', '+', '+' };
        char row1[3] = { '.', '.', '.' };
        char row2[3] = { '+', '+', '+' };
        char *maze[3] = { row0, row1, row2 };
        int cols[1] = { 3 };
        int entrance[2] = { 1, 0 };
        CHECK(nearestExit(maze, 3, cols, entrance, 2) == 2);
    }
    {
        /* [[".","+"]] entrance [0,0] -> -1 */
        char row0[2] = { '.', '+' };
        char *maze[1] = { row0 };
        int cols[1] = { 2 };
        int entrance[2] = { 0, 0 };
        CHECK(nearestExit(maze, 1, cols, entrance, 2) == -1);
    }
    {
        /* no reachable exit -> -1 */
        char row0[3] = { '+', '+', '+' };
        char row1[3] = { '.', '.', '+' };
        char row2[3] = { '+', '+', '+' };
        char *maze[3] = { row0, row1, row2 };
        int cols[1] = { 3 };
        int entrance[2] = { 1, 0 };
        CHECK(nearestExit(maze, 3, cols, entrance, 2) == -1);
    }
    {
        /* 1x1 open cell: entrance is the only cell -> -1 */
        char row0[1] = { '.' };
        char *maze[1] = { row0 };
        int cols[1] = { 1 };
        int entrance[2] = { 0, 0 };
        CHECK(nearestExit(maze, 1, cols, entrance, 2) == -1);
    }
    printf("nearest_exit: OK\n");
    return 0;
}
