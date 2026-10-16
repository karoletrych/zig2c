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
        /* 342 + 465 = 807 */
        int a[3] = { 2, 4, 3 }, b[3] = { 5, 6, 4 }, w[3] = { 7, 0, 8 };
        CHECK(listEq(addTwoNumbers(mkList(a, 3), mkList(b, 3)), w, 3));
    }
    {
        /* 0 + 0 = 0 */
        int a[1] = { 0 }, b[1] = { 0 }, w[1] = { 0 };
        CHECK(listEq(addTwoNumbers(mkList(a, 1), mkList(b, 1)), w, 1));
    }
    {
        /* 9999999 + 9999 = 10009998 */
        int a[7] = { 9, 9, 9, 9, 9, 9, 9 }, b[4] = { 9, 9, 9, 9 };
        int w[8] = { 8, 9, 9, 9, 0, 0, 0, 1 };
        CHECK(listEq(addTwoNumbers(mkList(a, 7), mkList(b, 4)), w, 8));
    }
    {
        /* 1 + 99 = 100 */
        int a[1] = { 1 }, b[2] = { 9, 9 }, w[3] = { 0, 0, 1 };
        CHECK(listEq(addTwoNumbers(mkList(a, 1), mkList(b, 2)), w, 3));
    }
    {
        /* 5 + 5 = 10 */
        int a[1] = { 5 }, b[1] = { 5 }, w[2] = { 0, 1 };
        CHECK(listEq(addTwoNumbers(mkList(a, 1), mkList(b, 1)), w, 2));
    }
    /* empty inputs */
    CHECK(addTwoNumbers(NULL, NULL) == NULL);
    {
        int b[3] = { 1, 2, 3 };
        CHECK(listEq(addTwoNumbers(NULL, mkList(b, 3)), b, 3));
    }
    {
        int a[2] = { 4, 5 };
        CHECK(listEq(addTwoNumbers(mkList(a, 2), NULL), a, 2));
    }
    {
        /* 9 + 9 = 18 */
        int a[1] = { 9 }, b[1] = { 9 }, w[2] = { 8, 1 };
        CHECK(listEq(addTwoNumbers(mkList(a, 1), mkList(b, 1)), w, 2));
    }
    printf("add_two_numbers: OK\n");
    return 0;
}
