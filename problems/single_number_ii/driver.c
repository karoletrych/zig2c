#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a[] = { 2, 2, 3, 2 };
    CHECK(singleNumber(a, 4) == 3);

    int b[] = { 0, 1, 0, 1, 0, 1, 99 };
    CHECK(singleNumber(b, 7) == 99);

    int c[] = { 1 };
    CHECK(singleNumber(c, 1) == 1);

    int d[] = { -2, -2, -2, 5 };
    CHECK(singleNumber(d, 4) == 5);

    int e[] = { -1, -1, -1, -3 };
    CHECK(singleNumber(e, 4) == -3);

    int f[] = { 1000000, 1000000, 1000000, -1000000 };
    CHECK(singleNumber(f, 4) == -1000000);

    int g[] = { 0, 0, 0, 7 };
    CHECK(singleNumber(g, 4) == 7);

    int h[] = { 7, 7, 7, 0 };
    CHECK(singleNumber(h, 4) == 0);

    printf("single_number_ii: OK\n");
    return 0;
}
