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
    struct TreeNode *t = mk(3, mk(1, mk(3, NULL, NULL), NULL), mk(4, mk(1, NULL, NULL), mk(5, NULL, NULL)));
    CHECK(goodNodes(t) == 4);

    struct TreeNode *t2 = mk(3, mk(3, mk(4, NULL, NULL), mk(2, NULL, NULL)), NULL);
    CHECK(goodNodes(t2) == 3);

    CHECK(goodNodes(mk(1, NULL, NULL)) == 1);
    CHECK(goodNodes(NULL) == 0);
    CHECK(goodNodes(mk(5, mk(4, mk(3, NULL, NULL), NULL), NULL)) == 1);

    printf("good_nodes: OK\n");
    return 0;
}
