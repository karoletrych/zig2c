#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

static int approx(double a, double b) { return (a - b) < 1e-9 && (b - a) < 1e-9; }

int main(void) {
    {
        MedianFinder *mf = medianFinderCreate();
        medianFinderAddNum(mf, 1);
        medianFinderAddNum(mf, 2);
        CHECK(approx(medianFinderFindMedian(mf), 1.5));
        medianFinderAddNum(mf, 3);
        CHECK(approx(medianFinderFindMedian(mf), 2.0));
    }
    {
        MedianFinder *mf = medianFinderCreate();
        for (int i = 1; i <= 6; i++) medianFinderAddNum(mf, i);
        CHECK(approx(medianFinderFindMedian(mf), 3.5));
        medianFinderAddNum(mf, 7);
        CHECK(approx(medianFinderFindMedian(mf), 4.0));

        MedianFinder *rev = medianFinderCreate();
        for (int i = 6; i >= 1; i--) medianFinderAddNum(rev, i);
        CHECK(approx(medianFinderFindMedian(rev), 3.5));
    }
    {
        MedianFinder *one = medianFinderCreate();
        medianFinderAddNum(one, 42);
        CHECK(approx(medianFinderFindMedian(one), 42.0));
    }
    {
        MedianFinder *mf = medianFinderCreate();
        medianFinderAddNum(mf, -1);
        CHECK(approx(medianFinderFindMedian(mf), -1.0));
        medianFinderAddNum(mf, -2);
        CHECK(approx(medianFinderFindMedian(mf), -1.5));
        medianFinderAddNum(mf, -3);
        CHECK(approx(medianFinderFindMedian(mf), -2.0));
    }
    {
        MedianFinder *eq = medianFinderCreate();
        for (int i = 0; i < 5; i++) medianFinderAddNum(eq, 7);
        CHECK(approx(medianFinderFindMedian(eq), 7.0));
    }
    {
        MedianFinder *big = medianFinderCreate();
        medianFinderAddNum(big, 2147483647);
        medianFinderAddNum(big, 2147483647);
        CHECK(approx(medianFinderFindMedian(big), 2147483647.0));
    }
    printf("median_data_stream: OK\n");
    return 0;
}
