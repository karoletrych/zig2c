#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[6] = { 1, 2, 3, 0, 0, 0 };
        int b[3] = { 2, 5, 6 };
        merge(a, 6, 3, b, 3, 3);
        CHECK(a[0] == 1 && a[1] == 2 && a[2] == 2 && a[3] == 3 && a[4] == 5 && a[5] == 6);
    }
    {
        int a[1] = { 1 };
        int b[1] = { 2 };
        merge(a, 1, 1, b, 1, 0);
        CHECK(a[0] == 1);
    }
    {
        int a[2] = { 0, 0 };
        int b[1] = { 1 };
        merge(a, 2, 0, b, 1, 1);
        CHECK(a[0] == 1 && a[1] == 0);
    }
    printf("merge_sorted_array: OK\n");
    return 0;
}
