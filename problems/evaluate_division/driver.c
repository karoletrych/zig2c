#include "leetcode.c"
#include <math.h>

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)
#define CHECK_NEAR(a, b) CHECK(fabs((a) - (b)) < 1e-9)

int main(void) {
    {
        /* equations [["a","b"],["b","c"]], values [2,3]
           queries [["a","c"],["b","a"],["a","e"],["a","a"],["x","x"]]
           -> [6, 0.5, -1, 1, -1] */
        char *e0[2] = { "a", "b" };
        char *e1[2] = { "b", "c" };
        char **eq[2] = { e0, e1 };
        int ecols[2] = { 2, 2 };
        double vals[2] = { 2.0, 3.0 };

        char *q0[2] = { "a", "c" };
        char *q1[2] = { "b", "a" };
        char *q2[2] = { "a", "e" };
        char *q3[2] = { "a", "a" };
        char *q4[2] = { "x", "x" };
        char **qs[5] = { q0, q1, q2, q3, q4 };
        int qcols[5] = { 2, 2, 2, 2, 2 };

        int rs = 0;
        double *r = calcEquation(eq, 2, ecols, vals, 2, qs, 5, qcols, &rs);
        CHECK(rs == 5);
        CHECK_NEAR(r[0], 6.0);
        CHECK_NEAR(r[1], 0.5);
        CHECK_NEAR(r[2], -1.0);
        CHECK_NEAR(r[3], 1.0);
        CHECK_NEAR(r[4], -1.0);
        free(r);
    }
    {
        /* equations [["a","b"],["b","c"],["bc","cd"]], values [1.5,2.5,5]
           queries [["a","c"],["c","b"],["bc","cd"],["cd","bc"]]
           -> [3.75, 0.4, 5, 0.2] */
        char *e0[2] = { "a", "b" };
        char *e1[2] = { "b", "c" };
        char *e2[2] = { "bc", "cd" };
        char **eq[3] = { e0, e1, e2 };
        int ecols[3] = { 2, 2, 2 };
        double vals[3] = { 1.5, 2.5, 5.0 };

        char *q0[2] = { "a", "c" };
        char *q1[2] = { "c", "b" };
        char *q2[2] = { "bc", "cd" };
        char *q3[2] = { "cd", "bc" };
        char **qs[4] = { q0, q1, q2, q3 };
        int qcols[4] = { 2, 2, 2, 2 };

        int rs = 0;
        double *r = calcEquation(eq, 3, ecols, vals, 3, qs, 4, qcols, &rs);
        CHECK(rs == 4);
        CHECK_NEAR(r[0], 3.75);
        CHECK_NEAR(r[1], 0.4);
        CHECK_NEAR(r[2], 5.0);
        CHECK_NEAR(r[3], 0.2);
        free(r);
    }
    {
        /* equations [["a","b"]], values [0.5]
           queries [["a","b"],["b","a"],["a","c"],["x","y"]]
           -> [0.5, 2, -1, -1] */
        char *e0[2] = { "a", "b" };
        char **eq[1] = { e0 };
        int ecols[1] = { 2 };
        double vals[1] = { 0.5 };

        char *q0[2] = { "a", "b" };
        char *q1[2] = { "b", "a" };
        char *q2[2] = { "a", "c" };
        char *q3[2] = { "x", "y" };
        char **qs[4] = { q0, q1, q2, q3 };
        int qcols[4] = { 2, 2, 2, 2 };

        int rs = 0;
        double *r = calcEquation(eq, 1, ecols, vals, 1, qs, 4, qcols, &rs);
        CHECK(rs == 4);
        CHECK_NEAR(r[0], 0.5);
        CHECK_NEAR(r[1], 2.0);
        CHECK_NEAR(r[2], -1.0);
        CHECK_NEAR(r[3], -1.0);
        free(r);
    }
    printf("evaluate_division: OK\n");
    return 0;
}
