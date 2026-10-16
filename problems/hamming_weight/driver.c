#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(hammingWeight(11u) == 3);
    CHECK(hammingWeight(128u) == 1);
    CHECK(hammingWeight(4294967293u) == 31);
    CHECK(hammingWeight(0u) == 0);
    CHECK(hammingWeight(4294967295u) == 32);
    CHECK(hammingWeight(1u) == 1);
    CHECK(hammingWeight(0x55555555u) == 16);
    CHECK(hammingWeight(0xAAAAAAAAu) == 16);
    printf("hamming_weight: OK\n");
    return 0;
}
