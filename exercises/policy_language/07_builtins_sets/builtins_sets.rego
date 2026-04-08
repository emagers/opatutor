# Exercise 07 - Built-in Functions: Sets
#
# Overview:
#   A set in Rego is an unordered collection of unique values.
#   Sets are written with curly braces: {1, 2, 3}
#   An empty set must be written as `set()` (not `{}`, which is an empty object).
#
#   Set operations:
#   - `x | y`      — union: all elements from both sets.
#   - `x & y`      — intersection: only elements present in both sets.
#   - `x - y`      — difference: elements in x that are NOT in y.
#   - `elem in s`  — membership test.
#   - `count(s)`   — number of elements.
#
#   Set comprehensions produce a set inline:
#     { expr | iterator; condition }
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-reference/#sets-2
#
# Input structure:
#   {
#     "scopes":  set of strings,   -- scopes the caller currently has
#     "tags_a":  set of strings,   -- first set of resource tags
#     "tags_b":  set of strings,   -- second set of resource tags
#     "users": [                   -- list of user objects
#       { "name": string, "role": string, "active": boolean }
#     ]
#   }
#
# Example inputs / expected results:
#   { "scopes": {"read"} }
#       → missing_scopes = {"write", "admin"}
#   { "tags_a": {"web", "prod", "api"}, "tags_b": {"prod", "api", "db"} }
#       → common_tags = {"prod", "api"}
#   { "users": [
#       {"name": "alice", "role": "admin", "active": true},
#       {"name": "bob",   "role": "admin", "active": false}
#     ] }
#       → privileged_and_active = {"alice"}
#
# Tasks:
#   1. Write `missing_scopes` — a complete rule that computes the set
#      difference between `required_scopes` and `input.scopes`.
#      Use the `-` operator.
#
#   2. Write `common_tags` — a complete rule that returns the intersection
#      of `input.tags_a` and `input.tags_b`.
#      Use the `&` operator.
#
#   3. Write `privileged_and_active` — a partial set rule that collects the
#      `name` of every user in `input.users` whose role is "admin" AND whose
#      `active` field is true.

package policy_language.builtins_sets

import rego.v1

required_scopes := {"read", "write", "admin"}

# TODO 1: write a complete rule — return the set difference
#         (required_scopes minus input.scopes)
# missing_scopes := ... {
#     ...
# }

# TODO 2: write a complete rule — return the intersection of input.tags_a and input.tags_b
# common_tags := ... {
#     ...
# }

# TODO 3: write a partial set rule — collect names of users where
#         role == "admin" AND active == true
# privileged_and_active contains user.name if {
#     ...
# }
