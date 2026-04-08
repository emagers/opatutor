# Exercise 04 - Built-in Functions: Strings
#
# Overview:
#   OPA includes a rich library of built-in functions for working with strings.
#   Some commonly used string builtins:
#
#   - `concat(delimiter, array_or_set)` — joins elements into a single string.
#   - `contains(str, search)` — true if `str` contains the substring `search`.
#   - `startswith(str, prefix)` — true if `str` starts with `prefix`.
#   - `endswith(str, suffix)` — true if `str` ends with `suffix`.
#   - `upper(str)` / `lower(str)` — convert case.
#   - `trim_space(str)` — strip leading/trailing whitespace.
#   - `split(str, delimiter)` — split a string into an array.
#   - `sprintf(format, values)` — format a string.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-reference/#strings
#
# Task:
#   Three rules below need to be fixed:
#
#   1. `http_methods` should collect only methods that START WITH "GET" (case
#      insensitive). The rule currently compares with `endswith` — change it to
#      the correct builtin.
#
#   2. `service_label` should join the parts ["svc", input.name, input.env]
#      with a hyphen "-". The delimiter argument is wrong — fix it.
#
#   3. `normalized_name` should return the input name converted to lowercase.
#      The rule currently calls `upper` — change it to the correct builtin.

package policy_language.builtins_strings

import rego.v1

http_methods contains method if {
	method := input.methods[_]
	# TODO: fix the builtin call — we want methods that START WITH "GET"
	endswith(lower(method), "get")
}

service_label := label if {
	# TODO: fix the delimiter — parts should be joined with "-"
	label := concat(".", ["svc", input.name, input.env])
}

normalized_name := name if {
	# TODO: fix the builtin — name should be lowercased
	name := upper(input.name)
}
