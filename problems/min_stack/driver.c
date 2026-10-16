#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        MinStack *obj = minStackCreate();
        minStackPush(obj, -2);
        minStackPush(obj, 0);
        minStackPush(obj, -3);
        CHECK(minStackGetMin(obj) == -3);
        minStackPop(obj);
        CHECK(minStackTop(obj) == 0);
        CHECK(minStackGetMin(obj) == -2);
    }
    {
        MinStack *obj = minStackCreate();
        minStackPush(obj, 2147483647);
        minStackPush(obj, -2147483647 - 1);
        minStackPush(obj, 0);
        CHECK(minStackGetMin(obj) == -2147483647 - 1);
        CHECK(minStackTop(obj) == 0);
        minStackPop(obj);
        minStackPop(obj);
        CHECK(minStackGetMin(obj) == 2147483647);
        CHECK(minStackTop(obj) == 2147483647);

        minStackPush(obj, 5);
        minStackPush(obj, 5);
        CHECK(minStackGetMin(obj) == 5);
        minStackPop(obj);
        CHECK(minStackGetMin(obj) == 5);
    }
    printf("min_stack: OK\n");
    return 0;
}
