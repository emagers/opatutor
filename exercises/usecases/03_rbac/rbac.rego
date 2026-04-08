# Exercise - Role-Based Access Control (RBAC)
#
# Overview:
#   RBAC is one of the most common patterns implemented with OPA. The core idea:
#   users are assigned one or more roles, and roles are granted permissions.
#   A user may perform an action if any role they hold grants it.
#
#   Key OPA patterns used here:
#   - Looking up data from `data` (role definitions) and `input` (the request)
#   - Partial set rules to collect all permissions for a user across all roles
#   - `every` for checking that all required permissions are present
#   - OR logic via multiple partial rule definitions
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/comparison-to-other-systems/#rbac
#
# Files in this exercise:
#   rbac.rego       ← this file (write the policy)
#   data.json       ← role definitions (do NOT edit)
#   rbac_test.rego  ← tests (do NOT edit)
#
# data.json structure:
#   {
#     "roles": {
#       "admin":     { "permissions": ["read","write","delete","manage_users"] },
#       "developer": { "permissions": ["read","write"] },
#       "auditor":   { "permissions": ["read","audit"] },
#       "viewer":    { "permissions": ["read"] }
#     },
#     "user_roles": {
#       "alice": ["admin"],
#       "bob":   ["developer", "auditor"],
#       "carol": ["viewer"]
#     }
#   }
#
# Input structure:
#   {
#     "user":   string,   -- username, e.g. "alice"
#     "action": string    -- the action being requested, e.g. "write"
#   }
#
# Example inputs / expected results:
#   { "user": "alice", "action": "manage_users" } → allow = true
#   { "user": "bob",   "action": "audit"        } → allow = true   (via auditor role)
#   { "user": "bob",   "action": "delete"       } → allow = false
#   { "user": "carol", "action": "read"         } → allow = true
#   { "user": "carol", "action": "write"        } → allow = false
#   { "user": "unknown", "action": "read"       } → allow = false
#
# Tasks:
#   1. Write `user_permissions` — a partial set rule that collects every
#      permission granted to `input.user` across ALL of their assigned roles.
#      Iterate over `data.user_roles[input.user]` to get each role name,
#      then iterate over `data.roles[role].permissions` for each permission.
#
#   2. Write `allow` — true when `input.action` is in `user_permissions`.
#      Use the `in` keyword.
#      Add a `default allow := false` so unrecognised users are denied.

package usecases.rbac

import rego.v1

# TODO 1: collect all permissions for the requesting user across all their roles
# user_permissions contains perm if {
#     some role in data.user_roles[input.user]
#     ...
# }

# TODO 2: allow when the requested action is in user_permissions
# default allow := false
# allow if { ... }
