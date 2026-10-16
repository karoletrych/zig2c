#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(strcmp(removeStars("leet**cod*e"), "lecoe") == 0);
    CHECK(strcmp(removeStars("erase*****"), "") == 0);
    CHECK(strcmp(removeStars("abc"), "abc") == 0);
    CHECK(strcmp(removeStars("a*b*c*"), "") == 0);
    printf("removing_stars: OK\n");
    return 0;
}
