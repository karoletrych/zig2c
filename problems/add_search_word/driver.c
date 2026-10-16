#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        WordDictionary *d = wordDictionaryCreate();
        wordDictionaryAddWord(d, "bad");
        wordDictionaryAddWord(d, "dad");
        wordDictionaryAddWord(d, "mad");
        CHECK(!wordDictionarySearch(d, "pad"));
        CHECK(wordDictionarySearch(d, "bad"));
        CHECK(wordDictionarySearch(d, ".ad"));
        CHECK(wordDictionarySearch(d, "b.."));
    }
    {
        WordDictionary *d = wordDictionaryCreate();
        CHECK(!wordDictionarySearch(d, "a"));
        CHECK(!wordDictionarySearch(d, "."));
        wordDictionaryAddWord(d, "a");
        CHECK(wordDictionarySearch(d, "a"));
        CHECK(wordDictionarySearch(d, "."));
        CHECK(!wordDictionarySearch(d, "aa"));
        CHECK(!wordDictionarySearch(d, "b"));
        wordDictionaryAddWord(d, "apple");
        CHECK(!wordDictionarySearch(d, "app"));
        CHECK(wordDictionarySearch(d, "app.."));
        CHECK(wordDictionarySearch(d, "ap.le"));
        CHECK(wordDictionarySearch(d, "....."));
        CHECK(!wordDictionarySearch(d, "...."));
        CHECK(!wordDictionarySearch(d, "......"));
        wordDictionaryAddWord(d, "az");
        wordDictionaryAddWord(d, "bz");
        CHECK(wordDictionarySearch(d, ".z"));
        CHECK(!wordDictionarySearch(d, ".y"));
        CHECK(wordDictionarySearch(d, ".."));
    }
    printf("add_search_word: OK\n");
    return 0;
}
