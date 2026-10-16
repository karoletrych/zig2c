#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int rs = 0;
    CHECK(buildAndLink(3, &rs) == 30);
    CHECK(rs == 3);
    CHECK(buildAndLink(0, &rs) == 0);
    CHECK(rs == 0);
    CHECK(cacheSmoke(3, &rs) == 3);
    CHECK(rs == 3);
    CHECK(floorModCheck() == 198);
    CHECK(charLiteralCond("(a)") == 12);
    printf("lc150_smoke: OK\n");
    return 0;
}
