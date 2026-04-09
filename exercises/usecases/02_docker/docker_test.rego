package usecases.docker_test

import rego.v1

import data.usecases.docker

# Mock data (mirrors data.json — using `with` ensures tests work in all
# contexts: CLI, VSCode test runner, etc.)
mock_approved_registries := ["docker.io", "gcr.io", "ghcr.io", "registry.internal"]

# A normal container from an approved registry should be allowed.
test_approved_image_allowed if {
	docker.allow with input as {
		"RequestMethod": "POST",
		"RequestUri": "/v1.41/containers/create",
		"RequestBody": {
			"Image": "docker.io/nginx:latest",
			"HostConfig": {"Privileged": false, "Binds": []},
		},
	}
		with data.approved_registries as mock_approved_registries
}

# A container from an unknown registry should be denied.
test_unknown_registry_denied if {
	not docker.allow with input as {
		"RequestMethod": "POST",
		"RequestUri": "/v1.41/containers/create",
		"RequestBody": {
			"Image": "registry.evil.com/malware:latest",
			"HostConfig": {"Privileged": false, "Binds": []},
		},
	}
		with data.approved_registries as mock_approved_registries
}

# A privileged container must be denied even from an approved registry.
test_privileged_denied if {
	not docker.allow with input as {
		"RequestMethod": "POST",
		"RequestUri": "/v1.41/containers/create",
		"RequestBody": {
			"Image": "docker.io/nginx:latest",
			"HostConfig": {"Privileged": true, "Binds": []},
		},
	}
		with data.approved_registries as mock_approved_registries
}

# A container mounting the Docker socket must be denied.
test_socket_mount_denied if {
	not docker.allow with input as {
		"RequestMethod": "POST",
		"RequestUri": "/v1.41/containers/create",
		"RequestBody": {
			"Image": "gcr.io/myproject/app:v1",
			"HostConfig": {
				"Privileged": false,
				"Binds": ["/var/run/docker.sock:/var/run/docker.sock"],
			},
		},
	}
		with data.approved_registries as mock_approved_registries
}

# Non-create requests (e.g. listing containers) should always be allowed.
test_list_containers_allowed if {
	docker.allow with input as {
		"RequestMethod": "GET",
		"RequestUri": "/v1.41/containers/json",
		"RequestBody": {},
	}
}

# ghcr.io is an approved registry.
test_ghcr_image_allowed if {
	docker.allow with input as {
		"RequestMethod": "POST",
		"RequestUri": "/v1.41/containers/create",
		"RequestBody": {
			"Image": "ghcr.io/myorg/myapp:latest",
			"HostConfig": {"Privileged": false, "Binds": []},
		},
	}
		with data.approved_registries as mock_approved_registries
}
