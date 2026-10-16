#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        int g[5] = { 1, 2, 3, 4, 5 };
        int c[5] = { 3, 4, 5, 1, 2 };
        CHECK(canCompleteCircuit(g, 5, c, 5) == 3);
    }
    {
        int g[3] = { 2, 3, 4 };
        int c[3] = { 3, 4, 3 };
        CHECK(canCompleteCircuit(g, 3, c, 3) == -1);
    }
    {
        int g[1] = { 1 };
        int c[1] = { 1 };
        CHECK(canCompleteCircuit(g, 1, c, 1) == 0);
    }
    {
        int g[1] = { 1 };
        int c[1] = { 2 };
        CHECK(canCompleteCircuit(g, 1, c, 1) == -1);
    }
    {
        int g[5] = { 5, 1, 2, 3, 4 };
        int c[5] = { 4, 4, 1, 5, 1 };
        CHECK(canCompleteCircuit(g, 5, c, 5) == 4);
    }
    {
        int g[1] = { 0 };
        int c[1] = { 0 };
        CHECK(canCompleteCircuit(g, 0, c, 0) == 0);
    }
    printf("gas_station: OK\n");
    return 0;
}
