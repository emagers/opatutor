# Exercise 11 - OPA Bundles
#
# Overview:
#   An OPA *bundle* is a gzipped tar archive (.tar.gz) that packages one or
#   more policy modules and data files together. Bundles are the standard way
#   to distribute policies to OPA instances running as a sidecar or server.
#
#   Build a bundle:
#     opa build -b <directory>            # produces bundle.tar.gz
#     opa build -b <dir> -o my.tar.gz     # custom output name
#     opa build -b <dir> --target wasm    # compile to WASM
#
#   Inspect a bundle:
#     opa inspect bundle.tar.gz
#
#   Run OPA with a bundle:
#     opa run bundle.tar.gz               # REPL with bundle loaded
#     opa run --server bundle.tar.gz      # start OPA server
#
#   Bundles can be served over HTTP so OPA instances pull them automatically:
#     services:
#       bundleserver:
#         url: https://bundles.example.com
#     bundles:
#       myapp:
#         resource: /bundles/myapp.tar.gz
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/management-bundles/
#
# Files in this exercise:
#   network.rego        ← network access policy (fix this file)
#   data.json           ← allowed CIDRs and ports (do NOT edit)
#   network_test.rego   ← tests (do NOT edit)
#
# Task:
#   This exercise also introduces the `opa build` and `opa inspect` commands.
#   After fixing the policy so the tests pass, try running:
#
#     opa build -b exercises/opa_tooling/02_bundling
#     opa inspect bundle.tar.gz
#
#   Two rules in network.rego need fixing:
#
#   1. `allowed_connection` uses `net.cidr_contains` to check if the
#      destination IP is within an allowed CIDR. The argument order is wrong —
#      `net.cidr_contains(cidr, ip)` takes the CIDR first and the IP second.
#      Fix the argument order.
#
#   2. `allowed_port` checks whether the destination port is in
#      `data.allowed_ports`. The comparison uses `==` against the whole array
#      instead of checking membership. Use `in` to test membership.

package opa_tooling.network

import rego.v1

default allow := false

allow if {
	allowed_connection
	allowed_port
}

allowed_connection if {
	cidr := data.allowed_cidrs[_]
	# TODO: fix argument order — net.cidr_contains(cidr, ip)
	net.cidr_contains(input.destination.ip, cidr)
}

allowed_port if {
	# TODO: fix the check — use `in` to test port membership
	input.destination.port == data.allowed_ports
}
