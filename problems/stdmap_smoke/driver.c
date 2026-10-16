#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int rs = 0;
    CHECK(stringMapSmoke(&rs) == 37);
    CHECK(rs == 3);
    CHECK(intMapIter(&rs) == 132);
    CHECK(rs == 3);
    printf("stdmap_smoke: OK\n");
    return 0;
}
