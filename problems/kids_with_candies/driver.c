#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a[5] = { 2, 3, 5, 1, 3 };
    int rs = 0;
    bool *r = kidsWithCandies(a, 5, 3, &rs);
    CHECK(rs == 5);
    CHECK(r[0] && r[1] && r[2] && !r[3] && r[4]);

    int b[5] = { 4, 2, 1, 1, 2 };
    rs = 0;
    r = kidsWithCandies(b, 5, 1, &rs);
    CHECK(rs == 5);
    CHECK(r[0] && !r[1] && !r[2] && !r[3] && !r[4]);

    int c[3] = { 12, 1, 12 };
    rs = 0;
    r = kidsWithCandies(c, 3, 10, &rs);
    CHECK(rs == 3);
    CHECK(r[0] && !r[1] && r[2]);

    int d[1] = { 7 };
    rs = 0;
    r = kidsWithCandies(d, 1, 0, &rs);
    CHECK(rs == 1);
    CHECK(r[0]);

    printf("kids_with_candies: OK\n");
    return 0;
}
