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
#   data_and_input.rego  ← this file  (fix the policy)
#   data.json            ← base data  (fix the permissions table)
#   data_and_input_test.rego  ← tests (do NOT edit)
#
# Task:
#   Two things need to be fixed:
#
#   1. In THIS FILE — the rule body reads the role from the wrong path.
#      The tests send input shaped like:
#        { "user": { "role": "viewer" }, "action": "read" }
#      Change the role lookup so it reads from `input.user.role` instead of
#      the current (incorrect) path.
#
#   2. In data.json — the `viewer` role has an empty permissions list,
#      so viewers can never do anything. Add `"read"` to the viewer
#      permissions so the tests that expect viewers to read can pass.

package policy_language.data_and_input

import rego.v1

default allow := false

allow if {
	# TODO: fix this — role should come from input.user.role
	role := input.role
	action := input.action
	action in data.permissions[role]
}
