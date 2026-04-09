package policy_language.data_and_input_test

import rego.v1

import data.policy_language.data_and_input

# Mock data (mirrors data.json — using `with` ensures tests work in all
# contexts: CLI, VSCode test runner, etc.)
mock_permissions := {
	"admin": ["read", "write", "delete"],
	"editor": ["read", "write"],
	"viewer": ["read"],
}

# Admins can perform any action in the permissions table.
test_admin_can_write if {
	data_and_input.allow with input as {"user": {"role": "admin"}, "action": "write"}
		with data.permissions as mock_permissions
}

test_admin_can_delete if {
	data_and_input.allow with input as {"user": {"role": "admin"}, "action": "delete"}
		with data.permissions as mock_permissions
}

test_admin_can_read if {
	data_and_input.allow with input as {"user": {"role": "admin"}, "action": "read"}
		with data.permissions as mock_permissions
}

# Editors can read and write, but not delete.
test_editor_can_read if {
	data_and_input.allow with input as {"user": {"role": "editor"}, "action": "read"}
		with data.permissions as mock_permissions
}

test_editor_can_write if {
	data_and_input.allow with input as {"user": {"role": "editor"}, "action": "write"}
		with data.permissions as mock_permissions
}

test_editor_cannot_delete if {
	not data_and_input.allow with input as {"user": {"role": "editor"}, "action": "delete"}
		with data.permissions as mock_permissions
}

# Viewers can only read.
test_viewer_can_read if {
	data_and_input.allow with input as {"user": {"role": "viewer"}, "action": "read"}
		with data.permissions as mock_permissions
}

test_viewer_cannot_write if {
	not data_and_input.allow with input as {"user": {"role": "viewer"}, "action": "write"}
		with data.permissions as mock_permissions
}

test_viewer_cannot_delete if {
	not data_and_input.allow with input as {"user": {"role": "viewer"}, "action": "delete"}
		with data.permissions as mock_permissions
}

# Roles not present in data.permissions are always denied.
test_unknown_role_denied if {
	not data_and_input.allow with input as {"user": {"role": "superuser"}, "action": "read"}
		with data.permissions as mock_permissions
}

# When input carries no user at all, the default kicks in.
test_missing_user_denied if {
	not data_and_input.allow with input as {"action": "read"}
		with data.permissions as mock_permissions
}

test_empty_input_denied if {
	not data_and_input.allow with input as {}
		with data.permissions as mock_permissions
}
