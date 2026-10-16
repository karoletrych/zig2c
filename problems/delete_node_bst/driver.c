#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static struct TreeNode *mk(int v, struct TreeNode *l, struct TreeNode *r) {
    struct TreeNode *n = malloc(sizeof(struct TreeNode));
    n->val = v;
    n->left = l;
    n->right = r;
    return n;
}

static int inorder(struct TreeNode *node, int *out) {
    if (node == NULL) return 0;
    int k = inorder(node->left, out);
    out[k++] = node->val;
    return k + inorder(node->right, out + k);
}

static void checkTree(struct TreeNode *root, const int *want, int n) {
    int buf[32];
    int c = inorder(root, buf);
    if (c != n) { printf("FAIL: tree size %d != %d\n", c, n); exit(1); }
    for (int i = 0; i < n; i++) {
        if (buf[i] != want[i]) {
            printf("FAIL: inorder[%d] = %d, want %d\n", i, buf[i], want[i]);
            exit(1);
        }
    }
}

int main(void) {
    struct TreeNode *t = mk(5, mk(3, mk(2, NULL, NULL), mk(4, NULL, NULL)), mk(6, NULL, mk(7, NULL, NULL)));

    t = deleteNode(t, 3);
    { const int w[] = {2, 4, 5, 6, 7}; checkTree(t, w, 5); }

    t = deleteNode(t, 0);
    { const int w[] = {2, 4, 5, 6, 7}; checkTree(t, w, 5); }

    t = deleteNode(t, 5);
    { const int w[] = {2, 4, 6, 7}; checkTree(t, w, 4); }

    t = deleteNode(t, 2);
    { const int w[] = {4, 6, 7}; checkTree(t, w, 3); }

    CHECK(deleteNode(mk(1, NULL, NULL), 1) == NULL);
    CHECK(deleteNode(NULL, 5) == NULL);
    { struct TreeNode *r = deleteNode(mk(1, NULL, mk(2, NULL, NULL)), 1);
      const int w[] = {2}; checkTree(r, w, 1); }

    printf("delete_node_bst: OK\n");
    return 0;
}
