# LeetCode Top Interview 150 - status

All **150** problems are implemented in real Zig and verified: `zig test`
passes, `zig2c` translates, and the generated C compiles with
`zig cc -Wall -Wextra` and produces the same answers.

```powershell
node tools\verify.js --all
```

| # | Problem (slug) | `problems/<dir>` |
| --- | --- | --- |
| **Array / String** | | |
| 88 | merge sorted array | `merge_sorted_array` |
| 27 | remove element | `remove_element` |
| 26 | remove duplicates sorted | `remove_duplicates_sorted` |
| 80 | remove duplicates sorted ii | `remove_duplicates_sorted_ii` |
| 169 | majority element | `majority_element` |
| 189 | rotate array | `rotate_array` |
| 121 | buy sell stock | `buy_sell_stock` |
| 122 | buy sell stock ii | `buy_sell_stock_ii` |
| 55 | jump game | `jump_game` |
| 45 | jump game ii | `jump_game_ii` |
| 274 | h index | `h_index` |
| 380 | randomized set | `randomized_set` |
| 238 | product except self | `product_except_self` |
| 134 | gas station | `gas_station` |
| 135 | candy | `candy` |
| 42 | trapping rain water | `trapping_rain_water` |
| 13 | roman to integer | `roman_to_integer` |
| 12 | integer to roman | `integer_to_roman` |
| 58 | length of last word | `length_of_last_word` |
| 14 | longest common prefix | `longest_common_prefix` |
| 151 | reverse words | `reverse_words` |
| 6 | zigzag conversion | `zigzag_conversion` |
| 28 | str str | `str_str` |
| 68 | text justification | `text_justification` |
| **Two Pointers** | | |
| 125 | valid palindrome | `valid_palindrome` |
| 392 | is subsequence | `is_subsequence` |
| 167 | two sum ii | `two_sum_ii` |
| 11 | max area | `max_area` |
| 15 | three sum | `three_sum` |
| **Sliding Window** | | |
| 209 | min size subarray sum | `min_size_subarray_sum` |
| 3 | longest substring | `longest_substring` |
| 30 | substring concatenation | `substring_concatenation` |
| 76 | minimum window substring | `minimum_window_substring` |
| **Matrix** | | |
| 36 | valid sudoku | `valid_sudoku` |
| 54 | spiral matrix | `spiral_matrix` |
| 48 | rotate image | `rotate_image` |
| 73 | set matrix zeroes | `set_matrix_zeroes` |
| 289 | game of life | `game_of_life` |
| **Hashmap** | | |
| 383 | ransom note | `ransom_note` |
| 205 | isomorphic strings | `isomorphic_strings` |
| 290 | word pattern | `word_pattern` |
| 242 | valid anagram | `valid_anagram` |
| 49 | group anagrams | `group_anagrams` |
| 1 | two sum | `two_sum` |
| 202 | happy number | `happy_number` |
| 219 | contains duplicate ii | `contains_duplicate_ii` |
| 128 | longest consecutive | `longest_consecutive` |
| **Intervals** | | |
| 228 | summary ranges | `summary_ranges` |
| 56 | merge intervals | `merge_intervals` |
| 57 | insert interval | `insert_interval` |
| 452 | min arrows balloons | `min_arrows_balloons` |
| **Stack** | | |
| 20 | valid parentheses | `valid_parentheses` |
| 71 | simplify path | `simplify_path` |
| 155 | min stack | `min_stack` |
| 150 | eval rpn | `eval_rpn` |
| 224 | basic calculator | `basic_calculator` |
| **Linked List** | | |
| 141 | linked list cycle | `linked_list_cycle` |
| 2 | add two numbers | `add_two_numbers` |
| 21 | merge two lists | `merge_two_lists` |
| 138 | copy random list | `copy_random_list` |
| 92 | reverse linked list ii | `reverse_linked_list_ii` |
| 25 | reverse k group | `reverse_k_group` |
| 19 | remove nth from end | `remove_nth_from_end` |
| 82 | remove dups list ii | `remove_dups_list_ii` |
| 61 | rotate list | `rotate_list` |
| 86 | partition list | `partition_list` |
| 146 | lru cache | `lru_cache` |
| **Binary Tree General** | | |
| 104 | max depth tree | `max_depth_tree` |
| 100 | same tree | `same_tree` |
| 226 | invert tree | `invert_tree` |
| 101 | symmetric tree | `symmetric_tree` |
| 105 | build tree pre in | `build_tree_pre_in` |
| 106 | build tree in post | `build_tree_in_post` |
| 117 | populating next ii | `populating_next_ii` |
| 114 | flatten tree | `flatten_tree` |
| 112 | path sum | `path_sum` |
| 129 | sum root to leaf | `sum_root_to_leaf` |
| 124 | max path sum | `max_path_sum` |
| 173 | bst iterator | `bst_iterator` |
| 222 | count complete nodes | `count_complete_nodes` |
| 236 | lca binary tree | `lca_binary_tree` |
| **Binary Tree BFS** | | |
| 199 | right side view | `right_side_view` |
| 637 | average of levels | `average_of_levels` |
| 102 | level order | `level_order` |
| 103 | zigzag level order | `zigzag_level_order` |
| **BST** | | |
| 530 | min abs diff bst | `min_abs_diff_bst` |
| 230 | kth smallest bst | `kth_smallest_bst` |
| 98 | validate bst | `validate_bst` |
| **Graph General** | | |
| 200 | number of islands | `number_of_islands` |
| 130 | surrounded regions | `surrounded_regions` |
| 133 | clone graph | `clone_graph` |
| 399 | evaluate division | `evaluate_division` |
| 207 | course schedule | `course_schedule` |
| 210 | course schedule ii | `course_schedule_ii` |
| **Graph BFS** | | |
| 909 | snakes and ladders | `snakes_and_ladders` |
| 433 | min genetic mutation | `min_genetic_mutation` |
| 127 | word ladder | `word_ladder` |
| **Trie** | | |
| 208 | implement trie | `implement_trie` |
| 211 | add search word | `add_search_word` |
| 212 | word search ii | `word_search_ii` |
| **Backtracking** | | |
| 17 | letter combinations | `letter_combinations` |
| 77 | combinations | `combinations` |
| 46 | permutations | `permutations` |
| 39 | combination sum | `combination_sum` |
| 52 | n queens ii | `n_queens_ii` |
| 22 | generate parentheses | `generate_parentheses` |
| 79 | word search | `word_search` |
| **Divide & Conquer** | | |
| 108 | sorted array to bst | `sorted_array_to_bst` |
| 148 | sort list | `sort_list` |
| 427 | construct quad tree | `construct_quad_tree` |
| 23 | merge k lists | `merge_k_lists` |
| **Kadane's** | | |
| 53 | maximum subarray | `maximum_subarray` |
| 918 | max circular subarray | `max_circular_subarray` |
| **Binary Search** | | |
| 35 | search insert | `search_insert` |
| 74 | search 2d matrix | `search_2d_matrix` |
| 162 | find peak element | `find_peak_element` |
| 33 | search rotated | `search_rotated` |
| 34 | first last position | `first_last_position` |
| 153 | find min rotated | `find_min_rotated` |
| 4 | median two sorted | `median_two_sorted` |
| **Heap** | | |
| 215 | kth largest | `kth_largest` |
| 502 | ipo | `ipo` |
| 373 | k pairs smallest sums | `k_pairs_smallest_sums` |
| 295 | median data stream | `median_data_stream` |
| **Bit Manipulation** | | |
| 67 | add binary | `add_binary` |
| 190 | reverse bits | `reverse_bits` |
| 191 | hamming weight | `hamming_weight` |
| 136 | single number | `single_number` |
| 137 | single number ii | `single_number_ii` |
| 201 | range bitwise and | `range_bitwise_and` |
| **Math** | | |
| 9 | palindrome number | `palindrome_number` |
| 66 | plus one | `plus_one` |
| 172 | factorial trailing zeroes | `factorial_trailing_zeroes` |
| 69 | sqrt x | `sqrt_x` |
| 50 | pow x n | `pow_x_n` |
| 149 | max points line | `max_points_line` |
| **1D DP** | | |
| 70 | climbing stairs | `climbing_stairs` |
| 198 | house robber | `house_robber` |
| 139 | word break | `word_break` |
| 322 | coin change | `coin_change` |
| 300 | longest increasing subsequence | `longest_increasing_subsequence` |
| **Multidimensional DP** | | |
| 120 | triangle | `triangle` |
| 64 | min path sum | `min_path_sum` |
| 63 | unique paths ii | `unique_paths_ii` |
| 5 | longest palindromic substring | `longest_palindromic_substring` |
| 97 | interleaving string | `interleaving_string` |
| 72 | edit distance | `edit_distance` |
| 123 | stock iii | `stock_iii` |
| 188 | stock iv | `stock_iv` |
| 221 | maximal square | `maximal_square` |

_150 problems. Extras outside the plan (from LeetCode 75 and the
translator smoke tests) also live under `problems/`._
