#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        LRUCache *c = lRUCacheCreate(2);
        lRUCachePut(c, 1, 1);
        lRUCachePut(c, 2, 2);
        CHECK(lRUCacheGet(c, 1) == 1);
        lRUCachePut(c, 3, 3);            /* evicts key 2 */
        CHECK(lRUCacheGet(c, 2) == -1);
        lRUCachePut(c, 4, 4);            /* evicts key 1 */
        CHECK(lRUCacheGet(c, 1) == -1);
        CHECK(lRUCacheGet(c, 3) == 3);
        CHECK(lRUCacheGet(c, 4) == 4);
        lRUCacheFree(c);
    }
    {
        /* capacity 1 */
        LRUCache *c = lRUCacheCreate(1);
        lRUCachePut(c, 2, 20);
        CHECK(lRUCacheGet(c, 2) == 20);
        lRUCachePut(c, 3, 30);           /* evicts 2 */
        CHECK(lRUCacheGet(c, 2) == -1);
        CHECK(lRUCacheGet(c, 3) == 30);
        lRUCacheFree(c);
    }
    {
        /* updating an existing key refreshes it and does not evict */
        LRUCache *c = lRUCacheCreate(2);
        lRUCachePut(c, 1, 1);
        lRUCachePut(c, 2, 2);
        lRUCachePut(c, 1, 10);
        CHECK(lRUCacheGet(c, 1) == 10);
        lRUCachePut(c, 3, 3);            /* key 2 is LRU -> evicted */
        CHECK(lRUCacheGet(c, 2) == -1);
        CHECK(lRUCacheGet(c, 1) == 10);
        CHECK(lRUCacheGet(c, 3) == 3);
        lRUCachePut(c, 3, 33);
        CHECK(lRUCacheGet(c, 3) == 33);
        CHECK(lRUCacheGet(c, 1) == 10);
        lRUCacheFree(c);
    }
    {
        /* arbitrary and negative keys */
        LRUCache *c = lRUCacheCreate(3);
        lRUCachePut(c, 100000, 7);
        lRUCachePut(c, -100000, 8);
        lRUCachePut(c, 2147483647, 9);
        lRUCachePut(c, -2147483648, 10); /* evicts 100000 */
        CHECK(lRUCacheGet(c, -100000) == 8);
        CHECK(lRUCacheGet(c, 2147483647) == 9);
        CHECK(lRUCacheGet(c, -2147483648) == 10);
        CHECK(lRUCacheGet(c, 100000) == -1);
        lRUCachePut(c, 100000, 77);
        CHECK(lRUCacheGet(c, 100000) == 77);
        lRUCacheFree(c);
    }
    {
        /* get() refreshes recency */
        LRUCache *c = lRUCacheCreate(2);
        lRUCachePut(c, 1, 1);
        lRUCachePut(c, 2, 2);
        CHECK(lRUCacheGet(c, 1) == 1);   /* 2 is now the LRU */
        lRUCachePut(c, 3, 3);
        CHECK(lRUCacheGet(c, 2) == -1);
        CHECK(lRUCacheGet(c, 1) == 1);
        lRUCacheFree(c);
    }
    {
        /* misses on an empty cache */
        LRUCache *c = lRUCacheCreate(2);
        CHECK(lRUCacheGet(c, 0) == -1);
        CHECK(lRUCacheGet(c, -5) == -1);
        lRUCachePut(c, 0, 0);
        CHECK(lRUCacheGet(c, 0) == 0);
        lRUCacheFree(c);
    }
    printf("lru_cache: OK\n");
    return 0;
}
