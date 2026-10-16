#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(strcmp(decodeString("3[a]2[bc]"), "aaabcbc") == 0);
    CHECK(strcmp(decodeString("3[a2[c]]"), "accaccacc") == 0);
    CHECK(strcmp(decodeString("2[abc]3[cd]ef"), "abcabccdcdcdef") == 0);
    CHECK(strcmp(decodeString("10[a]"), "aaaaaaaaaa") == 0);
    CHECK(strcmp(decodeString("abc"), "abc") == 0);
    CHECK(strcmp(decodeString("3[z]2[2[y]pq4[2[jk]e1[f]]]ef"), "zzzyypqjkjkefjkjkefjkjkefjkjkefyypqjkjkefjkjkefjkjkefjkjkefef") == 0);
    printf("decode_string: OK\n");
    return 0;
}
