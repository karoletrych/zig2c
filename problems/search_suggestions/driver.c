#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        char *products[5] = { "mobile", "mouse", "moneypot", "monitor", "mousepad" };
        int rs = 0;
        int *cols = NULL;
        char ***r = suggestedProducts(products, 5, "mouse", &rs, &cols);
        CHECK(rs == 5);
        CHECK(cols[0] == 3);
        CHECK(strcmp(r[0][0], "mobile") == 0);
        CHECK(strcmp(r[0][1], "moneypot") == 0);
        CHECK(strcmp(r[0][2], "monitor") == 0);
        CHECK(cols[1] == 3);
        CHECK(strcmp(r[1][0], "mobile") == 0);
        CHECK(strcmp(r[1][1], "moneypot") == 0);
        CHECK(strcmp(r[1][2], "monitor") == 0);
        CHECK(cols[2] == 2);
        CHECK(strcmp(r[2][0], "mouse") == 0);
        CHECK(strcmp(r[2][1], "mousepad") == 0);
        CHECK(cols[3] == 2);
        CHECK(strcmp(r[3][0], "mouse") == 0);
        CHECK(strcmp(r[3][1], "mousepad") == 0);
        CHECK(cols[4] == 2);
        CHECK(strcmp(r[4][0], "mouse") == 0);
        CHECK(strcmp(r[4][1], "mousepad") == 0);
    }
    {
        char *products[1] = { "havana" };
        int rs = 0;
        int *cols = NULL;
        char ***r = suggestedProducts(products, 1, "havana", &rs, &cols);
        CHECK(rs == 6);
        for (int i = 0; i < 6; i++) {
            CHECK(cols[i] == 1);
            CHECK(strcmp(r[i][0], "havana") == 0);
        }
    }
    {
        char *products[5] = { "bags", "baggage", "banner", "box", "cloths" };
        int rs = 0;
        int *cols = NULL;
        char ***r = suggestedProducts(products, 5, "bags", &rs, &cols);
        CHECK(rs == 4);
        CHECK(cols[0] == 3);
        CHECK(strcmp(r[0][0], "baggage") == 0);
        CHECK(strcmp(r[0][1], "bags") == 0);
        CHECK(strcmp(r[0][2], "banner") == 0);
        CHECK(cols[1] == 3);
        CHECK(strcmp(r[1][0], "baggage") == 0);
        CHECK(strcmp(r[1][1], "bags") == 0);
        CHECK(strcmp(r[1][2], "banner") == 0);
        CHECK(cols[2] == 2);
        CHECK(strcmp(r[2][0], "baggage") == 0);
        CHECK(strcmp(r[2][1], "bags") == 0);
        CHECK(cols[3] == 1);
        CHECK(strcmp(r[3][0], "bags") == 0);
    }
    {
        char *products[4] = { "abc", "abc", "abd", "abe" };
        int rs = 0;
        int *cols = NULL;
        char ***r = suggestedProducts(products, 4, "ab", &rs, &cols);
        CHECK(rs == 2);
        CHECK(cols[0] == 3);
        CHECK(strcmp(r[0][0], "abc") == 0);
        CHECK(strcmp(r[0][1], "abc") == 0);
        CHECK(strcmp(r[0][2], "abd") == 0);
        CHECK(cols[1] == 3);
        CHECK(strcmp(r[1][0], "abc") == 0);
        CHECK(strcmp(r[1][1], "abc") == 0);
        CHECK(strcmp(r[1][2], "abd") == 0);
    }
    {
        char *products[1] = { "xyz" };
        int rs = 0;
        int *cols = NULL;
        char ***r = suggestedProducts(products, 1, "a", &rs, &cols);
        CHECK(rs == 1);
        CHECK(cols[0] == 0);
        (void)r;
    }
    printf("search_suggestions: OK\n");
    return 0;
}
