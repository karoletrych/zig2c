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
        int a[5] = { 1, 2, 3, 4, 5 }, w[5] = { 4, 5, 1, 2, 3 };
        CHECK(listEq(rotateRight(mkList(a, 5), 2), w, 5));
    }
    {
        int a[3] = { 0, 1, 2 }, w[3] = { 2, 0, 1 };
        CHECK(listEq(rotateRight(mkList(a, 3), 4), w, 3));
    }
    {
        /* k == 0 */
        int a[3] = { 1, 2, 3 };
        CHECK(listEq(rotateRight(mkList(a, 3), 0), a, 3));
    }
    {
        /* k == length */
        int a[3] = { 1, 2, 3 };
        CHECK(listEq(rotateRight(mkList(a, 3), 3), a, 3));
    }
    {
        /* k wraps around */
        int a[3] = { 1, 2, 3 }, w[3] = { 2, 3, 1 };
        CHECK(listEq(rotateRight(mkList(a, 3), 2000000000), w, 3));
    }
    CHECK(rotateRight(NULL, 3) == NULL);
    {
        int a[1] = { 9 };
        CHECK(listEq(rotateRight(mkList(a, 1), 5), a, 1));
    }
    {
        int a[3] = { 1, 2, 3 }, w[3] = { 2, 3, 1 };
        CHECK(listEq(rotateRight(mkList(a, 3), 2), w, 3));
    }
    {
        int a[2] = { 1, 2 }, w[2] = { 2, 1 };
        CHECK(listEq(rotateRight(mkList(a, 2), 1), w, 2));
    }
    {
        /* negative k must reduce the same way as in Zig */
        int a[5] = { 1, 2, 3, 4, 5 }, w[5] = { 2, 3, 4, 5, 1 };
        CHECK(listEq(rotateRight(mkList(a, 5), -1), w, 5));
    }
    {
        int a[3] = { 1, 2, 3 }, w[3] = { 2, 3, 1 };
        CHECK(listEq(rotateRight(mkList(a, 3), -4), w, 3));
    }
    {
        int a[3] = { 1, 2, 3 };
        CHECK(listEq(rotateRight(mkList(a, 3), -3), a, 3));
    }
    printf("rotate_list: OK\n");
    return 0;
}
