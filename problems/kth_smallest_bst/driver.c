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
        /* [3,1,4,null,2] */
        struct TreeNode *t = mk(3, mk(1, NULL, mk(2, NULL, NULL)), mk(4, NULL, NULL));
        CHECK(kthSmallest(t, 1) == 1);
        CHECK(kthSmallest(t, 2) == 2);
        CHECK(kthSmallest(t, 3) == 3);
        CHECK(kthSmallest(t, 4) == 4);
    }
    {
        /* [5,3,6,2,4,null,null,1] */
        struct TreeNode *t = mk(5, mk(3, mk(2, mk(1, NULL, NULL), NULL), mk(4, NULL, NULL)), mk(6, NULL, NULL));
        CHECK(kthSmallest(t, 1) == 1);
        CHECK(kthSmallest(t, 3) == 3);
        CHECK(kthSmallest(t, 6) == 6);
        CHECK(kthSmallest(mk(7, NULL, NULL), 1) == 7);
    }
    {
        struct TreeNode *rsk = mk(1, NULL, mk(2, NULL, mk(3, NULL, NULL)));
        CHECK(kthSmallest(rsk, 2) == 2);
        CHECK(kthSmallest(rsk, 3) == 3);
        struct TreeNode *lsk = mk(3, mk(2, mk(1, NULL, NULL), NULL), NULL);
        CHECK(kthSmallest(lsk, 1) == 1);
        CHECK(kthSmallest(lsk, 3) == 3);
    }
    printf("kth_smallest_bst: OK\n");
    return 0;
}
