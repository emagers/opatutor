# Exercise 09 - AND and OR Logic
#
# Overview:
#   Rego expresses boolean logic structurally — there are no explicit `&&` or
#   `||` operators. Instead:
#
#   AND logic — put multiple expressions inside one rule body. Every expression
#   must be true for the rule to be true:
#     allow if {
#       input.user.role == "admin"   # condition A
#       input.action == "write"      # condition B  (A AND B)
#     }
#
#   OR logic — define multiple rules with the same name. The rule is true if
#   ANY of its definitions fires:
#     allow if { input.user.role == "admin"  }   # definition 1
#     allow if { input.user.role == "editor" }   # definition 2  (1 OR 2)
#
#   These two patterns compose: you can have AND inside each OR branch.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-language/#logical-or
#
# Input structure:
#   {
#     "user": {
#       "role":       string,   -- "admin" | "editor" | "auditor" | "viewer"
#       "department": string,   -- e.g. "engineering", "finance"
#       "verified":   boolean
#     },
#     "action":   string,   -- "read" | "write" | "delete" | "audit"
#     "resource": {
#       "classification": string,  -- "public" | "internal" | "confidential"
#       "region":         string   -- e.g. "us-east-1", "eu-west-1"
#     }
#   }
#
# Example inputs / expected results:
#   { "user": {"role": "admin",   "verified": true},  "action": "delete",
#     "resource": {"classification": "confidential", "region": "us-east-1"} }
#       → allow = true
#   { "user": {"role": "editor",  "verified": true},  "action": "write",
#     "resource": {"classification": "internal", "region": "us-east-1"} }
#       → allow = true
#   { "user": {"role": "viewer",  "verified": false}, "action": "read",
#     "resource": {"classification": "public", "region": "us-east-1"} }
#       → allow = false  (viewer not verified)
#   { "user": {"role": "auditor", "verified": true},  "action": "audit",
#     "resource": {"classification": "confidential", "region": "us-east-1"} }
#       → allow = true
#
# Tasks:
#   Implement `allow` using AND and OR logic to match these rules:
#
#   Rule A — Admins: allow when role is "admin" AND user is verified.
#
#   Rule B — Editors: allow when role is "editor" AND action is "write" or "read"
#            AND resource classification is NOT "confidential".
#
#   Rule C — Auditors: allow when role is "auditor" AND action is "audit".
#
#   Rule D — Public read: allow when resource classification is "public"
#            AND action is "read" AND user is verified.
#
#   Each rule should be a separate definition of `allow` (OR between definitions,
#   AND within each definition body).

package policy_language.and_or_logic

import rego.v1

default allow := false

# TODO Rule A: allow for verified admins
# allow if {
#     ...
# }

# TODO Rule B: allow for editors reading/writing non-confidential resources
# allow if {
#     ...
# }

# TODO Rule C: allow for auditors performing the audit action
# allow if {
#     ...
# }

# TODO Rule D: allow verified users to read public resources
# allow if {
#     ...
# }
