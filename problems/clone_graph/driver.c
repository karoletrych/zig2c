#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static Node *mknode(int val, int n) {
    Node *p = (Node *)malloc(sizeof(Node));
    p->val = val;
    p->numNeighbors = n;
    p->neighbors = (Node **)malloc(sizeof(Node *) * (n > 0 ? n : 1));
    for (int i = 0; i < n; i++) p->neighbors[i] = NULL;
    return p;
}

static int nv(Node *n, int i) { return n->neighbors[i]->val; }

int main(void) {
    {
        Node *n1 = mknode(1, 2);
        Node *n2 = mknode(2, 2);
        Node *n3 = mknode(3, 2);
        Node *n4 = mknode(4, 2);
        n1->neighbors[0] = n2; n1->neighbors[1] = n4;
        n2->neighbors[0] = n1; n2->neighbors[1] = n3;
        n3->neighbors[0] = n2; n3->neighbors[1] = n4;
        n4->neighbors[0] = n1; n4->neighbors[1] = n3;

        Node *cp = cloneGraph(n1);
        CHECK(cp != NULL && cp != n1);
        CHECK(cp->val == 1 && cp->numNeighbors == 2);
        CHECK(nv(cp, 0) == 2 && nv(cp, 1) == 4);
        CHECK(cp->neighbors[0] != n2);
        Node *c2 = cp->neighbors[0];
        Node *c4 = cp->neighbors[1];
        CHECK(c2->val == 2 && c4->val == 4);
        CHECK(nv(c2, 0) == 1 && nv(c2, 1) == 3);
        CHECK(nv(c4, 0) == 1 && nv(c4, 1) == 3);
        CHECK(c2->neighbors[1] == c4->neighbors[1]);
        /* original is untouched */
        CHECK(nv(n1, 0) == 2 && nv(n1, 1) == 4);
        CHECK(n1->neighbors[0] == n2);
    }
    CHECK(cloneGraph(NULL) == NULL);
    {
        Node *solo = mknode(1, 0);
        Node *cp = cloneGraph(solo);
        CHECK(cp != NULL && cp != solo);
        CHECK(cp->val == 1 && cp->numNeighbors == 0);
    }
    {
        Node *a = mknode(1, 1);
        Node *b = mknode(2, 1);
        a->neighbors[0] = b;
        b->neighbors[0] = a;
        Node *ca = cloneGraph(a);
        CHECK(ca->val == 1 && ca->numNeighbors == 1);
        CHECK(ca->neighbors[0]->val == 2);
        CHECK(ca->neighbors[0]->neighbors[0] == ca);
    }
    printf("clone_graph: OK\n");
    return 0;
}
