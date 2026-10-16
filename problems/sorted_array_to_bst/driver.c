#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static int inorder_ok(struct TreeNode *node, int *nums, int n, int *idx) {
    if (node == NULL) return 1;
    if (!inorder_ok(node->left, nums, n, idx)) return 0;
    if (*idx >= n || node->val != nums[*idx]) return 0;
    *idx += 1;
    return inorder_ok(node->right, nums, n, idx);
}

static int height(struct TreeNode *node) {
    if (node == NULL) return 0;
    int l = height(node->left);
    int r = height(node->right);
    return 1 + (l > r ? l : r);
}

static int balanced(struct TreeNode *node) {
    if (node == NULL) return 1;
    int dl = height(node->left);
    int dr = height(node->right);
    if (dl - dr > 1 || dr - dl > 1) return 0;
    return balanced(node->left) && balanced(node->right);
}

int main(void) {
    {
        /* [-10,-3,0,5,9] */
        int nums[5] = { -10, -3, 0, 5, 9 };
        struct TreeNode *root = sortedArrayToBST(nums, 5);
        CHECK(root != NULL);
        CHECK(root->val == 0); /* the middle element becomes the root */
        int idx = 0;
        CHECK(inorder_ok(root, nums, 5, &idx));
        CHECK(idx == 5);
        CHECK(balanced(root));
    }
    {
        CHECK(sortedArrayToBST(NULL, 0) == NULL);
        int one[1] = { 42 };
        struct TreeNode *r1 = sortedArrayToBST(one, 1);
        CHECK(r1 != NULL && r1->val == 42 && r1->left == NULL && r1->right == NULL);
    }
    {
        int two[2] = { 1, 2 };
        struct TreeNode *r2 = sortedArrayToBST(two, 2);
        int idx = 0;
        CHECK(inorder_ok(r2, two, 2, &idx));
        CHECK(idx == 2);
        CHECK(balanced(r2));
    }
    {
        int many[8] = { 1, 2, 3, 4, 5, 6, 7, 8 };
        struct TreeNode *r3 = sortedArrayToBST(many, 8);
        int idx = 0;
        CHECK(inorder_ok(r3, many, 8, &idx));
        CHECK(idx == 8);
        CHECK(balanced(r3));
        CHECK(height(r3) <= 4);
    }
    printf("sorted_array_to_bst: OK\n");
    return 0;
}
