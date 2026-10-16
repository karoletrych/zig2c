#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[3] = { 3, 2, 3 };
        CHECK(majorityElement(a, 3) == 3);
    }
    {
        int b[7] = { 2, 2, 1, 1, 1, 2, 2 };
        CHECK(majorityElement(b, 7) == 2);
    }
    {
        int one[1] = { 1 };
        CHECK(majorityElement(one, 1) == 1);
    }
    {
        int all[5] = { 5, 5, 5, 5, 5 };
        CHECK(majorityElement(all, 5) == 5);
    }
    {
        int pair[2] = { 9, 9 };
        CHECK(majorityElement(pair, 2) == 9);
    }
    {
        int neg[3] = { -1, -1, 2 };
        CHECK(majorityElement(neg, 3) == -1);
    }
    printf("majority_element: OK\n");
    return 0;
}
