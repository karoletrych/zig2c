#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        /* [[0,1],[1,0]] -> one internal node with four leaf children */
        int r0[2] = { 0, 1 };
        int r1[2] = { 1, 0 };
        int *g[2] = { r0, r1 };
        struct Node *q = construct(g, 2, NULL);
        CHECK(q != NULL);
        CHECK(q->isLeaf == false);
        CHECK(q->val == true);
        CHECK(q->topLeft->isLeaf && q->topLeft->val == false);
        CHECK(q->topRight->isLeaf && q->topRight->val == true);
        CHECK(q->bottomLeft->isLeaf && q->bottomLeft->val == true);
        CHECK(q->bottomRight->isLeaf && q->bottomRight->val == false);
        CHECK(q->topLeft->topLeft == NULL);
        CHECK(q->bottomRight->bottomRight == NULL);
    }
    {
        /* all ones -> a single leaf */
        int r0[2] = { 1, 1 };
        int r1[2] = { 1, 1 };
        int *g[2] = { r0, r1 };
        struct Node *q = construct(g, 2, NULL);
        CHECK(q->isLeaf == true);
        CHECK(q->val == true);
        CHECK(q->topLeft == NULL && q->topRight == NULL && q->bottomLeft == NULL && q->bottomRight == NULL);
    }
    {
        /* all zeros -> a single leaf with val false */
        int r0[2] = { 0, 0 };
        int r1[2] = { 0, 0 };
        int *g[2] = { r0, r1 };
        struct Node *q = construct(g, 2, NULL);
        CHECK(q->isLeaf == true);
        CHECK(q->val == false);
    }
    {
        /* 4x4 quadrants: TL all 1, TR all 0, BL all 0, BR all 1 */
        int r0[4] = { 1, 1, 0, 0 };
        int r1[4] = { 1, 1, 0, 0 };
        int r2[4] = { 0, 0, 1, 1 };
        int r3[4] = { 0, 0, 1, 1 };
        int *g[4] = { r0, r1, r2, r3 };
        struct Node *q = construct(g, 4, NULL);
        CHECK(q->isLeaf == false);
        CHECK(q->topLeft->isLeaf && q->topLeft->val == true);
        CHECK(q->topRight->isLeaf && q->topRight->val == false);
        CHECK(q->bottomLeft->isLeaf && q->bottomLeft->val == false);
        CHECK(q->bottomRight->isLeaf && q->bottomRight->val == true);
    }
    {
        /* 1x1 grid is always a leaf */
        int s0[1] = { 1 };
        int *sg[1] = { s0 };
        struct Node *q = construct(sg, 1, NULL);
        CHECK(q->isLeaf == true && q->val == true);
        CHECK(construct(NULL, 0, NULL) == NULL);
    }
    printf("construct_quad_tree: OK\n");
    return 0;
}
