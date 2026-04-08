# Exercise 02 - Variables
#
# Overview:
#   In Rego, variables are assigned by unification, not imperative assignment.
#   A variable is defined the first time it appears, and Rego will try to find
#   a value that makes all statements in the rule body true simultaneously.
#
#   Variables in rule bodies are local to that rule. Rego does NOT have mutable
#   state — once a variable is unified with a value, it cannot be reassigned.
#
#   Iteration happens implicitly: when you reference an element of a collection
#   without specifying an index, Rego tries every element in turn.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-language/#variables
#
# Task:
#   The partial rule `risky_ports` should produce the set of ports from
#   `input.ports` that are less than 1024 (privileged ports).
#   The rule body references an element of `input.ports` but the comparison
#   is wrong — it currently keeps ports GREATER than 1024.
#   Fix the comparison operator so only privileged ports (< 1024) are collected.

package policy_language.variables

import rego.v1

risky_ports contains port if {
	# TODO: fix the comparison — we want ports strictly less than 1024
	port := input.ports[_]
	port > 1024
}
