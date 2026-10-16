#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[7] = { 4, 5, 6, 7, 0, 1, 2 };
        CHECK(search(a, 7, 0) == 4);
        CHECK(search(a, 7, 3) == -1);
    }
    {
        int a[1] = { 1 };
        CHECK(search(a, 1, 0) == -1);
        CHECK(search(a, 1, 1) == 0);
    }
    {
        int a[2] = { 1, 3 };
        CHECK(search(a, 2, 3) == 1);
        CHECK(search(a, 2, 1) == 0);
        CHECK(search(a, 2, 2) == -1);
    }
    {
        int a[3] = { 5, 1, 3 };
        CHECK(search(a, 3, 5) == 0);
        CHECK(search(a, 3, 1) == 1);
        CHECK(search(a, 3, 3) == 2);
    }
    {
        int a[4] = { 1, 3, 5, 7 };
        CHECK(search(a, 4, 7) == 3);
        CHECK(search(a, 4, 1) == 0);
        CHECK(search(a, 4, 4) == -1);
    }
    {
        int a[8] = { 7, 8, 1, 2, 3, 4, 5, 6 };
        CHECK(search(a, 8, 2) == 3);
        CHECK(search(a, 8, 7) == 0);
        CHECK(search(a, 8, 6) == 7);
        CHECK(search(a, 8, 9) == -1);
    }
    printf("search_rotated: OK\n");
    return 0;
}
