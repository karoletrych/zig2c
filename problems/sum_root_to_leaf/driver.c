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
        /* [1,2,3] -> 12 + 13 = 25 */
        CHECK(sumNumbers(mk(1, mk(2, NULL, NULL), mk(3, NULL, NULL))) == 25);
    }
    {
        /* [4,9,0,5,1] -> 495 + 491 + 40 = 1026 */
        struct TreeNode *t = mk(4, mk(9, mk(5, NULL, NULL), mk(1, NULL, NULL)), mk(0, NULL, NULL));
        CHECK(sumNumbers(t) == 1026);
    }
    {
        CHECK(sumNumbers(NULL) == 0);
        CHECK(sumNumbers(mk(5, NULL, NULL)) == 5);
        CHECK(sumNumbers(mk(0, NULL, NULL)) == 0);
        CHECK(sumNumbers(mk(1, mk(0, NULL, NULL), NULL)) == 10);
        CHECK(sumNumbers(mk(1, mk(0, NULL, NULL), mk(1, NULL, NULL))) == 21);
    }
    {
        struct TreeNode *sk = mk(1, mk(2, mk(3, NULL, NULL), NULL), NULL);
        CHECK(sumNumbers(sk) == 123);
        struct TreeNode *mixed = mk(1, mk(1, NULL, NULL), mk(1, mk(2, NULL, NULL), mk(1, NULL, NULL)));
        CHECK(sumNumbers(mixed) == 234);
    }
    printf("sum_root_to_leaf: OK\n");
    return 0;
}
