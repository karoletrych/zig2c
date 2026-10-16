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
        CHECK(maxPathSum(mk(1, mk(2, NULL, NULL), mk(3, NULL, NULL))) == 6);
        struct TreeNode *t = mk(-10, mk(9, NULL, NULL), mk(20, mk(15, NULL, NULL), mk(7, NULL, NULL)));
        CHECK(maxPathSum(t) == 42);
    }
    {
        CHECK(maxPathSum(mk(-3, NULL, NULL)) == -3);
        CHECK(maxPathSum(mk(0, NULL, NULL)) == 0);
        CHECK(maxPathSum(mk(2, mk(-1, NULL, NULL), NULL)) == 2);
        CHECK(maxPathSum(mk(-2, mk(-1, NULL, NULL), NULL)) == -1);
        CHECK(maxPathSum(mk(1, mk(-2, NULL, NULL), mk(-3, NULL, NULL))) == 1);
    }
    {
        struct TreeNode *t = mk(1, mk(2, mk(4, NULL, NULL), NULL), mk(3, NULL, NULL));
        CHECK(maxPathSum(t) == 10);
        struct TreeNode *sk = mk(1, mk(2, mk(3, NULL, NULL), NULL), NULL);
        CHECK(maxPathSum(sk) == 6);
        struct TreeNode *neg = mk(-5, mk(10, mk(4, NULL, NULL), mk(3, NULL, NULL)), mk(-1, NULL, NULL));
        CHECK(maxPathSum(neg) == 17);
    }
    printf("max_path_sum: OK\n");
    return 0;
}
