#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(strcmp(intToRoman(3), "III") == 0);
    CHECK(strcmp(intToRoman(58), "LVIII") == 0);
    CHECK(strcmp(intToRoman(1994), "MCMXCIV") == 0);
    CHECK(strcmp(intToRoman(1), "I") == 0);
    CHECK(strcmp(intToRoman(4), "IV") == 0);
    CHECK(strcmp(intToRoman(9), "IX") == 0);
    CHECK(strcmp(intToRoman(40), "XL") == 0);
    CHECK(strcmp(intToRoman(444), "CDXLIV") == 0);
    CHECK(strcmp(intToRoman(3999), "MMMCMXCIX") == 0);
    printf("integer_to_roman: OK\n");
    return 0;
}
