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
    struct TreeNode *t1 = mk(10, mk(5, mk(3, mk(3, NULL, NULL), mk(-2, NULL, NULL)), mk(2, NULL, mk(1, NULL, NULL))),
                                 mk(-3, NULL, mk(11, NULL, NULL)));
    CHECK(pathSum(t1, 8) == 3);

    struct TreeNode *t2 = mk(5, mk(4, mk(11, mk(7, NULL, NULL), mk(2, NULL, NULL)), NULL),
                                mk(8, mk(13, NULL, NULL), mk(4, mk(5, NULL, NULL), mk(1, NULL, NULL))));
    CHECK(pathSum(t2, 22) == 3);

    CHECK(pathSum(mk(1, NULL, NULL), 1) == 1);
    CHECK(pathSum(mk(1, NULL, NULL), 0) == 0);
    CHECK(pathSum(NULL, 5) == 0);

    struct TreeNode *t3 = mk(1, mk(-2, NULL, NULL), mk(-3, NULL, NULL));
    CHECK(pathSum(t3, -1) == 1);
    CHECK(pathSum(mk(1, mk(2, mk(3, NULL, NULL), NULL), NULL), 3) == 2);

    printf("path_sum_iii: OK\n");
    return 0;
}
