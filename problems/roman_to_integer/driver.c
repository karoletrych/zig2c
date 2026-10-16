#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(romanToInt("III") == 3);
    CHECK(romanToInt("LVIII") == 58);
    CHECK(romanToInt("MCMXCIV") == 1994);
    CHECK(romanToInt("IV") == 4);
    CHECK(romanToInt("IX") == 9);
    CHECK(romanToInt("XL") == 40);
    CHECK(romanToInt("XC") == 90);
    CHECK(romanToInt("CD") == 400);
    CHECK(romanToInt("CM") == 900);
    CHECK(romanToInt("I") == 1);
    CHECK(romanToInt("MMMM") == 4000);
    printf("roman_to_integer: OK\n");
    return 0;
}
