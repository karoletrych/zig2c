#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    {
        char *w[] = { "This", "is", "an", "example", "of", "text", "justification." };
        int rs = 0;
        char **r = fullJustify(w, 7, 16, &rs);
        CHECK(rs == 3);
        CHECK(strcmp(r[0], "This    is    an") == 0);
        CHECK(strcmp(r[1], "example  of text") == 0);
        CHECK(strcmp(r[2], "justification.  ") == 0);
    }
    {
        char *w[] = { "What", "must", "be", "acknowledgment", "shall", "be" };
        int rs = 0;
        char **r = fullJustify(w, 6, 16, &rs);
        CHECK(rs == 3);
        CHECK(strcmp(r[0], "What   must   be") == 0);
        CHECK(strcmp(r[1], "acknowledgment  ") == 0);
        CHECK(strcmp(r[2], "shall be        ") == 0);
    }
    {
        char *w[] = {
            "Science", "is", "what", "we", "understand", "well", "enough",
            "to", "explain", "to", "a", "computer.", "Art", "is",
            "everything", "else", "we", "do",
        };
        int rs = 0;
        char **r = fullJustify(w, 18, 20, &rs);
        CHECK(rs == 6);
        CHECK(strcmp(r[0], "Science  is  what we") == 0);
        CHECK(strcmp(r[1], "understand      well") == 0);
        CHECK(strcmp(r[2], "enough to explain to") == 0);
        CHECK(strcmp(r[3], "a  computer.  Art is") == 0);
        CHECK(strcmp(r[4], "everything  else  we") == 0);
        CHECK(strcmp(r[5], "do                  ") == 0);
    }
    {
        char *w[] = { "abc", "de" };
        int rs = 0;
        char **r = fullJustify(w, 2, 3, &rs);
        CHECK(rs == 2);
        CHECK(strcmp(r[0], "abc") == 0);
        CHECK(strcmp(r[1], "de ") == 0);
    }
    {
        char *w[] = { "a" };
        int rs = 0;
        char **r = fullJustify(w, 1, 1, &rs);
        CHECK(rs == 1);
        CHECK(strcmp(r[0], "a") == 0);
    }
    {
        char *w[] = { "a", "b", "c", "d" };
        int rs = 0;
        char **r = fullJustify(w, 4, 6, &rs);
        CHECK(rs == 2);
        CHECK(strcmp(r[0], "a  b c") == 0);
        CHECK(strcmp(r[1], "d     ") == 0);
    }
    printf("text_justification: OK\n");
    return 0;
}
