# Exercise 12 - User-Defined Functions
#
# Overview:
#   Rego supports user-defined functions (also called *custom rules with
#   arguments*). Functions let you extract reusable logic and call it with
#   different inputs, just like functions in other languages.
#
#   Syntax:
#     my_function(arg1, arg2) := result if {
#       # body that computes result
#     }
#
#   Functions can be partial too — multiple definitions with the same name
#   and different patterns:
#     classify(score) := "high"   if { score >= 80 }
#     classify(score) := "medium" if { score >= 50; score < 80 }
#     classify(score) := "low"    if { score < 50 }
#
#   Functions are called like any other expression:
#     label := classify(input.score)
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-language/#functions
#
# Input structure:
#   {
#     "scores":   [number, ...],          -- list of numeric scores (0–100)
#     "requests": [                       -- HTTP requests
#       { "method": string, "path": string }
#     ]
#   }
#
# Example inputs / expected results:
#   { "scores": [92, 55, 30, 80] }
#       → score_labels = ["high", "medium", "low", "high"]
#   { "requests": [
#       {"method": "GET",    "path": "/api/users"},
#       {"method": "DELETE", "path": "/api/users"},
#       {"method": "GET",    "path": "/health"}
#     ] }
#       → safe_paths = {"/api/users", "/health"}   (GET only)
#
# Tasks:
#   1. Write a function `classify(score)` that returns:
#        "high"   when score >= 80
#        "medium" when score >= 50 and score < 80
#        "low"    when score < 50
#      Use multiple function definitions (one per branch).
#
#   2. Write `score_labels` — an array comprehension that calls `classify`
#      for each score in `input.scores`, preserving order.
#
#   3. Write a function `is_safe_request(req)` that returns true when
#      the request method is "GET".
#
#   4. Write `safe_paths` — a set comprehension that collects the `path` of
#      each request in `input.requests` for which `is_safe_request` is true.

package policy_language.functions

import rego.v1

# TODO 1: write the classify function (three definitions, one per branch)
# classify(score) := "high" if { ... }
# classify(score) := "medium" if { ... }
# classify(score) := "low" if { ... }

# TODO 2: write score_labels using an array comprehension and classify
# score_labels := [... | ...]

# TODO 3: write is_safe_request — true when req.method == "GET"
# is_safe_request(req) if { ... }

# TODO 4: write safe_paths using a set comprehension and is_safe_request
# safe_paths := {... | ...}
