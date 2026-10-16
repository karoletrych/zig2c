#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int t[8] = { 73, 74, 75, 71, 69, 72, 76, 73 };
    int rs = 0;
    int *r = dailyTemperatures(t, 8, &rs);
    int want[8] = { 1, 1, 4, 2, 1, 1, 0, 0 };
    CHECK(rs == 8);
    for (int i = 0; i < 8; i++) CHECK(r[i] == want[i]);
    printf("daily_temperatures: OK\n");
    return 0;
}
