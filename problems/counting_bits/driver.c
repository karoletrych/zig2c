#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int rs = 0;
        int *r = countBits(5, &rs);
        CHECK(rs == 6);
        CHECK(r[0] == 0);
        CHECK(r[1] == 1);
        CHECK(r[2] == 1);
        CHECK(r[3] == 2);
        CHECK(r[4] == 1);
        CHECK(r[5] == 2);
    }
    {
        int rs = 0;
        int *r = countBits(0, &rs);
        CHECK(rs == 1);
        CHECK(r[0] == 0);
    }
    {
        int rs = 0;
        int *r = countBits(2, &rs);
        CHECK(rs == 3);
        CHECK(r[0] == 0);
        CHECK(r[1] == 1);
        CHECK(r[2] == 1);
    }
    printf("counting_bits: OK\n");
    return 0;
}
