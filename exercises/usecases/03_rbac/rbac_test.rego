package usecases.rbac_test

import rego.v1

import data.usecases.rbac

# --- user_permissions ---

test_alice_permissions if {
	result := rbac.user_permissions with input as {"user": "alice", "action": "read"}
	result == {"read", "write", "delete", "manage_users"}
}

test_bob_permissions_merged if {
	result := rbac.user_permissions with input as {"user": "bob", "action": "read"}
	result == {"read", "write", "audit"}
}

test_carol_permissions if {
	result := rbac.user_permissions with input as {"user": "carol", "action": "read"}
	result == {"read"}
}

# --- allow ---

test_alice_manage_users if {
	rbac.allow with input as {"user": "alice", "action": "manage_users"}
}

test_alice_delete if {
	rbac.allow with input as {"user": "alice", "action": "delete"}
}

test_bob_write_via_developer if {
	rbac.allow with input as {"user": "bob", "action": "write"}
}

test_bob_audit_via_auditor if {
	rbac.allow with input as {"user": "bob", "action": "audit"}
}

test_bob_cannot_delete if {
	not rbac.allow with input as {"user": "bob", "action": "delete"}
}

test_bob_cannot_manage_users if {
	not rbac.allow with input as {"user": "bob", "action": "manage_users"}
}

test_carol_read if {
	rbac.allow with input as {"user": "carol", "action": "read"}
}

test_carol_cannot_write if {
	not rbac.allow with input as {"user": "carol", "action": "write"}
}

test_unknown_user_denied if {
	not rbac.allow with input as {"user": "unknown", "action": "read"}
}

test_empty_input_denied if {
	not rbac.allow with input as {}
}
