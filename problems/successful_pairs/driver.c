#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int sp[3] = { 5, 1, 3 };
        int po[5] = { 1, 2, 3, 4, 5 };
        int rs = 0;
        int *r = successfulPairs(sp, 3, po, 5, 7, &rs);
        CHECK(rs == 3);
        CHECK(r[0] == 4);
        CHECK(r[1] == 0);
        CHECK(r[2] == 3);
    }
    {
        int sp[3] = { 3, 1, 2 };
        int po[3] = { 8, 5, 8 };
        int rs = 0;
        int *r = successfulPairs(sp, 3, po, 3, 16, &rs);
        CHECK(rs == 3);
        CHECK(r[0] == 2);
        CHECK(r[1] == 0);
        CHECK(r[2] == 2);
    }
    {
        int sp[2] = { 100000, 1 };
        int po[2] = { 100000, 100000 };
        int rs = 0;
        int *r = successfulPairs(sp, 2, po, 2, 10000000000LL, &rs);
        CHECK(rs == 2);
        CHECK(r[0] == 2);
        CHECK(r[1] == 0);
    }
    {
        int sp[3] = { 1, 1, 1 };
        int po[1] = { 1 };
        int rs = 0;
        int *r = successfulPairs(sp, 3, po, 1, 1, &rs);
        CHECK(rs == 3);
        CHECK(r[0] == 1);
        CHECK(r[1] == 1);
        CHECK(r[2] == 1);
    }
    printf("successful_pairs: OK\n");
    return 0;
}
