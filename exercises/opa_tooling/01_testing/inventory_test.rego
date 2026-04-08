# Exercise - OPA Testing
#
# Overview:
#   OPA has a built-in test runner. Any rule whose name starts with `test_`
#   is executed as a test. Run them with:
#
#     opa test <path>          # run all tests under <path>
#     opa test <path> -v       # verbose — shows each test name and result
#     opa test <path> --coverage
#
#   A test PASSES when its body evaluates to true.
#   A test FAILS when its body evaluates to false or is undefined.
#
#   The `with` keyword overrides `input` or `data` inside a single expression,
#   making each test self-contained:
#     result := my_rule with input as { "key": "value" }
#
#   Use `not` to assert a rule is NOT true:
#     not my_rule.allow with input as { ... }
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-testing/
#
# Files in this exercise:
#   inventory.rego       ← the policy being tested (do NOT edit)
#   inventory_test.rego  ← this file — write / fix the test assertions
#   data.json            ← fixture data (do NOT edit)
#
# Policy rules in inventory.rego:
#   vulnerable_packages   — set of installed package names that have a
#                           high or critical CVE in data.vuln_db
#   all_required_present  — true when every package in data.required_packages
#                           is found in input.installed
#   compliant             — true when no vulnerable packages AND all required
#                           packages are present
#
# Tasks:
#   The reference test below is complete. Fix each of the three broken tests
#   that follow it so that each assertion correctly validates the behaviour
#   described in the comment above it.

package opa_tooling.testing_test

import rego.v1

import data.opa_tooling.inventory

# --- reference test (do NOT edit) ---

test_clean_package_not_flagged if {
	result := inventory.vulnerable_packages with input as {
		"installed": [
			{"name": "curl", "version": "7.88.0"},
			{"name": "bash", "version": "5.2.0"},
		],
	}
	not "curl" in result
}

# --- fix the tests below ---

# "openssl" appears in data.vuln_db with severity "critical".
# This test should assert that "openssl" IS in vulnerable_packages.
# TODO: the assertion is wrong — fix it so the test passes.
test_critical_package_is_flagged if {
	result := inventory.vulnerable_packages with input as {
		"installed": [{"name": "openssl", "version": "3.0.0"}],
	}
	not "openssl" in result
}

# When all packages in data.required_packages are installed,
# all_required_present should be TRUE.
# TODO: the assertion is wrong — remove the `not`.
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
# TODO: the assertion is wrong — add `not` before inventory.compliant.
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

# When only a subset of required packages is installed, all_required_present
# should be FALSE.
# TODO: this test body is empty — write the assertion.
test_not_all_required_when_missing_package if {
	false # TODO: replace with your assertion
	# Hint: use `not inventory.all_required_present with input as { ... }`
}

# A fully clean system (all required present, no vulnerable packages)
# should be compliant.
# TODO: this test body is empty — write the assertion.
test_compliant_when_clean if {
	false # TODO: replace with your assertion
	# Hint: provide installed packages that satisfy all_required_present
	#       and none are in vuln_db. Check inventory.compliant is true.
}

