package usecases.rbac_test

import rego.v1

import data.usecases.rbac

# Mock data (mirrors data.json — using `with` ensures tests work in all
# contexts: CLI, VSCode test runner, etc.)
mock_roles := {
	"admin": {"permissions": ["read", "write", "delete", "manage_users"]},
	"developer": {"permissions": ["read", "write"]},
	"auditor": {"permissions": ["read", "audit"]},
	"viewer": {"permissions": ["read"]},
}

mock_user_roles := {
	"alice": ["admin"],
	"bob": ["developer", "auditor"],
	"carol": ["viewer"],
}

# --- user_permissions ---

test_alice_permissions if {
	result := rbac.user_permissions with input as {"user": "alice", "action": "read"}
		with data.roles as mock_roles
		with data.user_roles as mock_user_roles
	result == {"read", "write", "delete", "manage_users"}
}

test_bob_permissions_merged if {
	result := rbac.user_permissions with input as {"user": "bob", "action": "read"}
		with data.roles as mock_roles
		with data.user_roles as mock_user_roles
	result == {"read", "write", "audit"}
}

test_carol_permissions if {
	result := rbac.user_permissions with input as {"user": "carol", "action": "read"}
		with data.roles as mock_roles
		with data.user_roles as mock_user_roles
	result == {"read"}
}

# --- allow ---

test_alice_manage_users if {
	rbac.allow with input as {"user": "alice", "action": "manage_users"}
		with data.roles as mock_roles
		with data.user_roles as mock_user_roles
}

test_alice_delete if {
	rbac.allow with input as {"user": "alice", "action": "delete"}
		with data.roles as mock_roles
		with data.user_roles as mock_user_roles
}

test_bob_write_via_developer if {
	rbac.allow with input as {"user": "bob", "action": "write"}
		with data.roles as mock_roles
		with data.user_roles as mock_user_roles
}

test_bob_audit_via_auditor if {
	rbac.allow with input as {"user": "bob", "action": "audit"}
		with data.roles as mock_roles
		with data.user_roles as mock_user_roles
}

test_bob_cannot_delete if {
	not rbac.allow with input as {"user": "bob", "action": "delete"}
		with data.roles as mock_roles
		with data.user_roles as mock_user_roles
}

test_bob_cannot_manage_users if {
	not rbac.allow with input as {"user": "bob", "action": "manage_users"}
		with data.roles as mock_roles
		with data.user_roles as mock_user_roles
}

test_carol_read if {
	rbac.allow with input as {"user": "carol", "action": "read"}
		with data.roles as mock_roles
		with data.user_roles as mock_user_roles
}

test_carol_cannot_write if {
	not rbac.allow with input as {"user": "carol", "action": "write"}
		with data.roles as mock_roles
		with data.user_roles as mock_user_roles
}

test_unknown_user_denied if {
	not rbac.allow with input as {"user": "unknown", "action": "read"}
		with data.roles as mock_roles
		with data.user_roles as mock_user_roles
}

test_empty_input_denied if {
	not rbac.allow with input as {}
		with data.roles as mock_roles
		with data.user_roles as mock_user_roles
}
