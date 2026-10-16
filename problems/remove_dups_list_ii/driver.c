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
        int a[7] = { 1, 2, 3, 3, 4, 4, 5 }, w[3] = { 1, 2, 5 };
        CHECK(listEq(deleteDuplicates(mkList(a, 7)), w, 3));
    }
    {
        int a[5] = { 1, 1, 1, 2, 3 }, w[2] = { 2, 3 };
        CHECK(listEq(deleteDuplicates(mkList(a, 5)), w, 2));
    }
    CHECK(deleteDuplicates(NULL) == NULL);
    {
        int a[1] = { 1 };
        CHECK(listEq(deleteDuplicates(mkList(a, 1)), a, 1));
    }
    {
        int a[2] = { 1, 1 };
        CHECK(listEq(deleteDuplicates(mkList(a, 2)), NULL, 0));
    }
    {
        int a[4] = { 1, 1, 2, 2 };
        CHECK(listEq(deleteDuplicates(mkList(a, 4)), NULL, 0));
    }
    {
        int a[3] = { 1, 2, 3 };
        CHECK(listEq(deleteDuplicates(mkList(a, 3)), a, 3));
    }
    {
        /* leading run */
        int a[3] = { 1, 1, 2 }, w[1] = { 2 };
        CHECK(listEq(deleteDuplicates(mkList(a, 3)), w, 1));
    }
    {
        /* trailing run */
        int a[3] = { 1, 2, 2 }, w[1] = { 1 };
        CHECK(listEq(deleteDuplicates(mkList(a, 3)), w, 1));
    }
    {
        int a[6] = { -3, -1, -1, 0, 0, 2 }, w[2] = { -3, 2 };
        CHECK(listEq(deleteDuplicates(mkList(a, 6)), w, 2));
    }
    printf("remove_dups_list_ii: OK\n");
    return 0;
}
