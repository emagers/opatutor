# Exercise 01 - Keywords
#
# Overview:
#   Rego uses a set of reserved keywords to define the structure of a policy.
#   The most fundamental keywords are: package, import, default, and not.
#
#   - `package` declares the namespace of the policy module.
#   - `default` sets a fallback value for a rule when no other rule produces a result.
#   - `not` negates a condition; it is true when the following expression is false or undefined.
#   - `if` separates the rule head from the body (optional but recommended for clarity).
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-language/#keywords
#
# Task:
#   The rule `allow` below should default to false, but the keyword has been
#   left out. Add the missing keyword so that `allow` is false when no other
#   rule grants access.
#   The rule `allow` should also return true when the input role is "admin".
#   The body of that rule uses `not` to check for a non-admin role — fix the
#   condition so it actually grants access to admins (hint: remove the negation).

package policy_language.keywords

import rego.v1

# TODO: add the `default` keyword before `allow` so it falls back to false
allow := false

allow if {
	# TODO: this currently denies admins — fix the condition
	not input.role == "admin"
}
