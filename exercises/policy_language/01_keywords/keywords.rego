# Exercise 01 - Keywords: default, not, if
#
# Overview:
#   Rego reserves several keywords to structure policies. This exercise covers
#   the three you will use in almost every policy you write:
#
#   `default`
#     Declares a fallback value for a rule when no other definition fires.
#     Without it, a rule that never matches is simply "undefined" — callers
#     cannot easily reason about that. Syntax:
#       default <rule_name> := <value>
#
#   `if`
#     Separates the rule head from the rule body. Required when using
#     `import rego.v1`. Syntax:
#       <rule_name> if { <body> }
#
#   `not`
#     Negation-as-failure: the expression that follows must be FALSE or
#     UNDEFINED for `not` to succeed. Syntax:
#       not <expression>
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-language/#keywords
#
# Input structure:
#   {
#     "user": {
#       "role":        string,  -- e.g. "admin", "editor", "viewer"
#       "mfa_enabled": boolean  -- whether multi-factor auth is active
#     }
#   }
#
# Example inputs / expected results:
#   { "user": { "role": "admin",  "mfa_enabled": true  } }
#       → allow = true,  mfa_required = false
#   { "user": { "role": "viewer", "mfa_enabled": false } }
#       → allow = false, mfa_required = true
#   {}
#       → allow = false  (default kicks in)
#
# Tasks:
#   1. Use the `default` keyword to declare `allow` with a fallback of false.
#
#   2. Write an `allow` rule (using the `if` keyword) that is true when
#      input.user.role equals "admin".
#
#   3. Write an `mfa_required` rule that is true when the user does NOT have
#      MFA enabled. Use the `not` keyword to express this negation.

package policy_language.keywords

import rego.v1

# TODO 1: declare `allow` with a default of false
# default allow := ...

# TODO 2: write an allow rule — true when input.user.role == "admin"
# allow if {
#     ...
# }

# TODO 3: write mfa_required — true when input.user.mfa_enabled is NOT true
# mfa_required if {
#     ...
# }
