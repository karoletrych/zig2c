#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        /* [[1,2],[2,3],[3,4],[1,3]] -> 1 */
        int r0[2] = { 1, 2 };
        int r1[2] = { 2, 3 };
        int r2[2] = { 3, 4 };
        int r3[2] = { 1, 3 };
        int *iv[4] = { r0, r1, r2, r3 };
        int cols[4] = { 2, 2, 2, 2 };
        CHECK(eraseOverlapIntervals(iv, 4, cols) == 1);
    }
    {
        /* [[1,2],[1,2],[1,2]] -> 2 */
        int r0[2] = { 1, 2 };
        int r1[2] = { 1, 2 };
        int r2[2] = { 1, 2 };
        int *iv[3] = { r0, r1, r2 };
        int cols[3] = { 2, 2, 2 };
        CHECK(eraseOverlapIntervals(iv, 3, cols) == 2);
    }
    {
        /* [[1,2],[2,3]] -> 0 (touching endpoints do not overlap) */
        int r0[2] = { 1, 2 };
        int r1[2] = { 2, 3 };
        int *iv[2] = { r0, r1 };
        int cols[2] = { 2, 2 };
        CHECK(eraseOverlapIntervals(iv, 2, cols) == 0);
    }
    {
        /* [[1,100],[11,22],[1,11],[2,12]] -> 2 */
        int r0[2] = { 1, 100 };
        int r1[2] = { 11, 22 };
        int r2[2] = { 1, 11 };
        int r3[2] = { 2, 12 };
        int *iv[4] = { r0, r1, r2, r3 };
        int cols[4] = { 2, 2, 2, 2 };
        CHECK(eraseOverlapIntervals(iv, 4, cols) == 2);
    }
    {
        /* negative coordinates: [[-5,-3],[-4,-2],[-3,-1]] -> 1 */
        int r0[2] = { -5, -3 };
        int r1[2] = { -4, -2 };
        int r2[2] = { -3, -1 };
        int *iv[3] = { r0, r1, r2 };
        int cols[3] = { 2, 2, 2 };
        CHECK(eraseOverlapIntervals(iv, 3, cols) == 1);
    }
    {
        /* [[-2,0],[1,5]] -> 0 */
        int r0[2] = { -2, 0 };
        int r1[2] = { 1, 5 };
        int *iv[2] = { r0, r1 };
        int cols[2] = { 2, 2 };
        CHECK(eraseOverlapIntervals(iv, 2, cols) == 0);
    }
    {
        /* single interval -> 0 */
        int r0[2] = { 1, 2 };
        int *iv[1] = { r0 };
        int cols[1] = { 2 };
        CHECK(eraseOverlapIntervals(iv, 1, cols) == 0);
    }
    printf("non_overlapping_intervals: OK\n");
    return 0;
}
