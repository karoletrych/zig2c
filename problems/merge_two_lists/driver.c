#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    int av[3] = { 1, 2, 4 };
    int bv[3] = { 1, 3, 4 };
    int want[6] = { 1, 1, 2, 3, 4, 4 };

    ListNode *head = NULL;
    for (int i = 2; i >= 0; i--) {
        ListNode *nd = malloc(sizeof(ListNode));
        nd->val = av[i];
        nd->next = head;
        head = nd;
    }
    ListNode *head2 = NULL;
    for (int i = 2; i >= 0; i--) {
        ListNode *nd = malloc(sizeof(ListNode));
        nd->val = bv[i];
        nd->next = head2;
        head2 = nd;
    }

    ListNode *r = mergeTwoLists(head, head2);
    int k = 0;
    for (ListNode *c = r; c; c = c->next) {
        CHECK(c->val == want[k]);
        k++;
    }
    CHECK(k == 6);
    printf("merge_two_lists: OK\n");
    return 0;
}
