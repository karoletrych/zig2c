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
    struct TreeNode *t1 = mk(1, mk(7, mk(7, NULL, NULL), mk(-8, NULL, NULL)), mk(0, NULL, NULL));
    CHECK(maxLevelSum(t1) == 2);

    struct TreeNode *t2 = mk(989, NULL, mk(10250, mk(98693, NULL, mk(-32127, NULL, NULL)), mk(-89388, NULL, NULL)));
    CHECK(maxLevelSum(t2) == 2);

    CHECK(maxLevelSum(mk(1, NULL, NULL)) == 1);
    CHECK(maxLevelSum(mk(1, mk(1, NULL, NULL), mk(0, NULL, NULL))) == 1);
    CHECK(maxLevelSum(NULL) == 0);

    printf("max_level_sum: OK\n");
    return 0;
}
