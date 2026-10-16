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
        /* [1,2,2,3,4,4,3] */
        TreeNode *a = tn(1, tn(2, tn(3, NULL, NULL), tn(4, NULL, NULL)),
                            tn(2, tn(4, NULL, NULL), tn(3, NULL, NULL)));
        CHECK(isSymmetric(a) == true);
    }
    {
        /* [1,2,2,null,3,null,3] */
        TreeNode *b = tn(1, tn(2, NULL, tn(3, NULL, NULL)),
                            tn(2, NULL, tn(3, NULL, NULL)));
        CHECK(isSymmetric(b) == false);
    }
    CHECK(isSymmetric(NULL) == true);
    {
        TreeNode *s = tn(1, NULL, NULL);
        CHECK(isSymmetric(s) == true);
    }
    {
        /* only a left child */
        TreeNode *l = tn(1, tn(2, NULL, NULL), NULL);
        CHECK(isSymmetric(l) == false);
    }
    {
        /* one value differs */
        TreeNode *d = tn(1, tn(2, NULL, NULL), tn(3, NULL, NULL));
        CHECK(isSymmetric(d) == false);
    }
    {
        /* mirrored with different deep values */
        TreeNode *c = tn(1, tn(2, tn(5, NULL, NULL), tn(3, NULL, NULL)),
                            tn(2, tn(3, NULL, NULL), tn(5, NULL, NULL)));
        CHECK(isSymmetric(c) == true);
    }
    {
        /* deep asymmetric leaf */
        TreeNode *d = tn(1, tn(2, tn(5, NULL, NULL), tn(3, NULL, NULL)),
                            tn(2, tn(3, NULL, NULL), tn(4, NULL, NULL)));
        CHECK(isSymmetric(d) == false);
    }
    {
        /* negative values, symmetric */
        TreeNode *e = tn(-1, tn(-2, NULL, NULL), tn(-2, NULL, NULL));
        CHECK(isSymmetric(e) == true);
    }
    printf("symmetric_tree: OK\n");
    return 0;
}
