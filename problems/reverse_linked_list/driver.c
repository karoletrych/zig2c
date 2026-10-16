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
    int w1[5] = { 5, 4, 3, 2, 1 };
    CHECK(same(reverseList(mk(a1, 5)), w1, 5));

    int a2[2] = { 1, 2 };
    int w2[2] = { 2, 1 };
    CHECK(same(reverseList(mk(a2, 2)), w2, 2));

    int a3[1] = { 1 };
    int w3[1] = { 1 };
    CHECK(same(reverseList(mk(a3, 1)), w3, 1));

    CHECK(reverseList(NULL) == NULL);

    printf("reverse_linked_list: OK\n");
    return 0;
}
