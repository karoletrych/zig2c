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
    int rs = 0;
    int *r;

    struct TreeNode *t = mk(1, mk(2, NULL, mk(5, NULL, NULL)), mk(3, NULL, mk(4, NULL, NULL)));
    r = rightSideView(t, &rs);
    CHECK(rs == 3);
    CHECK(r[0] == 1 && r[1] == 3 && r[2] == 4);

    r = rightSideView(mk(1, NULL, mk(3, NULL, NULL)), &rs);
    CHECK(rs == 2);
    CHECK(r[0] == 1 && r[1] == 3);

    r = rightSideView(mk(1, mk(2, NULL, NULL), NULL), &rs);
    CHECK(rs == 2);
    CHECK(r[1] == 2);

    r = rightSideView(mk(7, NULL, NULL), &rs);
    CHECK(rs == 1);
    CHECK(r[0] == 7);

    rightSideView(NULL, &rs);
    CHECK(rs == 0);

    printf("right_side_view: OK\n");
    return 0;
}
