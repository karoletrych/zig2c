#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static ListNode *build(const int *vals, int n) {
    ListNode *head = NULL;
    for (int i = n - 1; i >= 0; i--) {
        ListNode *nd = malloc(sizeof(ListNode));
        nd->val = vals[i];
        nd->next = head;
        head = nd;
    }
    return head;
}

static int checkList(ListNode *head, const int *want, int n) {
    int k = 0;
    for (ListNode *c = head; c; c = c->next) {
        if (k >= n || c->val != want[k]) return 0;
        k++;
    }
    return k == n;
}

int main(void) {
    {
        int a[3] = { 1, 4, 5 };
        int b[3] = { 1, 3, 4 };
        int c[2] = { 2, 6 };
        ListNode *lists[3] = { build(a, 3), build(b, 3), build(c, 2) };
        int want[8] = { 1, 1, 2, 3, 4, 4, 5, 6 };
        CHECK(checkList(mergeKLists(lists, 3), want, 8));
    }
    {
        int a[1] = { 0 };
        ListNode *lists[1] = { build(a, 1) };
        CHECK(mergeKLists(lists, 0) == NULL);
        ListNode *lists2[1] = { build(a, 1) };
        int want[1] = { 0 };
        CHECK(checkList(mergeKLists(lists2, 1), want, 1));
    }
    {
        int a[1] = { 1 };
        int b[2] = { 0, 2 };
        ListNode *lists[4] = { NULL, build(a, 1), NULL, build(b, 2) };
        int want[3] = { 0, 1, 2 };
        CHECK(checkList(mergeKLists(lists, 4), want, 3));
    }
    {
        ListNode *lists[3] = { NULL, NULL, NULL };
        CHECK(mergeKLists(lists, 3) == NULL);
    }
    {
        int a[3] = { -5, -1, 3 };
        int b[4] = { -4, -1, 3, 3 };
        int c[1] = { -1 };
        ListNode *lists[3] = { build(a, 3), build(b, 4), build(c, 1) };
        int want[8] = { -5, -4, -1, -1, -1, 3, 3, 3 };
        CHECK(checkList(mergeKLists(lists, 3), want, 8));
    }
    printf("merge_k_lists: OK\n");
    return 0;
}
