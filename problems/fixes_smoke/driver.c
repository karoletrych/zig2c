#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int rs = 0;
    CHECK(sumArrayField(&rs) == 34);
    CHECK(rs == 2);
    CHECK(useListPop(&rs) == 98);
    CHECK(rs == 1);
    CHECK(useMapPtr(&rs) == 2);
    CHECK(errUnionHelper());
    CHECK(deferReturn() == 60);
    CHECK(useConstArrays(&rs) == 26);
    CHECK(rs == 2);
    printf("fixes_smoke: OK\n");
    return 0;
}
