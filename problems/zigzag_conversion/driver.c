#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(strcmp(convert("PAYPALISHIRING", 3), "PAHNAPLSIIGYIR") == 0);
    CHECK(strcmp(convert("PAYPALISHIRING", 4), "PINALSIGYAHRPI") == 0);
    CHECK(strcmp(convert("A", 1), "A") == 0);
    CHECK(strcmp(convert("AB", 1), "AB") == 0);
    CHECK(strcmp(convert("ABC", 5), "ABC") == 0);
    CHECK(strcmp(convert("ABC", 2), "ACB") == 0);
    CHECK(strcmp(convert("", 3), "") == 0);
    printf("zigzag_conversion: OK\n");
    return 0;
}
