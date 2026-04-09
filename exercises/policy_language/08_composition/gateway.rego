# Exercise 08 - Policy Composition
#
# Overview:
#   Rego policies are organized into packages, and one package can reference
#   rules from another using the `import` keyword (or a full `data.*` path).
#
#   This enables layered policies: a lower-level package defines fine-grained
#   rules, and a higher-level package composes them without duplicating logic.
#
#   Import syntax:
#     import data.myapp.authz           # import the whole package as `authz`
#     import data.myapp.authz.allow     # import a single rule
#
#   After importing a package, reference its rules by the last segment:
#     authz.allow   (after `import data.myapp.authz`)
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-language/#imports
#
# Files in this exercise:
#   permissions.rego      ← low-level permission rules (do NOT edit)
#   gateway.rego          ← this file — write the gateway policy
#   data.json             ← blocked resources list (do NOT edit)
#   composition_test.rego ← tests (do NOT edit)
#
# permissions.rego exposes:
#   user_can — true when input.user.role grants input.action
#
# data.json structure:
#   { "blocked_resources": ["quarantine-bucket", ...] }
#
# Input structure:
#   {
#     "user":     { "role": string },   -- e.g. "admin", "editor", "viewer"
#     "action":   string,               -- e.g. "read", "write", "delete"
#     "resource": { "name": string }    -- the resource being accessed
#   }
#
# Example inputs / expected results:
#   { "user": {"role": "admin"}, "action": "write", "resource": {"name": "logs"} }
#       → allow = true
#   { "user": {"role": "admin"}, "action": "read", "resource": {"name": "quarantine-bucket"} }
#       → allow = false  (blocked resource)
#   { "user": {"role": "viewer"}, "action": "write", "resource": {"name": "logs"} }
#       → allow = false  (insufficient permission)
#
# Tasks:
#   1. Import the permissions package so this module can call `permissions.user_can`.
#      The package path is: data.policy_language.composition.permissions
#
#   2. Write a `default allow := false` declaration.
#
#   3. Write the `allow` rule: it should be true when BOTH of these hold:
#        a) `permissions.user_can` is true  (the user's role grants the action)
#        b) the resource name is NOT in `data.blocked_resources`
#      Use `not ... in` to check the blocked-resources exclusion.

package policy_language.composition.gateway

import rego.v1

# TODO 1: add the import for the permissions package
# import data.policy_language.composition.permissions

# TODO 2: declare allow with a default of false
# default allow := ...

# TODO 3: write the allow rule using permissions.user_can and data.blocked_resources
# allow if {
#     ...
# }

# --- stubs (tests will fail until you complete the TODOs above) ---
default allow := false
