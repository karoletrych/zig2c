#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int d[] = { 1, 2, 3 };
        int rs = 0;
        int *o = plusOne(d, 3, &rs);
        CHECK(rs == 3 && o[0] == 1 && o[1] == 2 && o[2] == 4);
    }
    {
        int d[] = { 4, 3, 2, 1 };
        int rs = 0;
        int *o = plusOne(d, 4, &rs);
        CHECK(rs == 4 && o[0] == 4 && o[1] == 3 && o[2] == 2 && o[3] == 2);
    }
    {
        int d[] = { 9 };
        int rs = 0;
        int *o = plusOne(d, 1, &rs);
        CHECK(rs == 2 && o[0] == 1 && o[1] == 0);
    }
    {
        int d[] = { 9, 9, 9 };
        int rs = 0;
        int *o = plusOne(d, 3, &rs);
        CHECK(rs == 4 && o[0] == 1 && o[1] == 0 && o[2] == 0 && o[3] == 0);
    }
    {
        int d[] = { 0 };
        int rs = 0;
        int *o = plusOne(d, 1, &rs);
        CHECK(rs == 1 && o[0] == 1);
    }
    {
        int d[] = { 1, 9 };
        int rs = 0;
        int *o = plusOne(d, 2, &rs);
        CHECK(rs == 2 && o[0] == 2 && o[1] == 0);
    }
    printf("plus_one: OK\n");
    return 0;
}
