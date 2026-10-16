#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[4] = { 3, 2, 2, 3 };
        CHECK(removeElement(a, 4, 3) == 2);
        CHECK(a[0] == 2 && a[1] == 2);
    }
    {
        int b[8] = { 0, 1, 2, 2, 3, 0, 4, 2 };
        CHECK(removeElement(b, 8, 2) == 5);
        CHECK(b[0] == 0 && b[1] == 1 && b[2] == 3 && b[3] == 0 && b[4] == 4);
    }
    {
        int empty[1] = { 0 };
        CHECK(removeElement(empty, 0, 5) == 0);
    }
    {
        int all[3] = { 7, 7, 7 };
        CHECK(removeElement(all, 3, 7) == 0);
    }
    {
        int none[3] = { 1, 2, 3 };
        CHECK(removeElement(none, 3, 9) == 3);
    }
    {
        int one[1] = { 4 };
        CHECK(removeElement(one, 1, 5) == 1);
    }
    printf("remove_element: OK\n");
    return 0;
}
