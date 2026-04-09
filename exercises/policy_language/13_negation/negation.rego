# Exercise 13 - Negation and the `else` Keyword
#
# Overview:
#   NEGATION AS FAILURE
#   In Rego, `not expr` is true when `expr` is FALSE or UNDEFINED. This is
#   called "negation as failure" — OPA cannot prove the expression, so it
#   treats it as false. This is different from classical Boolean negation.
#
#   Pattern — deny-overrides:
#     allow if { not is_blocked }
#     is_blocked if { input.ip in data.blocklist }
#   This keeps the "what is dangerous" logic isolated in helper rules.
#
#   THE `else` KEYWORD
#   `else` provides a fallback value for a rule if the primary body is
#   undefined. It is similar to a default, but can carry a conditional body:
#     decision := "allow" if { input.score > 80 }
#     else := "review"   if { input.score > 50 }
#     else := "deny"
#   The first branch that fires wins; subsequent branches are ignored.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-language/#negation
#   https://www.openpolicyagent.org/docs/latest/policy-language/#else-keyword
#
# Input structure:
#   {
#     "ip":       string,   -- the requesting IP address
#     "country":  string,   -- country code, e.g. "US", "CN", "DE"
#     "score":    number,   -- risk score 0–100 (higher = riskier)
#     "action":   string    -- the requested action
#   }
#
# data structure (loaded from data.json in this directory):
#   {
#     "blocklist":          [string, ...],  -- blocked IP addresses
#     "sanctioned_countries": [string, ...]  -- blocked country codes
#   }
#
# Example inputs / expected results:
#   ip="1.2.3.4" (not blocked), country="US" (not sanctioned), score=20
#       → allow = true,   risk_decision = "allow"
#   ip="5.6.7.8" (blocked)
#       → allow = false  (blocked IP)
#   country="CN" (sanctioned)
#       → allow = false  (sanctioned country)
#   score=85
#       → risk_decision = "deny"
#   score=60
#       → risk_decision = "review"
#   score=30
#       → risk_decision = "allow"
#
# Tasks:
#   1. Write `is_blocked_ip` — true when `input.ip` is in `data.blocklist`.
#
#   2. Write `is_sanctioned_country` — true when `input.country` is in
#      `data.sanctioned_countries`.
#
#   3. Use `not` to write `allow` — true when the IP is NOT blocked AND the
#      country is NOT sanctioned.
#
#   4. Use `else` chains to write `risk_decision`:
#        "deny"   when input.score > 80
#        "review" when input.score > 50  (and not > 80)
#        "allow"  otherwise

package policy_language.negation

import rego.v1

# TODO 1: true when input.ip is in data.blocklist
# is_blocked_ip if { ... }

# TODO 2: true when input.country is in data.sanctioned_countries
# is_sanctioned_country if { ... }

# TODO 3: use `not` — allow when IP is not blocked AND country is not sanctioned
# default allow := false
# allow if { ... }

# TODO 4: use `else` chains — "deny" > "review" > "allow"
# risk_decision := "deny"   if { ... }
# else          := "review" if { ... }
# else          := "allow"

# --- stubs (tests will fail until you complete the TODOs above) ---
is_blocked_ip if { false }

is_sanctioned_country if { false }

default allow := false

risk_decision := "" if { false }
