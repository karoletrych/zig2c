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
    struct TreeNode *n5 = mk(5, mk(6, NULL, NULL), mk(2, mk(7, NULL, NULL), mk(4, NULL, NULL)));
    struct TreeNode *n1 = mk(1, mk(0, NULL, NULL), mk(8, NULL, NULL));
    struct TreeNode *t = mk(3, n5, n1);

    CHECK(lowestCommonAncestor(t, n5, n1) == t);
    struct TreeNode *n4 = n5->right->right;
    CHECK(lowestCommonAncestor(t, n5, n4) == n5);
    struct TreeNode *n7 = n5->right->left;
    struct TreeNode *n2 = n5->right;
    CHECK(lowestCommonAncestor(t, n7, n4) == n2);

    struct TreeNode *s2 = mk(2, NULL, NULL);
    struct TreeNode *s = mk(1, s2, NULL);
    CHECK(lowestCommonAncestor(s, s, s2) == s);

    CHECK(lowestCommonAncestor(t, t, t) == t);
    CHECK(lowestCommonAncestor(NULL, n5, n1) == NULL);

    printf("lca_binary_tree: OK\n");
    return 0;
}
