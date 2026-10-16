#include "leetcode.c"

#define CHECK(cond) do { if (!(cond)) { printf("FAIL: %s (line %d)\n", #cond, __LINE__); return 1; } } while (0)

int main(void) {
    CHECK(strcmp(predictPartyVictory("RD"), "Radiant") == 0);
    CHECK(strcmp(predictPartyVictory("RDD"), "Dire") == 0);
    CHECK(strcmp(predictPartyVictory("DDRRR"), "Dire") == 0);
    CHECK(strcmp(predictPartyVictory("DRRDRDRDRDDRDRDR"), "Radiant") == 0);
    CHECK(strcmp(predictPartyVictory("RRRR"), "Radiant") == 0);
    CHECK(strcmp(predictPartyVictory("D"), "Dire") == 0);
    printf("dota2_senate: OK\n");
    return 0;
}
