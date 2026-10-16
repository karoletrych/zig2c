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
        int a[5] = { 1, 2, 3, 4, 5 }, w[5] = { 1, 4, 3, 2, 5 };
        CHECK(listEq(reverseBetween(mkList(a, 5), 2, 4), w, 5));
    }
    {
        int a[1] = { 5 }, w[1] = { 5 };
        CHECK(listEq(reverseBetween(mkList(a, 1), 1, 1), w, 1));
    }
    {
        /* left == right */
        int a[3] = { 1, 2, 3 };
        CHECK(listEq(reverseBetween(mkList(a, 3), 2, 2), a, 3));
    }
    {
        /* whole list */
        int a[4] = { 1, 2, 3, 4 }, w[4] = { 4, 3, 2, 1 };
        CHECK(listEq(reverseBetween(mkList(a, 4), 1, 4), w, 4));
    }
    {
        /* two-element prefix */
        int a[2] = { 3, 5 }, w[2] = { 5, 3 };
        CHECK(listEq(reverseBetween(mkList(a, 2), 1, 2), w, 2));
    }
    {
        /* last two */
        int a[3] = { 1, 2, 3 }, w[3] = { 1, 3, 2 };
        CHECK(listEq(reverseBetween(mkList(a, 3), 2, 3), w, 3));
    }
    {
        /* negative values */
        int a[4] = { -1, -2, -3, -4 }, w[4] = { -3, -2, -1, -4 };
        CHECK(listEq(reverseBetween(mkList(a, 4), 1, 3), w, 4));
    }
    CHECK(reverseBetween(NULL, 1, 1) == NULL);
    printf("reverse_linked_list_ii: OK\n");
    return 0;
}
