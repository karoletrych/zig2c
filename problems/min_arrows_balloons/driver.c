#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        /* [[10,16],[2,8],[1,6],[7,12]] -> 2 */
        int r0[2] = { 10, 16 };
        int r1[2] = { 2, 8 };
        int r2[2] = { 1, 6 };
        int r3[2] = { 7, 12 };
        int *p[4] = { r0, r1, r2, r3 };
        int cols[4] = { 2, 2, 2, 2 };
        CHECK(findMinArrowShots(p, 4, cols) == 2);
    }
    {
        /* [[1,2],[3,4],[5,6],[7,8]] -> 4 */
        int r0[2] = { 1, 2 };
        int r1[2] = { 3, 4 };
        int r2[2] = { 5, 6 };
        int r3[2] = { 7, 8 };
        int *p[4] = { r0, r1, r2, r3 };
        int cols[4] = { 2, 2, 2, 2 };
        CHECK(findMinArrowShots(p, 4, cols) == 4);
    }
    {
        /* [[1,2],[2,3],[3,4],[4,5]] -> 2 */
        int r0[2] = { 1, 2 };
        int r1[2] = { 2, 3 };
        int r2[2] = { 3, 4 };
        int r3[2] = { 4, 5 };
        int *p[4] = { r0, r1, r2, r3 };
        int cols[4] = { 2, 2, 2, 2 };
        CHECK(findMinArrowShots(p, 4, cols) == 2);
    }
    {
        /* [[1,2],[2,3]] -> 1 (one arrow at 2) */
        int r0[2] = { 1, 2 };
        int r1[2] = { 2, 3 };
        int *p[2] = { r0, r1 };
        int cols[2] = { 2, 2 };
        CHECK(findMinArrowShots(p, 2, cols) == 1);
    }
    {
        /* negative coordinates: [[-3,-1],[-5,-2],[1,4]] -> 2 */
        int r0[2] = { -3, -1 };
        int r1[2] = { -5, -2 };
        int r2[2] = { 1, 4 };
        int *p[3] = { r0, r1, r2 };
        int cols[3] = { 2, 2, 2 };
        CHECK(findMinArrowShots(p, 3, cols) == 2);
    }
    {
        /* extreme int32 coordinates: [[INT_MIN, INT_MAX]] -> 1 */
        int r0[2] = { -2147483647 - 1, 2147483647 };
        int *p[1] = { r0 };
        int cols[1] = { 2 };
        CHECK(findMinArrowShots(p, 1, cols) == 1);
    }
    {
        /* two full-range balloons -> 1 */
        int r0[2] = { -2147483647 - 1, 2147483647 };
        int r1[2] = { -2147483647 - 1, 2147483647 };
        int *p[2] = { r0, r1 };
        int cols[2] = { 2, 2 };
        CHECK(findMinArrowShots(p, 2, cols) == 1);
    }
    {
        /* empty input -> 0 */
        int cols[1] = { 2 };
        CHECK(findMinArrowShots(NULL, 0, cols) == 0);
    }
    printf("min_arrows_balloons: OK\n");
    return 0;
}
