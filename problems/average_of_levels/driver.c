#include "leetcode.c"
#include <math.h>

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)
#define CHECK_NEAR(a, b) CHECK(fabs((a) - (b)) < 1e-9)

static struct TreeNode *mk(int v, struct TreeNode *l, struct TreeNode *r) {
    struct TreeNode *n = malloc(sizeof(struct TreeNode));
    n->val = v;
    n->left = l;
    n->right = r;
    return n;
}

int main(void) {
    {
        /* [3,9,20,null,null,15,7] -> [3, 14.5, 11] */
        int rs = 0;
        struct TreeNode *t = mk(3, mk(9, NULL, NULL), mk(20, mk(15, NULL, NULL), mk(7, NULL, NULL)));
        double *r = averageOfLevels(t, &rs);
        CHECK(rs == 3);
        CHECK_NEAR(r[0], 3.0);
        CHECK_NEAR(r[1], 14.5);
        CHECK_NEAR(r[2], 11.0);
    }
    {
        int rs = 0;
        CHECK(averageOfLevels(NULL, &rs) == NULL);
        CHECK(rs == 0);
    }
    {
        int rs = 0;
        double *solo = averageOfLevels(mk(7, NULL, NULL), &rs);
        CHECK(rs == 1);
        CHECK_NEAR(solo[0], 7.0);
    }
    {
        int rs = 0;
        double *t = averageOfLevels(mk(1, mk(-2, NULL, NULL), mk(3, NULL, NULL)), &rs);
        CHECK(rs == 2);
        CHECK_NEAR(t[0], 1.0);
        CHECK_NEAR(t[1], 0.5);
    }
    {
        int rs = 0;
        double *sk = averageOfLevels(mk(1, mk(2, mk(3, NULL, NULL), NULL), NULL), &rs);
        CHECK(rs == 3);
        CHECK_NEAR(sk[0], 1.0);
        CHECK_NEAR(sk[1], 2.0);
        CHECK_NEAR(sk[2], 3.0);
    }
    printf("average_of_levels: OK\n");
    return 0;
}
