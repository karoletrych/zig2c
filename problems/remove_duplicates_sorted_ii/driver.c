#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[6] = { 1, 1, 1, 2, 2, 3 };
        CHECK(removeDuplicates(a, 6) == 5);
        CHECK(a[0] == 1 && a[1] == 1 && a[2] == 2 && a[3] == 2 && a[4] == 3);
    }
    {
        int b[9] = { 0, 0, 1, 1, 1, 1, 2, 3, 3 };
        CHECK(removeDuplicates(b, 9) == 7);
        CHECK(b[0] == 0 && b[1] == 0 && b[2] == 1 && b[3] == 1 && b[4] == 2 && b[5] == 3 && b[6] == 3);
    }
    {
        int empty[1] = { 0 };
        CHECK(removeDuplicates(empty, 0) == 0);
    }
    {
        int one[1] = { 1 };
        CHECK(removeDuplicates(one, 1) == 1);
    }
    {
        int two[2] = { 1, 1 };
        CHECK(removeDuplicates(two, 2) == 2);
    }
    {
        int many[5] = { 4, 4, 4, 4, 4 };
        CHECK(removeDuplicates(many, 5) == 2);
        CHECK(many[0] == 4 && many[1] == 4);
    }
    printf("remove_duplicates_sorted_ii: OK\n");
    return 0;
}
