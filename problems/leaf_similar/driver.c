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
    struct TreeNode *t1 = mk(3, mk(5, mk(6, NULL, NULL), mk(2, mk(7, NULL, NULL), mk(4, NULL, NULL))),
                                mk(1, mk(9, NULL, NULL), mk(8, NULL, NULL)));
    struct TreeNode *t2 = mk(3, mk(5, mk(6, NULL, NULL), mk(7, NULL, NULL)),
                                mk(1, mk(4, NULL, NULL), mk(2, mk(9, NULL, NULL), mk(8, NULL, NULL))));
    CHECK(leafSimilar(t1, t2) == true);

    struct TreeNode *t3 = mk(1, mk(2, NULL, NULL), mk(3, NULL, NULL));
    struct TreeNode *t4 = mk(1, mk(3, NULL, NULL), mk(2, NULL, NULL));
    CHECK(leafSimilar(t3, t4) == false);

    CHECK(leafSimilar(mk(1, NULL, NULL), mk(1, NULL, NULL)) == true);
    CHECK(leafSimilar(mk(1, NULL, NULL), mk(2, NULL, NULL)) == false);
    CHECK(leafSimilar(NULL, NULL) == true);
    CHECK(leafSimilar(NULL, mk(1, NULL, NULL)) == false);

    printf("leaf_similar: OK\n");
    return 0;
}
