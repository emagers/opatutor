# Exercise 03 - Rules
#
# Overview:
#   Rego has two types of rules: complete rules and partial rules.
#
#   A *complete rule* defines a single value for a given name. If more than one
#   complete rule with the same name is defined in the same package and their
#   bodies can both be true at the same time with conflicting values, OPA raises
#   an error.
#
#   A *partial rule* (also called an incremental rule) collects values into a
#   set or key-value pairs into an object. Multiple partial rules with the same
#   name simply contribute more values to the result.
#
#   Rule heads use `contains` to build sets and `[key] :=` to build objects.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-language/#rules
#
# Task:
#   Two things need to be fixed:
#
#   1. The complete rule `max_retries` should return the number 3, but it
#      currently returns the wrong value. Change it so it correctly returns 3.
#
#   2. The partial rule `approved_regions` should collect only regions that
#      start with "us-". It currently keeps regions that start with "eu-".
#      Fix the prefix so only US regions are approved.

package policy_language.rules

import rego.v1

# Complete rule — should always return 3
max_retries := 5

# Partial set rule — should collect regions starting with "us-"
approved_regions contains r if {
	r := input.regions[_]
	# TODO: fix the prefix — we want "us-" regions, not "eu-"
	startswith(r, "eu-")
}
