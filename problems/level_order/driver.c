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
        /* [3,9,20,null,null,15,7] -> [[3],[9,20],[15,7]] */
        int rs = 0;
        int *cb = NULL;
        struct TreeNode *t = mk(3, mk(9, NULL, NULL), mk(20, mk(15, NULL, NULL), mk(7, NULL, NULL)));
        int **r = levelOrder(t, &rs, &cb);
        CHECK(rs == 3);
        CHECK(cb[0] == 1 && cb[1] == 2 && cb[2] == 2);
        CHECK(r[0][0] == 3);
        CHECK(r[1][0] == 9 && r[1][1] == 20);
        CHECK(r[2][0] == 15 && r[2][1] == 7);
    }
    {
        int rs = 0;
        int *cb = NULL;
        int **r = levelOrder(mk(1, NULL, NULL), &rs, &cb);
        CHECK(rs == 1);
        CHECK(cb[0] == 1);
        CHECK(r[0][0] == 1);
    }
    {
        int rs = 0;
        int *cb = NULL;
        int **r = levelOrder(NULL, &rs, &cb);
        CHECK(rs == 0);
        (void)r;
    }
    {
        /* left-skewed */
        int rs = 0;
        int *cb = NULL;
        int **sk = levelOrder(mk(1, mk(2, mk(3, NULL, NULL), NULL), NULL), &rs, &cb);
        CHECK(rs == 3);
        CHECK(cb[0] == 1 && cb[1] == 1 && cb[2] == 1);
        CHECK(sk[0][0] == 1 && sk[1][0] == 2 && sk[2][0] == 3);
    }
    {
        /* ragged last level: [1,2,3,4] */
        int rs = 0;
        int *cb = NULL;
        int **rg = levelOrder(mk(1, mk(2, mk(4, NULL, NULL), NULL), mk(3, NULL, NULL)), &rs, &cb);
        CHECK(rs == 3);
        CHECK(cb[0] == 1 && cb[1] == 2 && cb[2] == 1);
        CHECK(rg[2][0] == 4);
    }
    printf("level_order: OK\n");
    return 0;
}
