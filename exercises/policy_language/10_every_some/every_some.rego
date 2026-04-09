# Exercise 10 - The `every` and `some` Keywords
#
# Overview:
#   `some` — introduces a variable for existential quantification. It
#   signals to OPA that you want to find *at least one* value satisfying the
#   conditions. Two forms:
#     some x in collection     — bind x to elements of a collection
#     some i, v in collection  — bind both index i and value v
#   Using `some` without `in` declares a local variable to avoid conflicts
#   with rule-level names.
#
#   `every` — universal quantification. Evaluates to true only when the body
#   is true for *every* element in a collection:
#     every x in collection { condition }
#   If any element fails the condition, `every` is false.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/policy-language/#every-keyword
#   https://www.openpolicyagent.org/docs/latest/policy-language/#some-keyword
#
# Input structure:
#   {
#     "servers": [
#       {
#         "id":       string,
#         "ports":    [number, ...],
#         "tags":     [string, ...],
#         "tls":      boolean
#       }
#     ]
#   }
#
# Example inputs / expected results:
#   {
#     "servers": [
#       {"id": "web-1", "ports": [443], "tags": ["prod"], "tls": true},
#       {"id": "web-2", "ports": [80],  "tags": ["prod"], "tls": false}
#     ]
#   }
#   → all_tls_enabled    = false  (web-2 has tls: false)
#   → servers_with_prod_tag = {"web-1", "web-2"}
#   → has_privileged_port   = true  (web-2 exposes port 80 < 1024)
#
# Tasks:
#   1. Use `every` to write `all_tls_enabled` — true when every server in
#      `input.servers` has `tls` set to true.
#
#   2. Use `some ... in` to write `servers_with_prod_tag` — a partial set rule
#      that collects the `id` of each server that has the tag "prod" somewhere
#      in its `tags` array.
#      Hint: use `some tag in server.tags` then `tag == "prod"`.
#
#   3. Use `some` with an index to write `has_privileged_port` — true when at
#      least one server exposes a port below 1024.
#      Hint: iterate with `some i, server in input.servers`, then iterate the
#      ports of that server.

package policy_language.every_some

import rego.v1

# TODO 1: use `every` — true when all servers have tls == true
# all_tls_enabled if {
#     every server in input.servers {
#         ...
#     }
# }

# TODO 2: use `some x in collection` — collect IDs of servers that have "prod" in tags
# servers_with_prod_tag contains server.id if {
#     some server in input.servers
#     some tag in server.tags
#     ...
# }

# TODO 3: use `some i, v in collection` — true when any server has a port < 1024
# has_privileged_port if {
#     some _, server in input.servers
#     some port in server.ports
#     ...
# }

# --- stubs (tests will fail until you complete the TODOs above) ---
all_tls_enabled if { false }

servers_with_prod_tag contains id if {
	id := input.servers[_].id
	false
}

has_privileged_port if { false }
