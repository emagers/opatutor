# Exercise 11 - Comprehensions
#
# Overview:
#   Comprehensions build new collections inline from existing ones. They are
#   similar to list/set/dict comprehensions in Python.
#
#   Array comprehension — produces an ordered array:
#     [<expr> | <iterator>; <condition>]
#     Example: [x | x := input.nums[_]; x > 0]
#
#   Set comprehension — produces an unordered set of unique values:
#     {<expr> | <iterator>; <condition>}
#     Example: {upper(s) | s := input.names[_]}
#
#   Object comprehension — produces a key-value map:
#     {<key>: <value> | <iterator>; <condition>}
#     Example: {id: doc | doc := data.docs[_]; id := doc.id}
#
#   All three forms can reference `input`, `data`, and any locally bound
#   variable. The iterator and condition parts are optional.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-language/#comprehensions
#
# Input structure:
#   {
#     "users": [
#       { "id": string, "name": string, "score": number, "active": boolean }
#     ]
#   }
#
# Example inputs / expected results:
#   {
#     "users": [
#       {"id": "u1", "name": "Alice", "score": 82, "active": true},
#       {"id": "u2", "name": "Bob",   "score": 45, "active": false},
#       {"id": "u3", "name": "Carol", "score": 91, "active": true}
#     ]
#   }
#   → active_scores   = [82, 91]        (scores of active users, array comprehension)
#   → active_names    = {"Alice","Carol"} (set comprehension)
#   → score_by_id     = {"u1":82,"u3":91} (object comprehension, active only)
#
# Tasks:
#   1. Use an ARRAY comprehension to write `active_scores` — an array of `score`
#      values for every user in `input.users` where `active` is true.
#
#   2. Use a SET comprehension to write `active_names` — a set of `name` values
#      for every active user.
#
#   3. Use an OBJECT comprehension to write `score_by_id` — a map from user `id`
#      to `score` for every active user.

package policy_language.comprehensions

import rego.v1

# TODO 1: array comprehension — collect scores of active users
# active_scores := [... | ...]

# TODO 2: set comprehension — collect names of active users
# active_names := {... | ...}

# TODO 3: object comprehension — map id → score for active users
# score_by_id := {... | ...}

# --- stubs (tests will fail until you complete the TODOs above) ---
active_scores := [] if { false }

active_names := set() if { false }

score_by_id := {} if { false }
