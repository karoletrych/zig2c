#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a[5] = { 0, 1, 0, 3, 12 };
    moveZeroes(a, 5);
    CHECK(a[0] == 1 && a[1] == 3 && a[2] == 12 && a[3] == 0 && a[4] == 0);

    int b[1] = { 0 };
    moveZeroes(b, 1);
    CHECK(b[0] == 0);

    int c[3] = { 1, 2, 3 };
    moveZeroes(c, 3);
    CHECK(c[0] == 1 && c[1] == 2 && c[2] == 3);

    int d[6] = { 4, 0, 5, 0, 0, 6 };
    moveZeroes(d, 6);
    CHECK(d[0] == 4 && d[1] == 5 && d[2] == 6 && d[3] == 0 && d[4] == 0 && d[5] == 0);

    printf("move_zeroes: OK\n");
    return 0;
}
