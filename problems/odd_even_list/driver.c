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
    int w1[5] = { 1, 3, 5, 2, 4 };
    CHECK(same(oddEvenList(mk(a1, 5)), w1, 5));

    int a2[7] = { 2, 1, 3, 5, 6, 4, 7 };
    int w2[7] = { 2, 3, 6, 7, 1, 5, 4 };
    CHECK(same(oddEvenList(mk(a2, 7)), w2, 7));

    int a3[2] = { 1, 2 };
    int w3[2] = { 1, 2 };
    CHECK(same(oddEvenList(mk(a3, 2)), w3, 2));

    int a4[1] = { 1 };
    int w4[1] = { 1 };
    CHECK(same(oddEvenList(mk(a4, 1)), w4, 1));

    CHECK(oddEvenList(NULL) == NULL);

    printf("odd_even_list: OK\n");
    return 0;
}
