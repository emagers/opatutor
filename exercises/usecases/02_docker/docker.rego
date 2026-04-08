# Exercise 09 - Docker Authorization
#
# Overview:
#   Docker supports authorization plugins that intercept every API request
#   before it is executed. OPA can act as this plugin: Docker sends a JSON
#   payload describing the request, and OPA's policy decides whether to allow
#   or deny it.
#
#   A typical Docker authz payload looks like:
#     {
#       "AuthMethod": "",
#       "User": "alice",
#       "UserAuthNMethod": "TLS",
#       "RequestMethod": "POST",
#       "RequestUri": "/v1.41/containers/create",
#       "RequestBody": { "Image": "nginx:latest", "HostConfig": { "Privileged": false } }
#     }
#
#   Good practices enforced by policy:
#   - Deny privileged containers (they can escape the host).
#   - Deny containers that mount the Docker socket (full host access).
#   - Restrict which image registries may be used.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/docker-authorization/
#
# Files in this exercise:
#   docker.rego       ← this file (fix the policy)
#   data.json         ← approved registries list (do NOT edit)
#   docker_test.rego  ← tests (do NOT edit)
#
# Task:
#   Three rules need fixing:
#
#   1. `deny_privileged` should deny requests that create a container with
#      `HostConfig.Privileged` set to true. The field path is wrong —
#      it currently reads `input.RequestBody.Privileged` instead of
#      `input.RequestBody.HostConfig.Privileged`. Fix the path.
#
#   2. `deny_socket_mount` should deny containers that bind-mount the Docker
#      socket (/var/run/docker.sock). The comprehension iterates over
#      `input.RequestBody.Binds` but uses the wrong separator when checking
#      the source path — Docker bind-mounts use ":" as the separator, so
#      `parts[0]` is the host path. The check currently uses `parts[1]`.
#      Fix the index.
#
#   3. `allow` should permit the request only when no deny rule fires AND
#      the image is from an approved registry. The registry check is inverted —
#      it currently denies approved registries. Fix the condition so it ALLOWS
#      requests from approved registries.

package usecases.docker

import rego.v1

default allow := false

# Deny privileged containers.
deny_privileged if {
	input.RequestMethod == "POST"
	contains(input.RequestUri, "/containers/create")
	# TODO: fix the path — should be input.RequestBody.HostConfig.Privileged
	input.RequestBody.Privileged == true
}

# Deny containers that mount the Docker socket.
deny_socket_mount if {
	input.RequestMethod == "POST"
	contains(input.RequestUri, "/containers/create")
	bind := input.RequestBody.HostConfig.Binds[_]
	parts := split(bind, ":")
	# TODO: fix the index — host path is parts[0], not parts[1]
	parts[1] == "/var/run/docker.sock"
}

# Allow only when no deny rule fires and the image registry is approved.
allow if {
	not deny_privileged
	not deny_socket_mount
	image := input.RequestBody.Image
	registry := split(image, "/")[0]
	# TODO: fix this condition — it should ALLOW approved registries, not deny them
	not registry in data.approved_registries
}

# Non-create requests (inspect, list, logs, etc.) are always allowed.
allow if {
	not contains(input.RequestUri, "/containers/create")
}
