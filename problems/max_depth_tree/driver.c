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
    struct TreeNode *t = mk(3, mk(9, NULL, NULL), mk(20, mk(15, NULL, NULL), mk(7, NULL, NULL)));
    CHECK(maxDepth(t) == 3);
    CHECK(maxDepth(NULL) == 0);
    struct TreeNode *one = mk(1, NULL, mk(2, NULL, NULL));
    CHECK(maxDepth(one) == 2);
    printf("max_depth_tree: OK\n");
    return 0;
}
