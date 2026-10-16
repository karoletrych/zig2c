#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int gain[5] = { -5, 1, 5, 0, -7 };
    int rs = 0;
    int *r = largestAltitude(gain, 5, &rs);
    CHECK(rs == 6);
    int want[6] = { 0, -5, -4, 1, 1, -6 };
    for (int i = 0; i < 6; i++) CHECK(r[i] == want[i]);

    int g2[7] = { -4, -3, -2, -1, 4, 3, 2 };
    int rs2 = 0;
    int *r2 = largestAltitude(g2, 7, &rs2);
    CHECK(rs2 == 8);
    int want2[8] = { 0, -4, -7, -9, -10, -6, -3, -1 };
    for (int i = 0; i < 8; i++) CHECK(r2[i] == want2[i]);

    int g3[1] = { 0 };
    int rs3 = 0;
    int *r3 = largestAltitude(g3, 1, &rs3);
    CHECK(rs3 == 2);
    CHECK(r3[0] == 0);
    CHECK(r3[1] == 0);

    printf("highest_altitude: OK\n");
    return 0;
}
