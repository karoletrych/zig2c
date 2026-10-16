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
        /* [2,1,3] -> true */
        CHECK(isValidBST(mk(2, mk(1, NULL, NULL), mk(3, NULL, NULL))) == true);
        /* [5,1,4,null,null,3,6] -> false */
        struct TreeNode *bad = mk(5, mk(1, NULL, NULL), mk(4, mk(3, NULL, NULL), mk(6, NULL, NULL)));
        CHECK(isValidBST(bad) == false);
    }
    {
        CHECK(isValidBST(NULL) == true);
        CHECK(isValidBST(mk(1, NULL, NULL)) == true);
        CHECK(isValidBST(mk(2147483647, NULL, NULL)) == true);
        CHECK(isValidBST(mk(-2147483648, NULL, NULL)) == true);
        CHECK(isValidBST(mk(1, mk(1, NULL, NULL), NULL)) == false);
        CHECK(isValidBST(mk(2, mk(1, NULL, NULL), mk(2, NULL, NULL))) == false);
    }
    {
        struct TreeNode *deep = mk(10, mk(5, NULL, NULL), mk(15, mk(6, NULL, NULL), mk(20, NULL, NULL)));
        CHECK(isValidBST(deep) == false);
        CHECK(isValidBST(mk(1, NULL, mk(2, NULL, mk(3, NULL, NULL)))) == true);
        CHECK(isValidBST(mk(3, mk(2, mk(1, NULL, NULL), NULL), NULL)) == true);
        CHECK(isValidBST(mk(3, NULL, mk(2, NULL, mk(1, NULL, NULL)))) == false);
        CHECK(isValidBST(mk(3, mk(2, mk(4, NULL, NULL), NULL), NULL)) == false);
    }
    printf("validate_bst: OK\n");
    return 0;
}
