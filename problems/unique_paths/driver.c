#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(uniquePaths(3, 7) == 28);
    CHECK(uniquePaths(3, 2) == 3);
    CHECK(uniquePaths(1, 1) == 1);
    CHECK(uniquePaths(1, 10) == 1);
    CHECK(uniquePaths(10, 1) == 1);
    CHECK(uniquePaths(10, 10) == 48620);
    CHECK(uniquePaths(15, 15) == 40116600);
    printf("unique_paths: OK\n");
    return 0;
}
