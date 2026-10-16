#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        StockSpanner *obj = stockSpannerCreate();
        CHECK(stockSpannerNext(obj, 100) == 1);
        CHECK(stockSpannerNext(obj, 80) == 1);
        CHECK(stockSpannerNext(obj, 60) == 1);
        CHECK(stockSpannerNext(obj, 70) == 2);
        CHECK(stockSpannerNext(obj, 60) == 1);
        CHECK(stockSpannerNext(obj, 75) == 4);
        CHECK(stockSpannerNext(obj, 85) == 6);
        stockSpannerFree(obj);
    }
    {
        StockSpanner *obj = stockSpannerCreate();
        CHECK(stockSpannerNext(obj, 10) == 1);
        CHECK(stockSpannerNext(obj, 20) == 2);
        CHECK(stockSpannerNext(obj, 30) == 3);
        CHECK(stockSpannerNext(obj, 40) == 4);
        stockSpannerFree(obj);
    }
    {
        StockSpanner *obj = stockSpannerCreate();
        CHECK(stockSpannerNext(obj, 5) == 1);
        CHECK(stockSpannerNext(obj, 5) == 2);
        CHECK(stockSpannerNext(obj, 5) == 3);
        CHECK(stockSpannerNext(obj, 4) == 1);
        stockSpannerFree(obj);
    }
    printf("online_stock_span: OK\n");
    return 0;
}
