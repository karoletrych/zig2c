#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(numTilings(3) == 5);
    CHECK(numTilings(4) == 11);
    CHECK(numTilings(5) == 24);
    CHECK(numTilings(30) == 312342182);
    CHECK(numTilings(0) == 1);
    CHECK(numTilings(1) == 1);
    CHECK(numTilings(2) == 2);
    printf("domino_tromino_tiling: OK\n");
    return 0;
}
