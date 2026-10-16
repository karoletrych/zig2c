#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

/* Checks that `order` is a topological order of the given prerequisites. */
static int validOrder(int n, int **pre, int preSize, int *order, int orderSize) {
    if (orderSize != n) return 0;
    int *pos = (int *)malloc(sizeof(int) * (n > 0 ? n : 1));
    for (int i = 0; i < orderSize; i++) pos[order[i]] = i;
    for (int i = 0; i < preSize; i++) {
        if (pos[pre[i][1]] >= pos[pre[i][0]]) { free(pos); return 0; }
    }
    free(pos);
    return 1;
}

int main(void) {
    {
        int a0[2] = { 1, 0 };
        int *p[1] = { a0 };
        int cols[1] = { 2 };
        int rs = 0;
        int *r = findOrder(2, p, 1, cols, &rs);
        CHECK(rs == 2 && r[0] == 0 && r[1] == 1);
    }
    {
        int b0[2] = { 1, 0 };
        int b1[2] = { 2, 0 };
        int b2[2] = { 3, 1 };
        int b3[2] = { 3, 2 };
        int *p[4] = { b0, b1, b2, b3 };
        int cols[4] = { 2, 2, 2, 2 };
        int rs = 0;
        int *r = findOrder(4, p, 4, cols, &rs);
        CHECK(validOrder(4, p, 4, r, rs));
    }
    {
        int c0[2] = { 1, 0 };
        int c1[2] = { 0, 1 };
        int *p[2] = { c0, c1 };
        int cols[2] = { 2, 2 };
        int rs = 9;
        int *r = findOrder(2, p, 2, cols, &rs);
        CHECK(r != NULL && rs == 0);
    }
    {
        int *p[1] = { NULL };
        int cols[1] = { 0 };
        int rs = 0;
        int *r = findOrder(3, p, 0, cols, &rs);
        CHECK(rs == 3 && r[0] == 0 && r[1] == 1 && r[2] == 2);
    }
    {
        int *p[1] = { NULL };
        int cols[1] = { 0 };
        int rs = 0;
        int *r = findOrder(1, p, 0, cols, &rs);
        CHECK(rs == 1 && r[0] == 0);
    }
    {
        /* cycle hidden in one component of a bigger graph */
        int d0[2] = { 1, 0 };
        int d1[2] = { 3, 2 };
        int d2[2] = { 2, 3 };
        int *p[3] = { d0, d1, d2 };
        int cols[3] = { 2, 2, 2 };
        int rs = 7;
        int *r = findOrder(4, p, 3, cols, &rs);
        CHECK(r != NULL && rs == 0);
    }
    printf("course_schedule_ii: OK\n");
    return 0;
}
