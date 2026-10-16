#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static Node *mk(int v, Node *next, Node *random) {
    Node *n = malloc(sizeof(Node));
    n->val = v;
    n->next = next;
    n->random = random;
    return n;
}

/* Deep structural check: values match, every copy is a distinct node and the
 * random links point at distinct copies with the same values. */
static int cloneOK(Node *orig, Node *copy) {
    Node *x = orig, *y = copy;
    while (x && y) {
        if (x->val != y->val) return 0;
        if (x == y) return 0;
        if (!x->random) {
            if (y->random) return 0;
        } else {
            if (!y->random) return 0;
            if (x->random->val != y->random->val) return 0;
            if (x->random == y->random) return 0;
        }
        x = x->next;
        y = y->next;
    }
    return x == NULL && y == NULL;
}

int main(void) {
    {
        /* [[7,null],[13,0],[11,4],[10,2],[1,0]] */
        Node *n0 = mk(7, NULL, NULL);
        Node *n1 = mk(13, NULL, NULL);
        Node *n2 = mk(11, NULL, NULL);
        Node *n3 = mk(10, NULL, NULL);
        Node *n4 = mk(1, NULL, NULL);
        n0->next = n1; n1->next = n2; n2->next = n3; n3->next = n4;
        n1->random = n0;
        n2->random = n4;
        n3->random = n2;
        n4->random = n0;

        Node *cp = copyRandomList(n0);
        CHECK(cloneOK(n0, cp));
        CHECK(cp != NULL && cp != n0);
        /* the original list is untouched */
        CHECK(n0->next == n1 && n1->next == n2 && n2->next == n3 && n3->next == n4);
        CHECK(n4->next == NULL && n0->random == NULL);
    }
    /* empty list */
    CHECK(copyRandomList(NULL) == NULL);
    {
        /* single node, random points at itself */
        Node *s = mk(-1, NULL, NULL);
        s->random = s;
        Node *c = copyRandomList(s);
        CHECK(cloneOK(s, c));
        CHECK(c->random == c && c->random != s);
    }
    {
        /* single node without random */
        Node *s = mk(5, NULL, NULL);
        Node *c = copyRandomList(s);
        CHECK(cloneOK(s, c));
        CHECK(c->random == NULL && c->next == NULL && c->val == 5);
    }
    printf("copy_random_list: OK\n");
    return 0;
}
