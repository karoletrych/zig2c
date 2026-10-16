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
        int ino[5] = { 9, 3, 15, 20, 7 };
        int post[5] = { 9, 15, 7, 20, 3 };
        TreeNode *got = buildTree(ino, 5, post, 5);
        TreeNode *want = tn(3, tn(9, NULL, NULL), tn(20, tn(15, NULL, NULL), tn(7, NULL, NULL)));
        CHECK(sameShape(got, want));
    }
    {
        /* empty input */
        int dummy[1] = { 0 };
        CHECK(buildTree(dummy, 0, dummy, 0) == NULL);
    }
    {
        /* single node */
        int ino[1] = { -1 };
        int post[1] = { -1 };
        TreeNode *got = buildTree(ino, 1, post, 1);
        CHECK(got && got->val == -1 && got->left == NULL && got->right == NULL);
    }
    {
        /* right-skewed */
        int ino[3] = { 1, 2, 3 };
        int post[3] = { 3, 2, 1 };
        TreeNode *got = buildTree(ino, 3, post, 3);
        TreeNode *want = tn(1, NULL, tn(2, NULL, tn(3, NULL, NULL)));
        CHECK(sameShape(got, want));
    }
    {
        int ino[7] = { 4, 2, 5, 1, 6, 3, 7 };
        int post[7] = { 4, 5, 2, 6, 7, 3, 1 };
        TreeNode *got = buildTree(ino, 7, post, 7);
        TreeNode *want = tn(1, tn(2, tn(4, NULL, NULL), tn(5, NULL, NULL)),
                               tn(3, tn(6, NULL, NULL), tn(7, NULL, NULL)));
        CHECK(sameShape(got, want));
    }
    printf("build_tree_in_post: OK\n");
    return 0;
}
