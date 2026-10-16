#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static TreeNode *tn(int v, TreeNode *l, TreeNode *r) {
    TreeNode *n = malloc(sizeof(TreeNode));
    n->val = v;
    n->left = l;
    n->right = r;
    return n;
}

int main(void) {
    {
        TreeNode *a = tn(1, tn(2, NULL, NULL), tn(3, NULL, NULL));
        TreeNode *b = tn(1, tn(2, NULL, NULL), tn(3, NULL, NULL));
        CHECK(isSameTree(a, b) == true);
    }
    {
        /* different structure */
        TreeNode *a = tn(1, tn(2, NULL, NULL), NULL);
        TreeNode *b = tn(1, NULL, tn(2, NULL, NULL));
        CHECK(isSameTree(a, b) == false);
    }
    {
        /* different values */
        TreeNode *a = tn(1, tn(2, NULL, NULL), tn(1, NULL, NULL));
        TreeNode *b = tn(1, tn(1, NULL, NULL), tn(2, NULL, NULL));
        CHECK(isSameTree(a, b) == false);
    }
    CHECK(isSameTree(NULL, NULL) == true);
    CHECK(isSameTree(NULL, tn(1, NULL, NULL)) == false);
    CHECK(isSameTree(tn(1, NULL, NULL), NULL) == false);
    CHECK(isSameTree(tn(7, NULL, NULL), tn(7, NULL, NULL)) == true);
    CHECK(isSameTree(tn(7, NULL, NULL), tn(-7, NULL, NULL)) == false);
    {
        /* extra depth on one side */
        TreeNode *deep = tn(1, tn(2, tn(4, NULL, NULL), NULL), tn(3, NULL, NULL));
        TreeNode *shallow = tn(1, tn(2, NULL, NULL), tn(3, NULL, NULL));
        CHECK(isSameTree(deep, shallow) == false);
        CHECK(isSameTree(deep, deep) == true);
    }
    printf("same_tree: OK\n");
    return 0;
}
