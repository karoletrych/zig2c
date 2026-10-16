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
    {
        /* [4,2,6,1,3] -> 1 */
        struct TreeNode *t = mk(4, mk(2, mk(1, NULL, NULL), mk(3, NULL, NULL)), mk(6, NULL, NULL));
        CHECK(getMinimumDifference(t) == 1);
    }
    {
        /* [1,0,48,null,null,12,49] -> 1 */
        struct TreeNode *t = mk(1, mk(0, NULL, NULL), mk(48, mk(12, NULL, NULL), mk(49, NULL, NULL)));
        CHECK(getMinimumDifference(t) == 1);
    }
    {
        CHECK(getMinimumDifference(mk(1, NULL, mk(3, NULL, NULL))) == 2);
        CHECK(getMinimumDifference(mk(3, mk(1, NULL, NULL), NULL)) == 2);
        CHECK(getMinimumDifference(mk(5, mk(4, NULL, NULL), mk(7, NULL, NULL))) == 1);
    }
    {
        /* [236,104,701,null,227,null,911] -> 9 */
        struct TreeNode *t = mk(236, mk(104, NULL, mk(227, NULL, NULL)), mk(701, NULL, mk(911, NULL, NULL)));
        CHECK(getMinimumDifference(t) == 9);
        CHECK(getMinimumDifference(mk(3, mk(2, mk(1, NULL, NULL), NULL), NULL)) == 1);
    }
    printf("min_abs_diff_bst: OK\n");
    return 0;
}
