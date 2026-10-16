#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(minDistance("horse", "ros") == 3);
    CHECK(minDistance("intention", "execution") == 5);
    CHECK(minDistance("", "") == 0);
    CHECK(minDistance("abc", "") == 3);
    CHECK(minDistance("", "abc") == 3);
    CHECK(minDistance("abc", "abc") == 0);
    CHECK(minDistance("a", "b") == 1);
    CHECK(minDistance("kitten", "sitting") == 3);
    CHECK(minDistance("aaaa", "aaaa") == 0);
    printf("edit_distance: OK\n");
    return 0;
}
