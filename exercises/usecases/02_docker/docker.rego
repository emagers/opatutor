# Exercise - Docker Authorization
#
# Overview:
#   Docker supports authorization plugins that intercept every API request.
#   OPA can act as this plugin: Docker sends a JSON payload and OPA's policy
#   decides allow or deny.
#
#   Key patterns in this exercise:
#   - AND logic: multiple expressions in one rule body all must be true.
#   - Deny-overrides: define explicit `deny_*` helper rules, then `allow` fires
#     only when none of them are true.
#   - `not` keyword: used to negate another rule.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/docker-authorization/
#
# Files in this exercise:
#   docker.rego       ← this file (write the policy)
#   data.json         ← approved registries list (do NOT edit)
#   docker_test.rego  ← tests (do NOT edit)
#
# data.json structure:
#   { "approved_registries": ["docker.io", "gcr.io", "ghcr.io"] }
#
# Input structure (Docker authz payload):
#   {
#     "RequestMethod": string,        -- HTTP verb, e.g. "POST", "GET"
#     "RequestUri":    string,        -- e.g. "/v1.41/containers/create"
#     "RequestBody": {
#       "Image": string,              -- e.g. "docker.io/nginx:latest"
#       "HostConfig": {
#         "Privileged": boolean,
#         "Binds": [string, ...]      -- bind-mount specs, e.g. ["/host/path:/ctr/path"]
#       }
#     }
#   }
#
# Example inputs / expected results:
#   POST /containers/create, Image=docker.io/nginx, Privileged=false, Binds=[]
#       → allow = true
#   POST /containers/create, Image=docker.io/nginx, Privileged=true
#       → allow = false  (privileged denied)
#   POST /containers/create, Binds=["/var/run/docker.sock:/var/run/docker.sock"]
#       → allow = false  (socket mount denied)
#   POST /containers/create, Image=evil.registry/img
#       → allow = false  (unapproved registry)
#   GET /containers/json
#       → allow = true   (non-create requests always allowed)
#
# Tasks:
#   1. Write `deny_privileged` — true when the request creates a container
#      (POST to a URI containing "/containers/create") with
#      `input.RequestBody.HostConfig.Privileged` set to true.
#
#   2. Write `deny_socket_mount` — true when the request creates a container
#      and one of the bind mounts in `input.RequestBody.HostConfig.Binds`
#      has the Docker socket ("/var/run/docker.sock") as the HOST path.
#      Hint: split each bind string on ":" — parts[0] is the host path.
#
#   3. Write `allow` for container-create requests: true when NEITHER
#      `deny_privileged` NOR `deny_socket_mount` fires, AND the image's
#      registry prefix is in `data.approved_registries`.
#      Hint: split the image string on "/" — parts[0] is the registry.
#
#   4. Write a second `allow` rule that permits ALL non-create requests
#      (i.e. when the RequestUri does NOT contain "/containers/create").

package usecases.docker

import rego.v1

default allow := false

# TODO 1: write deny_privileged
# deny_privileged if {
#     ...
# }

# TODO 2: write deny_socket_mount
# deny_socket_mount if {
#     ...
# }

# TODO 3: write allow for container-create requests
# allow if {
#     ...
# }

# TODO 4: write allow for non-create requests
# allow if {
#     ...
# }

# --- stubs (tests will fail until you complete the TODOs above) ---
deny_privileged if { false }

deny_socket_mount if { false }
