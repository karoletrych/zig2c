#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static int approx(double a, double b) {
    double d = a - b;
    if (d < 0) d = -d;
    return d < 1e-9;
}

int main(void) {
    CHECK(myPow(2.0, 10) == 1024.0);
    CHECK(approx(myPow(2.1, 3), 9.261));
    CHECK(myPow(2.0, -2) == 0.25);
    CHECK(myPow(5.0, 0) == 1.0);
    CHECK(myPow(-2.0, 3) == -8.0);
    CHECK(myPow(-2.0, 2) == 4.0);
    CHECK(myPow(1.0, 2147483647) == 1.0);
    CHECK(myPow(1.0, -2147483648) == 1.0);
    CHECK(myPow(2.0, 2147483647) > 0.0);
    CHECK(myPow(2.0, -2147483648) == 0.0);
    CHECK(approx(myPow(0.5, 3), 0.125));
    printf("pow_x_n: OK\n");
    return 0;
}
