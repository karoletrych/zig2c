#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        RandomizedSet *obj = randomizedSetCreate();
        CHECK(randomizedSetInsert(obj, 1));
        CHECK(!randomizedSetRemove(obj, 2));
        CHECK(randomizedSetInsert(obj, 2));
        int g = randomizedSetGetRandom(obj);
        CHECK(g == 1 || g == 2);
        CHECK(randomizedSetRemove(obj, 1));
        CHECK(!randomizedSetInsert(obj, 2));
        CHECK(randomizedSetGetRandom(obj) == 2);
    }
    {
        RandomizedSet *obj = randomizedSetCreate();
        CHECK(randomizedSetInsert(obj, 5));
        CHECK(randomizedSetGetRandom(obj) == 5);
        CHECK(randomizedSetGetRandom(obj) == 5);
        CHECK(randomizedSetRemove(obj, 5));
        CHECK(randomizedSetInsert(obj, 5));
        CHECK(randomizedSetGetRandom(obj) == 5);
    }
    {
        RandomizedSet *obj = randomizedSetCreate();
        for (int i = 0; i < 10; i++) CHECK(randomizedSetInsert(obj, i));
        CHECK(!randomizedSetInsert(obj, 4));
        CHECK(randomizedSetRemove(obj, 4));
        CHECK(!randomizedSetRemove(obj, 4));
        for (int t = 0; t < 200; t++) {
            int g = randomizedSetGetRandom(obj);
            CHECK(g != 4 && g >= 0 && g < 10);
        }
    }
    printf("randomized_set: OK\n");
    return 0;
}
