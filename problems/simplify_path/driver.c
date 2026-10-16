#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(strcmp(simplifyPath("/home/"), "/home") == 0);
    CHECK(strcmp(simplifyPath("/home//foo/"), "/home/foo") == 0);
    CHECK(strcmp(simplifyPath("/home/user/Documents/../Pictures"), "/home/user/Pictures") == 0);
    CHECK(strcmp(simplifyPath("/../"), "/") == 0);
    CHECK(strcmp(simplifyPath("/.../a/../b/c/../d/./"), "/.../b/d") == 0);
    CHECK(strcmp(simplifyPath("/"), "/") == 0);
    CHECK(strcmp(simplifyPath("/a/b/c/././."), "/a/b/c") == 0);
    CHECK(strcmp(simplifyPath("/a/b/.."), "/a") == 0);
    CHECK(strcmp(simplifyPath("/a/../../b"), "/b") == 0);
    CHECK(strcmp(simplifyPath("/..."), "/...") == 0);
    CHECK(strcmp(simplifyPath("/.."), "/") == 0);
    printf("simplify_path: OK\n");
    return 0;
}
