#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static ListNode *mk(int *vals, int n) {
    ListNode *head = NULL;
    for (int i = n - 1; i >= 0; i--) {
        ListNode *nd = malloc(sizeof(ListNode));
        nd->val = vals[i];
        nd->next = head;
        head = nd;
    }
    return head;
}

static int same(ListNode *h, int *want, int n) {
    int k = 0;
    for (ListNode *c = h; c; c = c->next) {
        if (k >= n || c->val != want[k]) return 0;
        k++;
    }
    return k == n;
}

int main(void) {
    int a1[5] = { 1, 2, 3, 4, 5 };
    int w1[4] = { 1, 2, 4, 5 };
    CHECK(same(deleteMiddle(mk(a1, 5)), w1, 4));

    int a2[4] = { 1, 2, 3, 4 };
    int w2[3] = { 1, 2, 4 };
    CHECK(same(deleteMiddle(mk(a2, 4)), w2, 3));

    int a3[3] = { 1, 2, 3 };
    int w3[2] = { 1, 3 };
    CHECK(same(deleteMiddle(mk(a3, 3)), w3, 2));

    int a4[2] = { 1, 2 };
    int w4[1] = { 1 };
    CHECK(same(deleteMiddle(mk(a4, 2)), w4, 1));

    int a5[1] = { 1 };
    CHECK(deleteMiddle(mk(a5, 1)) == NULL);

    printf("delete_middle_node: OK\n");
    return 0;
}
