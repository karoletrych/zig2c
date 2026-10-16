// LeetCode 374. Guess Number Higher or Lower
// C signature:  int guessNumber(int n);
//
// The judge supplies `guess(num)`, which returns -1 if num is too high,
// 1 if too low and 0 on a hit. It cannot be linked by `zig test`, so this file
// deliberately has no test block; the checks live in driver.c, which provides
// its own `guess`.
extern fn guess(num: i32) i32;

pub fn guessNumber(n: i32) i32 {
    var lo: i32 = 1;
    var hi: i32 = n;
    while (lo <= hi) {
        const mid = lo + @divTrunc(hi - lo, 2);
        const g = guess(mid);
        if (g == 0) return mid;
        if (g < 0) {
            hi = mid - 1;
        } else {
            lo = mid + 1;
        }
    }
    return lo;
}
