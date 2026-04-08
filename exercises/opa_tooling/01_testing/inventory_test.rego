# Exercise 10 - OPA Testing
#
# Overview:
#   OPA has a built-in test runner that finds and executes any rule whose name
#   starts with `test_`. You run it with:
#
#     opa test <path>              # run all tests under <path>
#     opa test <path> -v           # verbose — shows each test name and result
#     opa test <path> --coverage   # show which lines were exercised
#
#   Test rules follow the same Rego syntax as any other rule. A test passes
#   when its body evaluates to true, and fails when it evaluates to false or
#   is undefined.
#
#   You can use `not` to assert that a rule is NOT true:
#     test_denied { not my_policy.allow with input as {...} }
#
#   The `with` keyword overrides `input` or `data` within the scope of a
#   single expression, making tests self-contained and repeatable.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-testing/
#
# Files in this exercise:
#   inventory.rego       ← the policy being tested (do NOT edit)
#   inventory_test.rego  ← this file — fix the broken test assertions
#   data.json            ← fixture data (do NOT edit)
#
# Task:
#   Each of the three test stubs below has an incorrect assertion. Read what
#   the test is supposed to verify (the comment above each one) and fix the
#   assertion so the test correctly validates the described behaviour.
#
#   The policy rules you are testing (defined in inventory.rego):
#   - `vulnerable_packages` — set of installed package names with high/critical CVEs.
#   - `all_required_present` — true when every package in data.required_packages
#     appears in input.installed.
#   - `compliant` — true when no vulnerable packages AND all required packages present.

package opa_tooling.testing_test

import rego.v1

import data.opa_tooling.inventory

# --- already-complete reference test (do not edit) ---

test_clean_package_not_flagged if {
	result := inventory.vulnerable_packages with input as {
		"installed": [
			{"name": "curl", "version": "7.88.0"},
			{"name": "bash", "version": "5.2.0"},
		],
	}
	not "curl" in result
}

# --- tests to fix ---

# "openssl" is in data.vuln_db with severity "critical".
# This test should assert that "openssl" IS in the vulnerable_packages result.
# TODO: the assertion below is wrong — fix it.
test_critical_package_is_flagged if {
	result := inventory.vulnerable_packages with input as {
		"installed": [{"name": "openssl", "version": "3.0.0"}],
	}
	not "openssl" in result
}

# When all packages in data.required_packages are installed, all_required_present
# should be true.
# TODO: the assertion below is wrong — remove the `not`.
test_all_required_present_when_fully_installed if {
	not inventory.all_required_present with input as {
		"installed": [
			{"name": "curl", "version": "7.88.0"},
			{"name": "bash", "version": "5.2.0"},
			{"name": "jq", "version": "1.6"},
		],
	}
}

# When a high-severity package ("log4j") is installed alongside all required
# packages, the system should NOT be compliant.
# TODO: the assertion below is wrong — add `not` before inventory.compliant.
test_not_compliant_when_vulnerable_package_present if {
	inventory.compliant with input as {
		"installed": [
			{"name": "curl", "version": "7.88.0"},
			{"name": "bash", "version": "5.2.0"},
			{"name": "jq", "version": "1.6"},
			{"name": "log4j", "version": "2.14.0"},
		],
	}
}

