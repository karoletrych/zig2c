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
        /* [7,3,15,null,null,9,20] -> 3,7,9,15,20 */
        struct TreeNode *root = mk(7, mk(3, NULL, NULL), mk(15, mk(9, NULL, NULL), mk(20, NULL, NULL)));
        BSTIterator *it = bSTIteratorCreate(root);
        CHECK(bSTIteratorHasNext(it) == true);
        CHECK(bSTIteratorNext(it) == 3);
        CHECK(bSTIteratorNext(it) == 7);
        CHECK(bSTIteratorHasNext(it) == true);
        CHECK(bSTIteratorNext(it) == 9);
        CHECK(bSTIteratorNext(it) == 15);
        CHECK(bSTIteratorNext(it) == 20);
        CHECK(bSTIteratorHasNext(it) == false);
        free(it->vals);
        free(it);
    }
    {
        BSTIterator *solo = bSTIteratorCreate(mk(42, NULL, NULL));
        CHECK(bSTIteratorHasNext(solo) == true);
        CHECK(bSTIteratorNext(solo) == 42);
        CHECK(bSTIteratorHasNext(solo) == false);
        free(solo->vals);
        free(solo);
    }
    {
        BSTIterator *rsk = bSTIteratorCreate(mk(1, NULL, mk(2, NULL, mk(3, NULL, NULL))));
        CHECK(bSTIteratorNext(rsk) == 1);
        CHECK(bSTIteratorNext(rsk) == 2);
        CHECK(bSTIteratorNext(rsk) == 3);
        CHECK(bSTIteratorHasNext(rsk) == false);
        free(rsk->vals);
        free(rsk);
    }
    {
        BSTIterator *lsk = bSTIteratorCreate(mk(3, mk(2, mk(1, NULL, NULL), NULL), NULL));
        CHECK(bSTIteratorNext(lsk) == 1);
        CHECK(bSTIteratorNext(lsk) == 2);
        CHECK(bSTIteratorNext(lsk) == 3);
        CHECK(bSTIteratorHasNext(lsk) == false);
        free(lsk->vals);
        free(lsk);
    }
    printf("bst_iterator: OK\n");
    return 0;
}
