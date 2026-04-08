# Exercise 02 - Variables
#
# Overview:
#   In Rego, variables are assigned by *unification*, not imperative assignment.
#   When a variable name appears for the first time in a rule body, Rego binds
#   it to a value that satisfies every expression in the body simultaneously.
#
#   Variables are local to the rule they appear in — they cannot be shared
#   across rules, and once bound within an evaluation they do not change.
#
#   Implicit iteration: using `_` (or a named variable) as an array/set index
#   makes Rego try every element automatically. A partial rule body that
#   iterates like this fires once per matching element, and the results
#   accumulate into the rule's output set.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-language/#variables
#
# Input structure:
#   {
#     "ports":    [number, ...],   -- TCP port numbers to evaluate
#     "requests": [                -- HTTP request objects
#       { "method": string, "path": string, "user": string }
#     ]
#   }
#
# Example inputs / expected results:
#   { "ports": [80, 443, 8080, 22, 3306] }
#       → risky_ports = {80, 443, 22}          (ports < 1024)
#   { "requests": [
#       {"method": "DELETE", "path": "/api/users", "user": "alice"},
#       {"method": "GET",    "path": "/health",    "user": "bob"}
#     ] }
#       → destructive_users = {"alice"}
#
# Tasks:
#   1. Write the `risky_ports` partial set rule that collects every port from
#      `input.ports` that is strictly less than 1024 (privileged ports).
#      Bind each element to a variable, then add a comparison expression.
#
#   2. Write the `destructive_users` partial set rule that collects the `user`
#      field from every request in `input.requests` whose `method` is "DELETE".

package policy_language.variables

import rego.v1

# TODO 1: write a partial set rule — collect ports from input.ports
#         where the port is strictly less than 1024
# risky_ports contains port if {
#     ...
# }

# TODO 2: write a partial set rule — collect the user field from each request
#         in input.requests where request.method == "DELETE"
# destructive_users contains user if {
#     ...
# }

# --- stubs (tests will fail until you complete the TODOs above) ---
risky_ports contains port if {
	port := input.ports[_]
	false
}

destructive_users contains user if {
	user := input.requests[_].user
	false
}
