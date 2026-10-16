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
        /* [5,4,8,11,null,13,4,7,2,null,null,null,1] */
        struct TreeNode *t = mk(5, mk(4, mk(11, mk(7, NULL, NULL), mk(2, NULL, NULL)), NULL), mk(8, mk(13, NULL, NULL), mk(4, NULL, mk(1, NULL, NULL))));
        CHECK(hasPathSum(t, 22) == true);
        CHECK(hasPathSum(t, 27) == true);
        CHECK(hasPathSum(t, 26) == true);
        CHECK(hasPathSum(t, 18) == true);
        CHECK(hasPathSum(t, 1) == false);
        CHECK(hasPathSum(t, 100) == false);
    }
    {
        CHECK(hasPathSum(NULL, 0) == false);
        CHECK(hasPathSum(NULL, 5) == false);
        CHECK(hasPathSum(mk(1, NULL, NULL), 1) == true);
        CHECK(hasPathSum(mk(1, NULL, NULL), 0) == false);
        CHECK(hasPathSum(mk(0, NULL, NULL), 0) == true);
    }
    {
        struct TreeNode *two = mk(1, mk(2, NULL, NULL), NULL);
        CHECK(hasPathSum(two, 3) == true);
        CHECK(hasPathSum(two, 1) == false);
        CHECK(hasPathSum(mk(-2, NULL, mk(-3, NULL, NULL)), -5) == true);
    }
    {
        struct TreeNode *sk = mk(1, mk(2, mk(3, NULL, NULL), NULL), NULL);
        CHECK(hasPathSum(sk, 6) == true);
        CHECK(hasPathSum(sk, 5) == false);
    }
    printf("path_sum: OK\n");
    return 0;
}
