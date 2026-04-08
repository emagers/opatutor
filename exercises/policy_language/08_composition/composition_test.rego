package policy_language.composition_test

import rego.v1

import data.policy_language.composition.gateway

# Admins can write to a normal resource.
test_admin_write_allowed if {
	gateway.allow with input as {
		"user": {"role": "admin"},
		"action": "write",
		"resource": {"name": "project-bucket"},
	}
}

# Viewers cannot write — insufficient permission.
test_viewer_write_denied if {
	not gateway.allow with input as {
		"user": {"role": "viewer"},
		"action": "write",
		"resource": {"name": "project-bucket"},
	}
}

# Editors can read.
test_editor_read_allowed if {
	gateway.allow with input as {
		"user": {"role": "editor"},
		"action": "read",
		"resource": {"name": "project-bucket"},
	}
}

# Even an admin cannot access a blocked resource.
test_admin_blocked_resource_denied if {
	not gateway.allow with input as {
		"user": {"role": "admin"},
		"action": "read",
		"resource": {"name": "quarantine-bucket"},
	}
}

# A viewer reading a normal resource is allowed.
test_viewer_read_allowed if {
	gateway.allow with input as {
		"user": {"role": "viewer"},
		"action": "read",
		"resource": {"name": "project-bucket"},
	}
}

# Editors cannot delete.
test_editor_delete_denied if {
	not gateway.allow with input as {
		"user": {"role": "editor"},
		"action": "delete",
		"resource": {"name": "project-bucket"},
	}
}
