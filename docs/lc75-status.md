# LeetCode 75 — status

All **75** problems of the official LeetCode 75 study plan are implemented in
real Zig and verified: `zig test` passes, `zig2c` translates, and the generated
C compiles with `zig cc -Wall -Wextra` and produces the same answers.

Run everything:

```powershell
node tools\verify.js --all
```

## Coverage

| # | Problem | `problems/<dir>` |
| --- | --- | --- |
| **Array / String** | | |
| 1768 | Merge Strings Alternately | `merge_strings` |
| 1071 | Greatest Common Divisor of Strings | `gcd_of_strings` |
| 1431 | Kids With the Greatest Number of Candies | `kids_with_candies` |
| 605 | Can Place Flowers | `can_place_flowers` |
| 345 | Reverse Vowels of a String | `reverse_vowels` |
| 151 | Reverse Words in a String | `reverse_words` |
| 238 | Product of Array Except Self | `product_except_self` |
| 334 | Increasing Triplet Subsequence | `increasing_triplet` |
| 443 | String Compression | `string_compression` |
| **Two Pointers** | | |
| 283 | Move Zeroes | `move_zeroes` |
| 392 | Is Subsequence | `is_subsequence` |
| 11 | Container With Most Water | `max_area` |
| 1679 | Max Number of K-Sum Pairs | `max_k_sum_pairs` |
| **Sliding Window** | | |
| 643 | Maximum Average Subarray I | `max_average_subarray` |
| 1456 | Maximum Number of Vowels in a Substring of Given Length | `max_vowels_substring` |
| 1004 | Max Consecutive Ones III | `max_consecutive_ones_iii` |
| 1493 | Longest Subarray of 1's After Deleting One Element | `longest_subarray_of_ones` |
| **Prefix Sum** | | |
| 1732 | Find the Highest Altitude | `highest_altitude` |
| 724 | Find Pivot Index | `pivot_index` |
| **Hash Map / Set** | | |
| 2215 | Find the Difference of Two Arrays | `difference_of_two_arrays` |
| 1207 | Unique Number of Occurrences | `unique_occurrences` |
| 1657 | Determine if Two Strings Are Close | `close_strings` |
| 2352 | Equal Row and Column Pairs | `equal_row_col_pairs` |
| **Stack** | | |
| 2390 | Removing Stars From a String | `removing_stars` |
| 735 | Asteroid Collision | `asteroid_collision` |
| 394 | Decode String | `decode_string` |
| **Queue** | | |
| 933 | Number of Recent Calls | `recent_calls` |
| 649 | Dota2 Senate | `dota2_senate` |
| **Linked List** | | |
| 2095 | Delete the Middle Node of a Linked List | `delete_middle_node` |
| 328 | Odd Even Linked List | `odd_even_list` |
| 206 | Reverse Linked List | `reverse_linked_list` |
| 2130 | Maximum Twin Sum of a Linked List | `twin_sum` |
| **Binary Tree — DFS** | | |
| 104 | Maximum Depth of Binary Tree | `max_depth_tree` |
| 872 | Leaf-Similar Trees | `leaf_similar` |
| 1448 | Count Good Nodes in Binary Tree | `good_nodes` |
| 437 | Path Sum III | `path_sum_iii` |
| 1372 | Longest ZigZag Path in a Binary Tree | `longest_zigzag` |
| 236 | Lowest Common Ancestor of a Binary Tree | `lca_binary_tree` |
| **Binary Tree — BFS** | | |
| 199 | Binary Tree Right Side View | `right_side_view` |
| 1161 | Maximum Level Sum of a Binary Tree | `max_level_sum` |
| **Binary Search Tree** | | |
| 700 | Search in a Binary Search Tree | `search_bst` |
| 450 | Delete Node in a BST | `delete_node_bst` |
| **Graphs — DFS** | | |
| 841 | Keys and Rooms | `keys_and_rooms` |
| 547 | Number of Provinces | `number_of_provinces` |
| 1466 | Reorder Routes to Make All Paths Lead to the City Zero | `reorder_routes` |
| 399 | Evaluate Division | `evaluate_division` |
| **Graphs — BFS** | | |
| 1926 | Nearest Exit from Entrance in Maze | `nearest_exit` |
| 994 | Rotting Oranges | `rotting_oranges` |
| **Heap / Priority Queue** | | |
| 215 | Kth Largest Element in an Array | `kth_largest` |
| 2336 | Smallest Number in Infinite Set | `smallest_infinite_set` |
| 2542 | Maximum Subsequence Score | `max_subsequence_score` |
| 2462 | Total Cost to Hire K Workers | `total_cost_hire_k` |
| **Binary Search** | | |
| 374 | Guess Number Higher or Lower | `guess_number` |
| 2300 | Successful Pairs of Spells and Potions | `successful_pairs` |
| 162 | Find Peak Element | `find_peak_element` |
| 875 | Koko Eating Bananas | `koko_eating_bananas` |
| **Backtracking** | | |
| 17 | Letter Combinations of a Phone Number | `letter_combinations` |
| 216 | Combination Sum III | `combination_sum_iii` |
| **Dynamic Programming — 1D** | | |
| 1137 | N-th Tribonacci Number | `tribonacci` |
| 746 | Min Cost Climbing Stairs | `min_cost_climbing_stairs` |
| 198 | House Robber | `house_robber` |
| 790 | Domino and Tromino Tiling | `domino_tromino_tiling` |
| **Dynamic Programming — Multidimensional** | | |
| 62 | Unique Paths | `unique_paths` |
| 1143 | Longest Common Subsequence | `longest_common_subsequence` |
| 714 | Best Time to Buy and Sell Stock with Transaction Fee | `stock_with_fee` |
| 72 | Edit Distance | `edit_distance` |
| **Bit Manipulation** | | |
| 338 | Counting Bits | `counting_bits` |
| 136 | Single Number | `single_number` |
| 1318 | Minimum Flips to Make a OR b Equal to c | `min_flips` |
| **Trie** | | |
| 208 | Implement Trie (Prefix Tree) | `implement_trie` |
| 1268 | Search Suggestions System | `search_suggestions` |
| **Intervals** | | |
| 435 | Non-overlapping Intervals | `non_overlapping_intervals` |
| 452 | Minimum Number of Arrows to Burst Balloons | `min_arrows_balloons` |
| **Monotonic Stack** | | |
| 739 | Daily Temperatures | `daily_temperatures` |
| 901 | Online Stock Span | `online_stock_span` |

## Extras (outside the 75)

`two_sum` (1), `longest_substring` (3), `valid_parentheses` (20),
`merge_two_lists` (21), plus `smoke_std`, `container_smoke`, `fixes_smoke`
which exercise translator features.
