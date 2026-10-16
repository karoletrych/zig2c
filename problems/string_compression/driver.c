#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    char a[] = "aabbccc";
    int rs = 0;
    int len = compress(a, 7, &rs);
    CHECK(len == 6 && rs == 6);
    CHECK(strncmp(a, "a2b2c3", 6) == 0);

    char b[] = "a";
    rs = 0;
    len = compress(b, 1, &rs);
    CHECK(len == 1 && rs == 1);
    CHECK(strncmp(b, "a", 1) == 0);

    char c[13] = { 'a', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b' };
    rs = 0;
    len = compress(c, 13, &rs);
    CHECK(len == 4 && rs == 4);
    CHECK(strncmp(c, "ab12", 4) == 0);

    char d[] = "aaaaaaaaaaaa";
    rs = 0;
    len = compress(d, 12, &rs);
    CHECK(len == 3 && rs == 3);
    CHECK(strncmp(d, "a12", 3) == 0);

    char e[] = "xyz";
    rs = 0;
    len = compress(e, 3, &rs);
    CHECK(len == 3 && rs == 3);
    CHECK(strncmp(e, "xyz", 3) == 0);

    printf("string_compression: OK\n");
    return 0;
}
