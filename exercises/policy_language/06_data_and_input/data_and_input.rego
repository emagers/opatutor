# Exercise 06 - Data vs Input
#
# Overview:
#   Every OPA evaluation works with two distinct documents:
#
#   `input`  — the dynamic document provided at query time.
#              It represents the thing being evaluated right now: an HTTP
#              request, a Kubernetes admission review, a JWT token, etc.
#              It changes with every call to OPA and is never persisted.
#
#   `data`   — the base document built from everything OPA has loaded:
#              your Rego modules, JSON/YAML data files, and bundle data.
#              It is the static world-knowledge the policy reasons about —
#              configuration tables, allow-lists, role mappings, etc.
#
#   A common pattern is to store a role-to-permissions mapping in `data`
#   (loaded once from a config file) and receive the requesting user's
#   role through `input` (provided per-request).
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/philosophy/#the-opa-document-model
#
# Files in this exercise:
#   data_and_input.rego       ← this file (write the policy)
#   data.json                 ← permissions table, already complete (do NOT edit)
#   data_and_input_test.rego  ← tests (do NOT edit)
#
# data.json structure:
#   {
#     "permissions": {
#       "admin":  ["read", "write", "delete"],
#       "editor": ["read", "write"],
#       "viewer": ["read"]
#     }
#   }
#
# Input structure:
#   {
#     "user":   { "role": string },  -- e.g. "admin", "editor", "viewer"
#     "action": string               -- e.g. "read", "write", "delete"
#   }
#
# Example inputs / expected results:
#   { "user": { "role": "admin" }, "action": "delete" }  → allow = true
#   { "user": { "role": "viewer" }, "action": "write" }  → allow = false
#   { "user": { "role": "viewer" }, "action": "read" }   → allow = true
#   {}                                                   → allow = false
#
# Tasks:
#   1. Use the `default` keyword so `allow` falls back to false.
#
#   2. Write an `allow` rule that looks up the requesting user's role from
#      `input.user.role`, then checks whether `input.action` is contained in
#      the list `data.permissions[role]`.
#      Use the `in` keyword for the membership check.

package policy_language.data_and_input

import rego.v1

# TODO 1: declare allow with a default of false
# default allow := ...

# TODO 2: write allow — look up input.user.role in data.permissions,
#         then check that input.action is in the allowed list
# allow if {
#     ...
# }

# --- stubs (tests will fail until you complete the TODOs above) ---
default allow := false
