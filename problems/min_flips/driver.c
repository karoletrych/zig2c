#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(minFlips(2, 6, 5) == 3);
    CHECK(minFlips(4, 2, 7) == 1);
    CHECK(minFlips(1, 2, 3) == 0);
    CHECK(minFlips(0, 0, 0) == 0);
    CHECK(minFlips(0, 0, 1) == 1);
    CHECK(minFlips(0, 0, 7) == 3);
    CHECK(minFlips(3, 3, 0) == 4);
    CHECK(minFlips(7, 0, 0) == 3);
    CHECK(minFlips(0, 7, 0) == 3);
    CHECK(minFlips(8, 3, 5) == 3);
    CHECK(minFlips(15, 0, 15) == 0);
    CHECK(minFlips(1024, 1023, 1024) == 10);
    CHECK(minFlips(1073741824, 1073741824, 1073741824) == 0);
    printf("min_flips: OK\n");
    return 0;
}
