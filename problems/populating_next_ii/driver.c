#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static struct Node *mk(int v, struct Node *l, struct Node *r) {
    struct Node *n = malloc(sizeof(struct Node));
    n->val = v;
    n->left = l;
    n->right = r;
    n->next = NULL;
    return n;
}

int main(void) {
    {
        /* [1,2,3,4,5,null,7] -> next pointers by level */
        struct Node *four = mk(4, NULL, NULL);
        struct Node *five = mk(5, NULL, NULL);
        struct Node *seven = mk(7, NULL, NULL);
        struct Node *two = mk(2, four, five);
        struct Node *three = mk(3, NULL, seven);
        struct Node *one = mk(1, two, three);
        struct Node *r = connect(one);
        CHECK(r == one);
        CHECK(r->next == NULL);
        CHECK(r->left->next == r->right);
        CHECK(r->right->next == NULL);
        CHECK(r->left->left->next == r->left->right);
        CHECK(r->left->right->next == r->right->right);
        CHECK(r->right->right->next == NULL);
    }
    {
        CHECK(connect(NULL) == NULL);
        struct Node *solo = mk(9, NULL, NULL);
        struct Node *rs = connect(solo);
        CHECK(rs == solo);
        CHECK(rs->next == NULL);
    }
    {
        /* left-skewed: 1 -> 2 -> 3 */
        struct Node *n3 = mk(3, NULL, NULL);
        struct Node *n2 = mk(2, n3, NULL);
        struct Node *n1 = mk(1, n2, NULL);
        connect(n1);
        CHECK(n1->next == NULL);
        CHECK(n2->next == NULL);
        CHECK(n3->next == NULL);
    }
    {
        /* 1 / (2,3) / (4 under 2, 6 under 3) */
        struct Node *c4 = mk(4, NULL, NULL);
        struct Node *c6 = mk(6, NULL, NULL);
        struct Node *b2 = mk(2, c4, NULL);
        struct Node *b3 = mk(3, c6, NULL);
        struct Node *b1 = mk(1, b2, b3);
        connect(b1);
        CHECK(b2->next == b3);
        CHECK(c4->next == c6);
        CHECK(c6->next == NULL);
    }
    printf("populating_next_ii: OK\n");
    return 0;
}
