#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int r0[6] = { -1, -1, -1, -1, -1, -1 };
        int r1[6] = { -1, -1, -1, -1, -1, -1 };
        int r2[6] = { -1, -1, -1, -1, -1, -1 };
        int r3[6] = { -1, 35, -1, -1, 13, -1 };
        int r4[6] = { -1, -1, -1, -1, -1, -1 };
        int r5[6] = { -1, 15, -1, -1, -1, -1 };
        int *b[6] = { r0, r1, r2, r3, r4, r5 };
        int cols[6] = { 6, 6, 6, 6, 6, 6 };
        CHECK(snakesAndLadders(b, 6, cols) == 4);
    }
    {
        int r0[2] = { -1, -1 };
        int r1[2] = { -1, 3 };
        int *b[2] = { r0, r1 };
        int cols[2] = { 2, 2 };
        CHECK(snakesAndLadders(b, 2, cols) == 1);
    }
    {
        int r0[3] = { 1, 1, -1 };
        int r1[3] = { 1, 1, 1 };
        int r2[3] = { -1, 1, 1 };
        int *b[3] = { r0, r1, r2 };
        int cols[3] = { 3, 3, 3 };
        CHECK(snakesAndLadders(b, 3, cols) == -1);
    }
    {
        int r0[2] = { -1, -1 };
        int r1[2] = { -1, -1 };
        int *b[2] = { r0, r1 };
        int cols[2] = { 2, 2 };
        CHECK(snakesAndLadders(b, 2, cols) == 1);
    }
    {
        int r0[3] = { -1, -1, -1 };
        int r1[3] = { -1, -1, -1 };
        int r2[3] = { -1, -1, -1 };
        int *b[3] = { r0, r1, r2 };
        int cols[3] = { 3, 3, 3 };
        CHECK(snakesAndLadders(b, 3, cols) == 2);
    }
    {
        int r0[2] = { -1, -1 };
        int r1[2] = { -1, 4 };
        int *b[2] = { r0, r1 };
        int cols[2] = { 2, 2 };
        CHECK(snakesAndLadders(b, 2, cols) == 1);
    }
    printf("snakes_and_ladders: OK\n");
    return 0;
}
