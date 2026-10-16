#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static struct TreeNode *mk(int v, struct TreeNode *l, struct TreeNode *r) {
    struct TreeNode *n = malloc(sizeof(struct TreeNode));
    n->val = v;
    n->left = l;
    n->right = r;
    return n;
}

static int collect(struct TreeNode *root, int *out) {
    int n = 0;
    struct TreeNode *cur = root;
    while (cur != NULL) {
        out[n++] = cur->val;
        cur = cur->right;
    }
    return n;
}

static int all_left_null(struct TreeNode *root) {
    struct TreeNode *cur = root;
    while (cur != NULL) {
        if (cur->left != NULL) return 0;
        cur = cur->right;
    }
    return 1;
}

int main(void) {
    {
        /* [1,2,5,3,4,null,6] -> 1,2,3,4,5,6 */
        struct TreeNode *t = mk(1, mk(2, mk(3, NULL, NULL), mk(4, NULL, NULL)), mk(5, NULL, mk(6, NULL, NULL)));
        int buf[16];
        flatten(t);
        CHECK(collect(t, buf) == 6);
        int i;
        for (i = 0; i < 6; i++) CHECK(buf[i] == i + 1);
        CHECK(all_left_null(t));
    }
    {
        flatten(NULL);
        struct TreeNode *solo = mk(1, NULL, NULL);
        flatten(solo);
        CHECK(solo->val == 1 && solo->left == NULL && solo->right == NULL);
    }
    {
        /* left-skewed */
        struct TreeNode *lsk = mk(1, mk(2, mk(3, NULL, NULL), NULL), NULL);
        int buf[8];
        flatten(lsk);
        CHECK(collect(lsk, buf) == 3);
        CHECK(buf[0] == 1 && buf[1] == 2 && buf[2] == 3);
    }
    {
        /* right-skewed */
        struct TreeNode *rsk = mk(1, NULL, mk(2, NULL, mk(3, NULL, NULL)));
        int buf[8];
        flatten(rsk);
        CHECK(collect(rsk, buf) == 3);
        CHECK(buf[0] == 1 && buf[1] == 2 && buf[2] == 3);
        CHECK(all_left_null(rsk));
    }
    {
        /* mixed */
        struct TreeNode *mix = mk(1, mk(2, mk(3, NULL, NULL), NULL), mk(4, NULL, NULL));
        int buf[8];
        int want[4] = { 1, 2, 3, 4 };
        flatten(mix);
        CHECK(collect(mix, buf) == 4);
        int i;
        for (i = 0; i < 4; i++) CHECK(buf[i] == want[i]);
    }
    printf("flatten_tree: OK\n");
    return 0;
}
