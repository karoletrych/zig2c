#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static TreeNode *tn(int v, TreeNode *l, TreeNode *r) {
    TreeNode *n = malloc(sizeof(TreeNode));
    n->val = v;
    n->left = l;
    n->right = r;
    return n;
}

static int sameShape(TreeNode *a, TreeNode *b) {
    if (!a && !b) return 1;
    if (!a || !b) return 0;
    if (a->val != b->val) return 0;
    return sameShape(a->left, b->left) && sameShape(a->right, b->right);
}

int main(void) {
    {
        /* [4,2,7,1,3,6,9] -> [4,7,2,9,6,3,1] */
        TreeNode *got = invertTree(tn(4, tn(2, tn(1, NULL, NULL), tn(3, NULL, NULL)),
                                        tn(7, tn(6, NULL, NULL), tn(9, NULL, NULL))));
        TreeNode *want = tn(4, tn(7, tn(9, NULL, NULL), tn(6, NULL, NULL)),
                               tn(2, tn(3, NULL, NULL), tn(1, NULL, NULL)));
        CHECK(sameShape(got, want));
    }
    CHECK(invertTree(NULL) == NULL);
    {
        TreeNode *got = invertTree(tn(1, NULL, NULL));
        CHECK(got && got->val == 1 && got->left == NULL && got->right == NULL);
    }
    {
        /* only a left child */
        TreeNode *got = invertTree(tn(1, tn(2, NULL, NULL), NULL));
        CHECK(got->left == NULL && got->right && got->right->val == 2);
    }
    {
        /* only a right child */
        TreeNode *got = invertTree(tn(1, NULL, tn(2, NULL, NULL)));
        CHECK(got->right == NULL && got->left && got->left->val == 2);
    }
    {
        /* inverting twice restores the original */
        TreeNode *orig = tn(5, tn(3, tn(2, NULL, NULL), tn(4, NULL, NULL)),
                               tn(8, tn(7, NULL, NULL), tn(9, NULL, NULL)));
        CHECK(sameShape(invertTree(invertTree(orig)), orig));
    }
    {
        TreeNode *got = invertTree(tn(-1, tn(-2, NULL, NULL), tn(-3, NULL, NULL)));
        CHECK(got->left->val == -3 && got->right->val == -2);
    }
    printf("invert_tree: OK\n");
    return 0;
}
