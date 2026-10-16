#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static struct ListNode *mk(int v, struct ListNode *next) {
    struct ListNode *n = malloc(sizeof(struct ListNode));
    n->val = v;
    n->next = next;
    return n;
}

static struct ListNode *make(int *vals, int n) {
    struct ListNode *head = NULL;
    int i;
    for (i = n - 1; i >= 0; i--) head = mk(vals[i], head);
    return head;
}

static int list_eq(struct ListNode *got, int *want, int n) {
    int k = 0;
    struct ListNode *cur = got;
    while (cur != NULL) {
        if (k >= n) return 0;
        if (cur->val != want[k]) return 0;
        k++;
        cur = cur->next;
    }
    return k == n;
}

int main(void) {
    {
        int a[4] = { 4, 2, 1, 3 };
        int wa[4] = { 1, 2, 3, 4 };
        CHECK(list_eq(sortList(make(a, 4)), wa, 4));
        int b[5] = { -1, 5, 3, 4, 0 };
        int wb[5] = { -1, 0, 3, 4, 5 };
        CHECK(list_eq(sortList(make(b, 5)), wb, 5));
    }
    {
        CHECK(list_eq(sortList(NULL), NULL, 0));
        int one[1] = { 7 };
        CHECK(list_eq(sortList(make(one, 1)), one, 1));
        int two[2] = { 2, 1 };
        int w2[2] = { 1, 2 };
        CHECK(list_eq(sortList(make(two, 2)), w2, 2));
        int two_b[2] = { 1, 2 };
        CHECK(list_eq(sortList(make(two_b, 2)), w2, 2));
    }
    {
        int dup[6] = { 3, 3, 1, 1, 2, 2 };
        int wd[6] = { 1, 1, 2, 2, 3, 3 };
        CHECK(list_eq(sortList(make(dup, 6)), wd, 6));
        int asc[5] = { 1, 2, 3, 4, 5 };
        CHECK(list_eq(sortList(make(asc, 5)), asc, 5));
        int desc[5] = { 5, 4, 3, 2, 1 };
        CHECK(list_eq(sortList(make(desc, 5)), asc, 5));
        int neg[3] = { -3, -1, -2 };
        int wn[3] = { -3, -2, -1 };
        CHECK(list_eq(sortList(make(neg, 3)), wn, 3));
    }
    {
        int big[12];
        int want[12];
        int i;
        for (i = 0; i < 12; i++) {
            big[i] = 12 - i;
            want[i] = i + 1;
        }
        CHECK(list_eq(sortList(make(big, 12)), want, 12));
    }
    printf("sort_list: OK\n");
    return 0;
}
