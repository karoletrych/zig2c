#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(strcmp(mergeAlternately("abc", "pqr"), "apbqcr") == 0);
    CHECK(strcmp(mergeAlternately("ab", "pqrs"), "apbqrs") == 0);
    CHECK(strcmp(mergeAlternately("abcd", "pq"), "apbqcd") == 0);
    printf("merge_strings: OK\n");
    return 0;
}
