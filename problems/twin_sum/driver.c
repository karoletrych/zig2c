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

int main(void) {
    int a1[4] = { 5, 4, 2, 1 };
    CHECK(pairSum(mk(a1, 4)) == 6);

    int a2[4] = { 4, 2, 2, 3 };
    CHECK(pairSum(mk(a2, 4)) == 7);

    int a3[2] = { 1, 100000 };
    CHECK(pairSum(mk(a3, 2)) == 100001);

    int a4[2] = { 1, 2 };
    CHECK(pairSum(mk(a4, 2)) == 3);

    int a5[6] = { 1, 2, 3, 4, 5, 6 };
    CHECK(pairSum(mk(a5, 6)) == 7);

    printf("twin_sum: OK\n");
    return 0;
}
