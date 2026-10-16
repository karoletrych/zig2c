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
        int a[5] = { 1, 2, 3, 4, 5 }, w[4] = { 1, 2, 3, 5 };
        CHECK(listEq(removeNthFromEnd(mkList(a, 5), 2), w, 4));
    }
    {
        int a[1] = { 1 };
        CHECK(listEq(removeNthFromEnd(mkList(a, 1), 1), NULL, 0));
    }
    {
        int a[2] = { 1, 2 }, w[1] = { 1 };
        CHECK(listEq(removeNthFromEnd(mkList(a, 2), 1), w, 1));
    }
    {
        /* remove the head */
        int a[5] = { 1, 2, 3, 4, 5 }, w[4] = { 2, 3, 4, 5 };
        CHECK(listEq(removeNthFromEnd(mkList(a, 5), 5), w, 4));
    }
    {
        /* remove the tail */
        int a[3] = { 1, 2, 3 }, w[2] = { 1, 2 };
        CHECK(listEq(removeNthFromEnd(mkList(a, 3), 1), w, 2));
    }
    {
        /* two nodes, remove the second */
        int a[2] = { 1, 2 }, w[1] = { 2 };
        CHECK(listEq(removeNthFromEnd(mkList(a, 2), 2), w, 1));
    }
    {
        /* three nodes, remove the middle */
        int a[3] = { 1, 2, 3 }, w[2] = { 1, 3 };
        CHECK(listEq(removeNthFromEnd(mkList(a, 3), 2), w, 2));
    }
    {
        int a[3] = { -5, -4, -3 }, w[2] = { -4, -3 };
        CHECK(listEq(removeNthFromEnd(mkList(a, 3), 3), w, 2));
    }
    printf("remove_nth_from_end: OK\n");
    return 0;
}
