#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(reverseBits(43261596u) == 964176192u);
    CHECK(reverseBits(0u) == 0u);
    CHECK(reverseBits(4294967295u) == 4294967295u);
    CHECK(reverseBits(1u) == 2147483648u);
    CHECK(reverseBits(2147483648u) == 1u);
    CHECK(reverseBits(reverseBits(123456789u)) == 123456789u);
    printf("reverse_bits: OK\n");
    return 0;
}
