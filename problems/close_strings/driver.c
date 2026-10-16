#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    char a[] = "abc";
    char b[] = "bca";
    CHECK(closeStrings(a, b));

    char c[] = "a";
    char d[] = "aa";
    CHECK(!closeStrings(c, d));

    char e[] = "cabbba";
    char f[] = "abbccc";
    CHECK(closeStrings(e, f));

    char g[] = "uau";
    char h[] = "ssx";
    CHECK(!closeStrings(g, h));

    char i[] = "abbzzca";
    char j[] = "babzzcz";
    CHECK(!closeStrings(i, j));

    char k[] = "a";
    char l[] = "a";
    CHECK(closeStrings(k, l));

    printf("close_strings: OK\n");
    return 0;
}
