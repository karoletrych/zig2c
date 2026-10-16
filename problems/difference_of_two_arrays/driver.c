#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[3] = { 1, 2, 3 };
        int b[3] = { 2, 4, 6 };
        int rs = 0;
        int *cols = NULL;
        int **res = findDifference(a, 3, b, 3, &rs, &cols);
        CHECK(rs == 2);
        CHECK(cols[0] == 2);
        CHECK(res[0][0] == 1);
        CHECK(res[0][1] == 3);
        CHECK(cols[1] == 2);
        CHECK(res[1][0] == 4);
        CHECK(res[1][1] == 6);
    }
    {
        int a[4] = { 1, 2, 3, 3 };
        int b[4] = { 1, 1, 2, 2 };
        int rs = 0;
        int *cols = NULL;
        int **res = findDifference(a, 4, b, 4, &rs, &cols);
        CHECK(rs == 2);
        CHECK(cols[0] == 1);
        CHECK(res[0][0] == 3);
        CHECK(cols[1] == 0);
    }
    {
        int a[1] = { -1000 };
        int b[1] = { 1000 };
        int rs = 0;
        int *cols = NULL;
        int **res = findDifference(a, 1, b, 1, &rs, &cols);
        CHECK(rs == 2);
        CHECK(cols[0] == 1);
        CHECK(res[0][0] == -1000);
        CHECK(cols[1] == 1);
        CHECK(res[1][0] == 1000);
    }
    printf("difference_of_two_arrays: OK\n");
    return 0;
}
