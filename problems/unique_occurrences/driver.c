#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a[6] = { 1, 2, 2, 1, 1, 3 };
    CHECK(uniqueOccurrences(a, 6));

    int b[2] = { 1, 2 };
    CHECK(!uniqueOccurrences(b, 2));

    int c[10] = { -3, 0, 1, -3, 1, 1, 1, -3, 10, 0 };
    CHECK(uniqueOccurrences(c, 10));

    int d[1] = { 3 };
    CHECK(uniqueOccurrences(d, 1));

    printf("unique_occurrences: OK\n");
    return 0;
}
