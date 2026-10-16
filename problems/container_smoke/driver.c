#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int a[6] = { 1, 2, 2, 3, 3, 3 };
    int rs = 0;
    int *r = containerSmoke(a, 6, &rs);
    CHECK(rs == 3);
    CHECK(r[0] == 1);
    CHECK(r[1] == 2);
    CHECK(r[2] == 3);
    printf("container_smoke: OK\n");
    return 0;
}
