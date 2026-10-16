#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(isPalindrome(121));
    CHECK(!isPalindrome(-121));
    CHECK(!isPalindrome(10));
    CHECK(isPalindrome(0));
    CHECK(isPalindrome(1));
    CHECK(isPalindrome(11));
    CHECK(isPalindrome(12321));
    CHECK(isPalindrome(2147447412));
    CHECK(!isPalindrome(100));
    CHECK(!isPalindrome(1234));
    CHECK(!isPalindrome(2147483647));
    printf("palindrome_number: OK\n");
    return 0;
}
