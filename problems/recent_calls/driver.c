#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    RecentCounter *obj = recentCounterCreate();
    CHECK(recentCounterPing(obj, 1) == 1);
    CHECK(recentCounterPing(obj, 100) == 2);
    CHECK(recentCounterPing(obj, 3001) == 3);
    CHECK(recentCounterPing(obj, 3002) == 3);
    recentCounterFree(obj);

    RecentCounter *obj2 = recentCounterCreate();
    CHECK(recentCounterPing(obj2, 5000) == 1);
    CHECK(recentCounterPing(obj2, 8001) == 1);
    CHECK(recentCounterPing(obj2, 8002) == 2);
    CHECK(recentCounterPing(obj2, 9000) == 3);
    CHECK(recentCounterPing(obj2, 20000) == 1);
    recentCounterFree(obj2);

    printf("recent_calls: OK\n");
    return 0;
}
