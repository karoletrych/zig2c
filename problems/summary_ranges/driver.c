#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int a[6] = { 0, 1, 2, 4, 5, 7 };
        int rs = 0;
        char **r = summaryRanges(a, 6, &rs);
        CHECK(rs == 3);
        CHECK(strcmp(r[0], "0->2") == 0);
        CHECK(strcmp(r[1], "4->5") == 0);
        CHECK(strcmp(r[2], "7") == 0);
    }
    {
        int b[7] = { 0, 2, 3, 4, 6, 8, 9 };
        int rs = 0;
        char **r = summaryRanges(b, 7, &rs);
        CHECK(rs == 4);
        CHECK(strcmp(r[0], "0") == 0);
        CHECK(strcmp(r[1], "2->4") == 0);
        CHECK(strcmp(r[2], "6") == 0);
        CHECK(strcmp(r[3], "8->9") == 0);
    }
    {
        int rs = 0;
        char **r = summaryRanges(NULL, 0, &rs);
        CHECK(rs == 0);
        (void)r;
    }
    {
        int neg[5] = { -3, -2, -1, 1, 2 };
        int rs = 0;
        char **r = summaryRanges(neg, 5, &rs);
        CHECK(rs == 2);
        CHECK(strcmp(r[0], "-3->-1") == 0);
        CHECK(strcmp(r[1], "1->2") == 0);
    }
    {
        int big[2] = { -2147483647 - 1, 2147483647 };
        int rs = 0;
        char **r = summaryRanges(big, 2, &rs);
        CHECK(rs == 2);
        CHECK(strcmp(r[0], "-2147483648") == 0);
        CHECK(strcmp(r[1], "2147483647") == 0);
    }
    printf("summary_ranges: OK\n");
    return 0;
}
