# Exercise 08 - Policy Composition
#
# Overview:
#   Rego policies are organized into packages, and one package can reference
#   rules from another using the `import` keyword (or by using the full
#   `data.<package>.<rule>` path).
#
#   This is useful for building layered policies: a low-level "authz" package
#   defines fine-grained rules, and a higher-level "gateway" package composes
#   those rules into a single decision without duplicating logic.
#
#   Two import styles:
#     import data.myapp.authz           # import the whole package
#     import data.myapp.authz.allow     # import a single rule
#
#   After importing, you can reference rules from the imported package by its
#   last path segment (e.g. `authz.allow` after `import data.myapp.authz`).
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-language/#imports
#
# Files in this exercise:
#   permissions.rego      ← low-level permission rules (do NOT edit)
#   gateway.rego          ← this file — composes permissions.rego (fix this)
#   data.json             ← blocked resources list (do NOT edit)
#   composition_test.rego ← tests (do NOT edit)
#
# Task:
#   The gateway policy should grant access when the requesting user has the
#   required permission AND the resource is not in the blocked list.
#
#   Two things need to be fixed in this file:
#
#   1. The import path is wrong. The permissions package lives at
#      `policy_language.composition.permissions` — fix the import so the
#      gateway can reference `permissions.user_can` correctly.
#
#   2. The `allow` rule calls `permissions.user_can` through the full
#      `data.*` path instead of using the imported alias. Replace the
#      long path with the short alias `permissions.user_can`.

package policy_language.composition.gateway

import rego.v1

# TODO: fix the import path — should be data.policy_language.composition.permissions
import data.policy_language.permissions

default allow := false

allow if {
	# TODO: replace this long path with the short alias from the import above
	data.policy_language.permissions_wrong_path.user_can
	not input.resource.name in data.blocked_resources
}
