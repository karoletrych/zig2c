#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static struct TreeNode *mk(int v, struct TreeNode *l, struct TreeNode *r) {
    struct TreeNode *n = malloc(sizeof(struct TreeNode));
    n->val = v;
    n->left = l;
    n->right = r;
    return n;
}

int main(void) {
    struct TreeNode *t1 = mk(1, NULL, mk(1,
        mk(1, NULL, mk(1, NULL, mk(1, NULL, NULL))),
        mk(1, mk(1, NULL, NULL), NULL)));
    CHECK(longestZigZag(t1) == 3);

    struct TreeNode *t2 = mk(1,
        mk(1, NULL, mk(1, mk(1, NULL, mk(1, NULL, NULL)), mk(1, NULL, NULL))),
        mk(1, NULL, NULL));
    CHECK(longestZigZag(t2) == 4);

    CHECK(longestZigZag(mk(1, NULL, NULL)) == 0);
    CHECK(longestZigZag(NULL) == 0);
    CHECK(longestZigZag(mk(1, mk(2, mk(3, NULL, NULL), NULL), NULL)) == 1);

    printf("longest_zigzag: OK\n");
    return 0;
}
