#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        SmallestInfiniteSet *obj = smallestInfiniteSetCreate();
        addBack(obj, 2);
        CHECK(popSmallest(obj) == 1);
        CHECK(popSmallest(obj) == 2);
        CHECK(popSmallest(obj) == 3);
        addBack(obj, 1);
        CHECK(popSmallest(obj) == 1);
        CHECK(popSmallest(obj) == 4);
        CHECK(popSmallest(obj) == 5);
    }
    {
        SmallestInfiniteSet *obj = smallestInfiniteSetCreate();
        CHECK(popSmallest(obj) == 1);
        CHECK(popSmallest(obj) == 2);
        addBack(obj, 2);
        addBack(obj, 2);
        CHECK(popSmallest(obj) == 2);
        CHECK(popSmallest(obj) == 3);
        addBack(obj, 100);
        CHECK(popSmallest(obj) == 4);
        CHECK(popSmallest(obj) == 5);
        CHECK(popSmallest(obj) == 6);
    }
    printf("smallest_infinite_set: OK\n");
    return 0;
}
