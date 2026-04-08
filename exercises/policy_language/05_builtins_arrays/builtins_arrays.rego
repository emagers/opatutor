# Exercise 05 - Built-in Functions: Arrays
#
# Overview:
#   Rego provides several builtins to work with arrays and collections:
#
#   - `count(collection)` — number of elements.
#   - `sum(array)` / `product(array)` — numeric aggregation.
#   - `min(array)` / `max(array)` — extremes.
#   - `sort(array)` — returns a new sorted array.
#   - `array.concat(a, b)` — concatenates two arrays.
#   - `array.slice(arr, start, stop)` — returns a slice (stop is exclusive).
#   - `any(array)` / `all(array)` — boolean aggregation over an array of bools.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-reference/#aggregates
#   https://www.openpolicyagent.org/docs/latest/policy-reference/#arrays-2
#
# Task:
#   Three rules need fixing:
#
#   1. `request_count` should return the number of items in `input.requests`.
#      The body uses `sum` — change it to the correct builtin.
#
#   2. `sorted_scores` should return `input.scores` in ascending order.
#      The body returns the array as-is — wrap it with the correct builtin.
#
#   3. `top_three` should return the first 3 elements of `input.items`.
#      The slice stop index is wrong — fix it (remember stop is exclusive and
#      array.slice uses zero-based indices, so the first 3 elements end at
#      index 3).

package policy_language.builtins_arrays

import rego.v1

request_count := n if {
	# TODO: fix the builtin — we want the count, not the sum
	n := sum(input.requests)
}

sorted_scores := scores if {
	# TODO: wrap input.scores with the correct sorting builtin
	scores := input.scores
}

top_three := items if {
	# TODO: fix the stop index so we get elements 0, 1, and 2
	items := array.slice(input.items, 0, 2)
}
