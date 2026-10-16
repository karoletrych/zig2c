#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[3] = { 1, 1, 2 };
        CHECK(removeDuplicates(a, 3) == 2);
        CHECK(a[0] == 1 && a[1] == 2);
    }
    {
        int b[10] = { 0, 0, 1, 1, 1, 2, 2, 3, 3, 4 };
        CHECK(removeDuplicates(b, 10) == 5);
        CHECK(b[0] == 0 && b[1] == 1 && b[2] == 2 && b[3] == 3 && b[4] == 4);
    }
    {
        int empty[1] = { 0 };
        CHECK(removeDuplicates(empty, 0) == 0);
    }
    {
        int one[1] = { 5 };
        CHECK(removeDuplicates(one, 1) == 1);
    }
    {
        int same[4] = { 2, 2, 2, 2 };
        CHECK(removeDuplicates(same, 4) == 1);
        CHECK(same[0] == 2);
    }
    printf("remove_duplicates_sorted: OK\n");
    return 0;
}
