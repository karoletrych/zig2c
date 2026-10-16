#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(lengthOfLastWord("Hello World") == 5);
    CHECK(lengthOfLastWord("   fly me   to   the moon  ") == 4);
    CHECK(lengthOfLastWord("luffy is still joyboy") == 6);
    CHECK(lengthOfLastWord("a") == 1);
    CHECK(lengthOfLastWord("a ") == 1);
    CHECK(lengthOfLastWord(" day") == 3);
    CHECK(lengthOfLastWord("   ") == 0);
    printf("length_of_last_word: OK\n");
    return 0;
}
