#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        /* n=6, [[0,1],[1,3],[2,3],[4,0],[4,5]] -> 3 */
        int c0[2] = { 0, 1 };
        int c1[2] = { 1, 3 };
        int c2[2] = { 2, 3 };
        int c3[2] = { 4, 0 };
        int c4[2] = { 4, 5 };
        int *conn[5] = { c0, c1, c2, c3, c4 };
        int cols[5] = { 2, 2, 2, 2, 2 };
        CHECK(minReorder(6, conn, 5, cols) == 3);
    }
    {
        /* n=5, [[1,0],[1,2],[3,2],[3,4]] -> 2 */
        int c0[2] = { 1, 0 };
        int c1[2] = { 1, 2 };
        int c2[2] = { 3, 2 };
        int c3[2] = { 3, 4 };
        int *conn[4] = { c0, c1, c2, c3 };
        int cols[4] = { 2, 2, 2, 2 };
        CHECK(minReorder(5, conn, 4, cols) == 2);
    }
    {
        /* n=3, [[1,0],[2,0]] -> 0 (already all point to 0) */
        int c0[2] = { 1, 0 };
        int c1[2] = { 2, 0 };
        int *conn[2] = { c0, c1 };
        int cols[2] = { 2, 2 };
        CHECK(minReorder(3, conn, 2, cols) == 0);
    }
    {
        /* n=3, [[0,1],[0,2]] -> 2 (both point away) */
        int c0[2] = { 0, 1 };
        int c1[2] = { 0, 2 };
        int *conn[2] = { c0, c1 };
        int cols[2] = { 2, 2 };
        CHECK(minReorder(3, conn, 2, cols) == 2);
    }
    {
        /* n=1, no connections -> 0 */
        int cols[1] = { 2 };
        CHECK(minReorder(1, NULL, 0, cols) == 0);
    }
    printf("reorder_routes: OK\n");
    return 0;
}
