#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[6] = { 5, 7, 7, 8, 8, 10 };
        int rs = 0;
        int *r = searchRange(a, 6, 8, &rs);
        CHECK(rs == 2);
        CHECK(r[0] == 3 && r[1] == 4);

        int rs2 = 0;
        int *r2 = searchRange(a, 6, 6, &rs2);
        CHECK(rs2 == 2);
        CHECK(r2[0] == -1 && r2[1] == -1);
    }
    {
        int e[1] = { 0 };
        int rs = 0;
        int *r = searchRange(e, 0, 0, &rs);
        CHECK(rs == 2);
        CHECK(r[0] == -1 && r[1] == -1);
    }
    {
        int a[1] = { 1 };
        int rs = 0;
        int *r = searchRange(a, 1, 1, &rs);
        CHECK(r[0] == 0 && r[1] == 0);
        int *r2 = searchRange(a, 1, 2, &rs);
        CHECK(r2[0] == -1 && r2[1] == -1);
    }
    {
        int a[2] = { 2, 2 };
        int rs = 0;
        int *r = searchRange(a, 2, 2, &rs);
        CHECK(r[0] == 0 && r[1] == 1);
    }
    {
        int a[5] = { 4, 4, 4, 4, 4 };
        int rs = 0;
        int *r = searchRange(a, 5, 4, &rs);
        CHECK(r[0] == 0 && r[1] == 4);
    }
    {
        int a[5] = { 1, 2, 3, 4, 5 };
        int rs = 0;
        int *r = searchRange(a, 5, 1, &rs);
        CHECK(r[0] == 0 && r[1] == 0);
        int *r2 = searchRange(a, 5, 5, &rs);
        CHECK(r2[0] == 4 && r2[1] == 4);
        int *r3 = searchRange(a, 5, -9, &rs);
        CHECK(r3[0] == -1 && r3[1] == -1);
        int *r4 = searchRange(a, 5, 99, &rs);
        CHECK(r4[0] == -1 && r4[1] == -1);
    }
    printf("first_last_position: OK\n");
    return 0;
}
