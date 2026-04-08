# Exercise 05 - Built-in Functions: Arrays
#
# Overview:
#   Rego provides several builtins to work with arrays and collections:
#
#   - `count(collection)` — number of elements.
#   - `sum(array)` / `product(array)` — numeric aggregation.
#   - `min(array)` / `max(array)` — smallest / largest value.
#   - `sort(array)` — returns a new array sorted in ascending order.
#   - `array.concat(a, b)` — concatenates two arrays into one.
#   - `array.slice(arr, start, stop)` — sub-array from start (inclusive) to
#     stop (exclusive); zero-based indices.
#   - `any(array)` / `all(array)` — boolean aggregation over an array of bools.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-reference/#aggregates
#   https://www.openpolicyagent.org/docs/latest/policy-reference/#arrays-2
#
# Input structure:
#   {
#     "requests": [any, ...],  -- a list of arbitrary items to count
#     "scores":   [number, ...],  -- unsorted numeric scores
#     "items":    [any, ...],     -- a list to slice the top elements from
#     "durations": [number, ...]  -- response times in milliseconds
#   }
#
# Example inputs / expected results:
#   { "requests": ["a", "b", "c", "d"] }
#       → request_count = 4
#   { "scores": [42, 7, 99, 3, 55] }
#       → sorted_scores = [3, 7, 42, 55, 99]
#   { "items": ["alpha", "beta", "gamma", "delta", "epsilon"] }
#       → top_three = ["alpha", "beta", "gamma"]
#   { "durations": [120, 45, 300, 80] }
#       → max_duration = 300
#
# Tasks:
#   1. Use `count` to write `request_count` — a complete rule returning the
#      number of items in `input.requests`.
#
#   2. Use `sort` to write `sorted_scores` — a complete rule returning
#      `input.scores` sorted in ascending order.
#
#   3. Use `array.slice` to write `top_three` — a complete rule returning
#      only the first 3 elements of `input.items`.
#
#   4. Use `max` to write `max_duration` — a complete rule returning the
#      largest value in `input.durations`.

package policy_language.builtins_arrays

import rego.v1

# TODO 1: write a complete rule — return the count of items in input.requests
# request_count := n if {
#     ...
# }

# TODO 2: write a complete rule — return input.scores sorted ascending
# sorted_scores := scores if {
#     ...
# }

# TODO 3: write a complete rule — return only the first 3 elements of input.items
# top_three := items if {
#     ...
# }

# TODO 4: write a complete rule — return the maximum value in input.durations
# max_duration := m if {
#     ...
# }
