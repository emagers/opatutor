# Exercise 04 - Built-in Functions: Strings
#
# Overview:
#   OPA includes a rich library of built-in functions for working with strings.
#   Commonly used string builtins:
#
#   - `concat(delimiter, array_or_set)` — joins elements into a single string.
#   - `contains(str, search)` — true if `str` contains the substring `search`.
#   - `startswith(str, prefix)` — true if `str` starts with `prefix`.
#   - `endswith(str, suffix)` — true if `str` ends with `suffix`.
#   - `upper(str)` / `lower(str)` — convert case.
#   - `trim_space(str)` — strip leading/trailing whitespace.
#   - `split(str, delimiter)` — split a string into an array.
#   - `replace(str, old, new)` — replace all occurrences of `old` with `new`.
#   - `sprintf(format, values)` — format a string with placeholders.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-reference/#strings
#
# Input structure:
#   {
#     "methods":  [string, ...],  -- HTTP method names, e.g. "GET", "get", "GetAll"
#     "name":     string,         -- a service name, e.g. "Auth"
#     "env":      string,         -- environment name, e.g. "prod"
#     "hostname": string          -- a hostname that may have leading/trailing spaces
#   }
#
# Example inputs / expected results:
#   { "methods": ["GET", "get", "POST", "GetAll", "put"] }
#       → http_methods = {"GET", "get", "GetAll"}
#   { "name": "auth", "env": "prod" }
#       → service_label = "svc-auth-prod"
#   { "name": "MyService" }
#       → normalized_name = "myservice"
#   { "hostname": "  web-01.example.com  " }
#       → clean_hostname = "web-01.example.com"
#
# Tasks:
#   1. Use `startswith` and `lower` to write `http_methods` — a partial set
#      rule that collects every method from `input.methods` whose lowercase
#      form starts with "get".
#
#   2. Use `concat` to write `service_label` — a complete rule that joins the
#      array ["svc", input.name, input.env] using a hyphen "-" as the delimiter.
#
#   3. Use `lower` to write `normalized_name` — a complete rule that returns
#      `input.name` converted to all-lowercase.
#
#   4. Use `trim_space` to write `clean_hostname` — a complete rule that
#      strips leading and trailing whitespace from `input.hostname`.

package policy_language.builtins_strings

import rego.v1

# TODO 1: write a partial set rule — collect methods from input.methods
#         whose lowercase form starts with "get"
# http_methods contains method if {
#     ...
# }

# TODO 2: write a complete rule — join ["svc", input.name, input.env] with "-"
# service_label := label if {
#     ...
# }

# TODO 3: write a complete rule — return input.name in lowercase
# normalized_name := name if {
#     ...
# }

# TODO 4: write a complete rule — strip whitespace from input.hostname
# clean_hostname := h if {
#     ...
# }

# --- stubs (tests will fail until you complete the TODOs above) ---
http_methods contains method if {
	method := input.methods[_]
	false
}

service_label := "" if { false }

normalized_name := "" if { false }

clean_hostname := "" if { false }
