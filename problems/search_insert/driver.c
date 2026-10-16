#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[4] = { 1, 3, 5, 6 };
        CHECK(searchInsert(a, 4, 5) == 2);
        CHECK(searchInsert(a, 4, 2) == 1);
        CHECK(searchInsert(a, 4, 7) == 4);
        CHECK(searchInsert(a, 4, 1) == 0);
        CHECK(searchInsert(a, 4, 6) == 3);
        CHECK(searchInsert(a, 4, 0) == 0);
        CHECK(searchInsert(a, 4, -5) == 0);
        CHECK(searchInsert(a, 4, 100) == 4);
    }
    {
        int a[1] = { 4 };
        CHECK(searchInsert(a, 1, 4) == 0);
        CHECK(searchInsert(a, 1, 1) == 0);
        CHECK(searchInsert(a, 1, 9) == 1);
    }
    {
        int a[3] = { 2, 2, 2 };
        CHECK(searchInsert(a, 3, 2) == 0);
        CHECK(searchInsert(a, 3, 3) == 3);
    }
    printf("search_insert: OK\n");
    return 0;
}
