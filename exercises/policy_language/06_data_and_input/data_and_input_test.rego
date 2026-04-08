package policy_language.data_and_input_test

import rego.v1

import data.policy_language.data_and_input

# Admins can perform any action in the permissions table.
test_admin_can_write if {
	data_and_input.allow with input as {"user": {"role": "admin"}, "action": "write"}
}

test_admin_can_delete if {
	data_and_input.allow with input as {"user": {"role": "admin"}, "action": "delete"}
}

# Editors can read and write, but not delete.
test_editor_can_read if {
	data_and_input.allow with input as {"user": {"role": "editor"}, "action": "read"}
}

test_editor_cannot_delete if {
	not data_and_input.allow with input as {"user": {"role": "editor"}, "action": "delete"}
}

# Viewers can only read (requires fixing data.json).
test_viewer_can_read if {
	data_and_input.allow with input as {"user": {"role": "viewer"}, "action": "read"}
}

test_viewer_cannot_write if {
	not data_and_input.allow with input as {"user": {"role": "viewer"}, "action": "write"}
}

# Roles not present in data.permissions are always denied.
test_unknown_role_denied if {
	not data_and_input.allow with input as {"user": {"role": "superuser"}, "action": "read"}
}

# When input carries no user at all, the default kicks in.
test_missing_user_denied if {
	not data_and_input.allow with input as {"action": "read"}
}
