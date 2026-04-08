# Exercise - OPA Bundles
#
# Overview:
#   An OPA *bundle* is a gzipped tar archive (.tar.gz) that packages one or
#   more policy modules and data files together. Bundles are the standard way
#   to distribute policies to OPA instances running as a sidecar or server.
#
#   Build a bundle:
#     opa build -b <directory>            # produces bundle.tar.gz
#     opa build -b <dir> -o my.tar.gz     # custom output name
#
#   Inspect a bundle:
#     opa inspect bundle.tar.gz
#
#   After fixing this policy, try:
#     opa build -b exercises/opa_tooling/02_bundling
#     opa inspect bundle.tar.gz
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/management-bundles/
#
# Files in this exercise:
#   network.rego        ← this file (write the policy)
#   data.json           ← allowed CIDRs and ports (do NOT edit)
#   network_test.rego   ← tests (do NOT edit)
#
# data.json structure:
#   {
#     "allowed_cidrs": ["10.0.0.0/8", "192.168.0.0/16"],
#     "allowed_ports": [80, 443, 8080]
#   }
#
# Input structure:
#   {
#     "destination": {
#       "ip":   string,  -- e.g. "10.1.2.3"
#       "port": number   -- e.g. 443
#     }
#   }
#
# Example inputs / expected results:
#   { "destination": { "ip": "10.1.2.3",    "port": 443  } } → allow = true
#   { "destination": { "ip": "8.8.8.8",     "port": 443  } } → allow = false (CIDR)
#   { "destination": { "ip": "10.1.2.3",    "port": 22   } } → allow = false (port)
#
# Tasks:
#   1. Write `allowed_connection` — true when the destination IP falls within
#      any of the CIDRs listed in `data.allowed_cidrs`.
#      Use `net.cidr_contains(cidr, ip)` — note the argument order: CIDR first.
#
#   2. Write `allowed_port` — true when `input.destination.port` is a member
#      of `data.allowed_ports`.
#      Use the `in` keyword for membership testing.
#
#   3. The `allow` rule is provided — do NOT change it.

package opa_tooling.network

import rego.v1

default allow := false

allow if {
	allowed_connection
	allowed_port
}

# TODO 1: write allowed_connection — true when the destination IP is within
#         any CIDR in data.allowed_cidrs (use net.cidr_contains(cidr, ip))
# allowed_connection if {
#     ...
# }

# TODO 2: write allowed_port — true when input.destination.port is in
#         data.allowed_ports (use the `in` keyword)
# allowed_port if {
#     ...
# }

# --- stubs (tests will fail until you complete the TODOs above) ---
allowed_connection if { false }

allowed_port if { false }
