# Exercise 07 - Built-in Functions: Sets
#
# Overview:
#   A set in Rego is an unordered collection of unique values.
#   Sets are written with curly braces: {1, 2, 3}
#   An empty set must be written as `set()` (not `{}`, which is an empty object).
#
#   Useful set operations:
#   - `x | y`          — union: all elements from both sets.
#   - `x & y`          — intersection: only elements present in both sets.
#   - `x - y`          — difference: elements in x that are NOT in y.
#   - `x == y`         — equality.
#   - `count(s)`        — number of elements.
#   - `elem in s`       — membership test (true if elem is in s).
#
#   Comprehensions produce sets inline:
#     { x | x := arr[_]; condition }
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-reference/#sets-2
#
# Task:
#   Three rules need fixing:
#
#   1. `missing_scopes` should return the set of required scopes that are NOT
#      present in `input.scopes`. The operator is wrong — fix it so we get the
#      difference (required minus provided), not the union.
#
#   2. `common_tags` should return the intersection of `input.tags_a` and
#      `input.tags_b`. The operator is wrong — fix it.
#
#   3. `privileged_and_active` should return users from `input.users` whose
#      `role` is "admin" AND whose `active` field is true. The comprehension
#      currently collects users where active is FALSE — fix the condition.

package policy_language.builtins_sets

import rego.v1

required_scopes := {"read", "write", "admin"}

missing_scopes := required_scopes | input.scopes

common_tags := input.tags_a | input.tags_b

privileged_and_active contains user.name if {
	user := input.users[_]
	user.role == "admin"
	user.active == false
}
