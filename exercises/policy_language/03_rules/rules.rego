# Exercise 03 - Rules: Complete and Partial
#
# Overview:
#   Rego has two categories of rules:
#
#   *Complete rules* assign a single value to a name. If two complete rules
#   with the same name could both fire with different values, OPA raises a
#   conflict error at query time. Use them for configuration constants and
#   definitive allow/deny decisions.
#     Syntax:  name := value             (unconditional)
#              name := value if { body } (conditional)
#
#   *Partial rules* accumulate values across many rule definitions.
#   - Partial SET rules use `contains` — each matching body adds an element.
#     Syntax:  name contains element if { body }
#   - Partial OBJECT rules use `[key] :=` — each matching body adds a key.
#     Syntax:  name[key] := value if { body }
#   Multiple definitions of the same partial rule never conflict; they simply
#   contribute more data to the result.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-language/#rules
#
# Input structure:
#   {
#     "regions":  [string, ...],     -- cloud region IDs, e.g. "us-east-1"
#     "services": [                  -- service descriptors
#       { "name": string, "replicas": number }
#     ]
#   }
#
# Example inputs / expected results:
#   { "regions": ["us-east-1", "eu-west-1", "us-west-2", "ap-south-1"] }
#       → approved_regions = {"us-east-1", "us-west-2"}
#   { "services": [{"name": "api", "replicas": 2}, {"name": "db", "replicas": 5}] }
#       → replica_counts = {"api": 2, "db": 5}
#
# Tasks:
#   1. Write a complete rule `max_retries` that always returns the integer 3.
#
#   2. Write a partial set rule `approved_regions` that collects every region
#      from `input.regions` that starts with the prefix "us-".
#      Use the `startswith` built-in to test each region.
#
#   3. Write a partial object rule `replica_counts` that maps each service's
#      `name` to its `replicas` count, iterating over `input.services`.

package policy_language.rules

import rego.v1

# TODO 1: write a complete rule — max_retries should always equal 3
# max_retries := ...

# TODO 2: write a partial set rule — collect regions from input.regions
#         where the region starts with "us-"
# approved_regions contains r if {
#     ...
# }

# TODO 3: write a partial object rule — map service name → replica count
# replica_counts[name] := replicas if {
#     ...
# }

# --- stubs (tests will fail until you complete the TODOs above) ---
max_retries := 0 if { false }

approved_regions contains r if {
	r := input.regions[_]
	false
}

replica_counts[key] := val if {
	key := input.services[_].name
	val := 0
	false
}
