#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        Trie *t = trieCreate();
        trieInsert(t, "apple");
        CHECK(trieSearch(t, "apple") == true);
        CHECK(trieSearch(t, "app") == false);
        CHECK(trieStartsWith(t, "app") == true);
        trieInsert(t, "app");
        CHECK(trieSearch(t, "app") == true);
        trieFree(t);
    }
    {
        Trie *t = trieCreate();
        CHECK(trieSearch(t, "a") == false);
        CHECK(trieStartsWith(t, "a") == false);
        CHECK(trieStartsWith(t, "") == true);
        CHECK(trieSearch(t, "") == false);

        trieInsert(t, "a");
        trieInsert(t, "ab");
        trieInsert(t, "zebra");
        CHECK(trieSearch(t, "a") == true);
        CHECK(trieSearch(t, "ab") == true);
        CHECK(trieSearch(t, "abc") == false);
        CHECK(trieStartsWith(t, "abc") == false);
        CHECK(trieStartsWith(t, "ab") == true);
        CHECK(trieSearch(t, "zebr") == false);
        CHECK(trieStartsWith(t, "zebr") == true);
        CHECK(trieSearch(t, "zebra") == true);

        trieInsert(t, "ab");
        CHECK(trieSearch(t, "ab") == true);
        trieFree(t);
    }
    printf("implement_trie: OK\n");
    return 0;
}
