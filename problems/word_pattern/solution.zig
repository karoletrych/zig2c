// LeetCode 290. Word Pattern
// C signature:  bool wordPattern(char* pattern, char* s);
//
// The mapping must be a bijection between pattern letters and distinct words.
// Words are identified by their (start, length) in the input, so equal words
// can be compared without copying. `seen_char` records which pattern letters
// have been used; `word_char` records the letter of a word's first occurrence.
const std = @import("std");

pub fn wordPattern(pattern: [*]u8, s: [*]u8) bool {
    const pat = std.mem.sliceTo(pattern, 0);
    const str = std.mem.sliceTo(s, 0);

    var seen_char: [256]bool = undefined;
    var i: usize = 0;
    while (i < 256) : (i += 1) seen_char[i] = false;

    var word_start: [1024]usize = undefined;
    var word_len: [1024]usize = undefined;
    var word_char: [1024]u8 = undefined;

    var wi: usize = 0;
    var pos: usize = 0;
    while (pos < str.len) {
        const start = pos;
        while (pos < str.len and str[pos] != ' ') pos += 1;
        const len = pos - start;
        if (len == 0) {
            pos += 1;
            continue;
        }
        if (wi >= pat.len) return false;
        const c = pat[wi];

        // Does this exact word already appear earlier?
        var found: i32 = -1;
        var j: usize = 0;
        while (j < wi) : (j += 1) {
            if (word_len[j] != len) continue;
            var same = true;
            var k: usize = 0;
            while (k < len) : (k += 1) {
                if (str[word_start[j] + k] != str[start + k]) {
                    same = false;
                    break;
                }
            }
            if (same) {
                found = @intCast(j);
                break;
            }
        }

        if (found >= 0) {
            // An existing word must always carry the same pattern letter.
            if (word_char[@intCast(found)] != c) return false;
        } else {
            // A brand-new word needs a pattern letter that is still free.
            const ci: usize = @intCast(c);
            if (seen_char[ci]) return false;
            seen_char[ci] = true;
            word_char[wi] = c;
        }

        word_start[wi] = start;
        word_len[wi] = len;
        wi += 1;
        if (pos < str.len) pos += 1; // skip the single space
    }
    return wi == pat.len;
}

test "wordPattern examples" {
    try std.testing.expect(wordPattern(@constCast("abba"), @constCast("dog cat cat dog")));
    try std.testing.expect(!wordPattern(@constCast("abba"), @constCast("dog cat cat fish")));
    try std.testing.expect(!wordPattern(@constCast("aaaa"), @constCast("dog cat cat dog")));
    try std.testing.expect(!wordPattern(@constCast("ab"), @constCast("dog dog")));
    try std.testing.expect(wordPattern(@constCast("a"), @constCast("dog")));
    try std.testing.expect(!wordPattern(@constCast("a"), @constCast("dog cat")));
    try std.testing.expect(wordPattern(@constCast(""), @constCast("")));
    try std.testing.expect(!wordPattern(@constCast("a"), @constCast("")));
    try std.testing.expect(!wordPattern(@constCast("abc"), @constCast("b c a a")));
}
