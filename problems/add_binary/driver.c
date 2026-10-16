#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(strcmp(addBinary("11", "1"), "100") == 0);
    CHECK(strcmp(addBinary("1010", "1011"), "10101") == 0);
    CHECK(strcmp(addBinary("0", "0"), "0") == 0);
    CHECK(strcmp(addBinary("1", "0"), "1") == 0);
    CHECK(strcmp(addBinary("0", "1"), "1") == 0);
    CHECK(strcmp(addBinary("1111", "1"), "10000") == 0);
    CHECK(strcmp(addBinary("", "1"), "1") == 0);
    CHECK(strcmp(addBinary("", ""), "0") == 0);
    CHECK(strcmp(addBinary("1101", "11001"), "100110") == 0);
    printf("add_binary: OK\n");
    return 0;
}
