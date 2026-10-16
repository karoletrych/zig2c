#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static ListNode *node(int v, ListNode *next) {
    ListNode *n = malloc(sizeof(ListNode));
    n->val = v;
    n->next = next;
    return n;
}

int main(void) {
    {
        /* 3 -> 2 -> 0 -> -4, tail connects back to index 1 */
        ListNode *c = node(-4, NULL);
        ListNode *b = node(0, c);
        ListNode *a = node(2, b);
        ListNode *h = node(3, a);
        CHECK(hasCycle(h) == false);
        c->next = a;
        CHECK(hasCycle(h) == true);
        c->next = NULL;
        CHECK(hasCycle(h) == false);
    }
    /* empty list */
    CHECK(hasCycle(NULL) == false);
    {
        /* single node */
        ListNode *s = node(7, NULL);
        CHECK(hasCycle(s) == false);
        s->next = s;
        CHECK(hasCycle(s) == true);
        s->next = NULL;
        CHECK(hasCycle(s) == false);
    }
    {
        /* two nodes, cycle at the head */
        ListNode *t = node(1, NULL);
        ListNode *t2 = node(2, t);
        CHECK(hasCycle(t2) == false);
        t->next = t2;
        CHECK(hasCycle(t2) == true);
        t->next = NULL;
        CHECK(hasCycle(t2) == false);
    }
    {
        /* one node that does not loop (pos = -1) */
        CHECK(hasCycle(node(1, NULL)) == false);
    }
    printf("linked_list_cycle: OK\n");
    return 0;
}
