#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(isPalindrome("A man, a plan, a canal: Panama") == true);
    CHECK(isPalindrome("race a car") == false);
    CHECK(isPalindrome(" ") == true);
    CHECK(isPalindrome("") == true);
    CHECK(isPalindrome("a") == true);
    CHECK(isPalindrome(".,") == true);
    CHECK(isPalindrome("0P") == false);
    CHECK(isPalindrome("ab_a") == true);
    CHECK(isPalindrome("A1b2B1a") == true);
    printf("valid_palindrome: OK\n");
    return 0;
}
