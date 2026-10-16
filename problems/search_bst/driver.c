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
    struct TreeNode *t = mk(4, mk(2, mk(1, NULL, NULL), mk(3, NULL, NULL)), mk(7, NULL, NULL));
    struct TreeNode *r = searchBST(t, 2);
    CHECK(r != NULL);
    CHECK(r->val == 2);
    CHECK(r->left->val == 1);
    CHECK(r->right->val == 3);

    CHECK(searchBST(t, 5) == NULL);
    CHECK(searchBST(t, 4) == t);

    struct TreeNode *s = mk(7, NULL, NULL);
    CHECK(searchBST(s, 7) == s);
    CHECK(searchBST(s, 1) == NULL);
    CHECK(searchBST(NULL, 1) == NULL);

    printf("search_bst: OK\n");
    return 0;
}
