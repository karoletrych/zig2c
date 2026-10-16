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
        int a[6] = { 1, 4, 3, 2, 5, 2 }, w[6] = { 1, 2, 2, 4, 3, 5 };
        CHECK(listEq(partition(mkList(a, 6), 3), w, 6));
    }
    {
        int a[2] = { 2, 1 }, w[2] = { 1, 2 };
        CHECK(listEq(partition(mkList(a, 2), 2), w, 2));
    }
    CHECK(partition(NULL, 5) == NULL);
    {
        int a[1] = { 1 };
        CHECK(listEq(partition(mkList(a, 1), 2), a, 1));
    }
    {
        int a[1] = { 5 };
        CHECK(listEq(partition(mkList(a, 1), 2), a, 1));
    }
    {
        /* nothing is less than x */
        int a[6] = { 1, 4, 3, 2, 5, 2 };
        CHECK(listEq(partition(mkList(a, 6), 0), a, 6));
    }
    {
        /* everything is less than x */
        int a[6] = { 1, 4, 3, 2, 5, 2 };
        CHECK(listEq(partition(mkList(a, 6), 10), a, 6));
    }
    {
        /* already partitioned */
        int a[6] = { 1, 2, 2, 4, 3, 5 };
        CHECK(listEq(partition(mkList(a, 6), 3), a, 6));
    }
    {
        /* all equal to x */
        int a[3] = { 3, 3, 3 };
        CHECK(listEq(partition(mkList(a, 3), 3), a, 3));
    }
    {
        /* negative values */
        int a[4] = { -1, 2, -3, 4 }, w[4] = { -1, -3, 2, 4 };
        CHECK(listEq(partition(mkList(a, 4), 0), w, 4));
    }
    printf("partition_list: OK\n");
    return 0;
}
