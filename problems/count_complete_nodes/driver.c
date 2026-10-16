#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static struct TreeNode *mk(int v, struct TreeNode *l, struct TreeNode *r) {
    struct TreeNode *n = malloc(sizeof(struct TreeNode));
    n->val = v;
    n->left = l;
    n->right = r;
    return n;
}

/* A complete tree of n nodes, numbered 1..n in level order. */
static struct TreeNode *build_complete(int n, int idx) {
    if (idx > n) return NULL;
    struct TreeNode *node = malloc(sizeof(struct TreeNode));
    node->val = idx;
    node->left = build_complete(n, idx * 2);
    node->right = build_complete(n, idx * 2 + 1);
    return node;
}

int main(void) {
    {
        /* [1,2,3,4,5,6] -> 6 */
        struct TreeNode *t = mk(1, mk(2, mk(4, NULL, NULL), mk(5, NULL, NULL)), mk(3, mk(6, NULL, NULL), NULL));
        CHECK(countNodes(t) == 6);
        CHECK(countNodes(NULL) == 0);
        CHECK(countNodes(mk(1, NULL, NULL)) == 1);
    }
    {
        int n;
        for (n = 0; n <= 40; n++) CHECK(countNodes(build_complete(n, 1)) == n);
        CHECK(countNodes(build_complete(31, 1)) == 31);
    }
    printf("count_complete_nodes: OK\n");
    return 0;
}
