#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static ListNode *mkList(const int *vals, int n) {
    ListNode *head = NULL;
    for (int i = n - 1; i >= 0; i--) {
        ListNode *nd = malloc(sizeof(ListNode));
        nd->val = vals[i];
        nd->next = head;
        head = nd;
    }
    return head;
}

static int listEq(ListNode *got, const int *want, int n) {
    int k = 0;
    for (ListNode *c = got; c; c = c->next) {
        if (k >= n || c->val != want[k]) return 0;
        k++;
    }
    return k == n;
}

int main(void) {
    {
        int a[5] = { 1, 2, 3, 4, 5 }, w[5] = { 2, 1, 4, 3, 5 };
        CHECK(listEq(reverseKGroup(mkList(a, 5), 2), w, 5));
    }
    {
        int a[5] = { 1, 2, 3, 4, 5 }, w[5] = { 3, 2, 1, 4, 5 };
        CHECK(listEq(reverseKGroup(mkList(a, 5), 3), w, 5));
    }
    {
        /* k == 1 and k == 0 are no-ops */
        int a[3] = { 1, 2, 3 };
        CHECK(listEq(reverseKGroup(mkList(a, 3), 1), a, 3));
        CHECK(listEq(reverseKGroup(mkList(a, 3), 0), a, 3));
    }
    CHECK(reverseKGroup(NULL, 2) == NULL);
    {
        int a[1] = { 7 };
        CHECK(listEq(reverseKGroup(mkList(a, 1), 2), a, 1));
    }
    {
        /* k larger than the list */
        int a[3] = { 1, 2, 3 };
        CHECK(listEq(reverseKGroup(mkList(a, 3), 9), a, 3));
    }
    {
        /* exact multiple of k */
        int a[6] = { 1, 2, 3, 4, 5, 6 }, w[6] = { 3, 2, 1, 6, 5, 4 };
        CHECK(listEq(reverseKGroup(mkList(a, 6), 3), w, 6));
    }
    {
        /* single full group */
        int a[3] = { 1, 2, 3 }, w[3] = { 3, 2, 1 };
        CHECK(listEq(reverseKGroup(mkList(a, 3), 3), w, 3));
    }
    {
        int a[5] = { 1, 2, 3, 4, 5 }, w[5] = { 5, 4, 3, 2, 1 };
        CHECK(listEq(reverseKGroup(mkList(a, 5), 5), w, 5));
    }
    printf("reverse_k_group: OK\n");
    return 0;
}
