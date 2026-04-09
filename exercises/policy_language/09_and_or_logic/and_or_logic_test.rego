package policy_language.and_or_logic_test

import rego.v1

import data.policy_language.and_or_logic

# --- Rule A: admin ---

test_admin_verified_allowed if {
	and_or_logic.allow with input as {
		"user": {"role": "admin", "verified": true},
		"action": "delete",
		"resource": {"classification": "confidential", "region": "us-east-1"},
	}
}

test_admin_unverified_denied if {
	not and_or_logic.allow with input as {
		"user": {"role": "admin", "verified": false},
		"action": "delete",
		"resource": {"classification": "confidential", "region": "us-east-1"},
	}
}

# --- Rule B: editor ---

test_editor_write_internal_allowed if {
	and_or_logic.allow with input as {
		"user": {"role": "editor", "verified": true},
		"action": "write",
		"resource": {"classification": "internal", "region": "us-east-1"},
	}
}

test_editor_read_internal_allowed if {
	and_or_logic.allow with input as {
		"user": {"role": "editor", "verified": true},
		"action": "read",
		"resource": {"classification": "internal", "region": "us-east-1"},
	}
}

test_editor_write_confidential_denied if {
	not and_or_logic.allow with input as {
		"user": {"role": "editor", "verified": true},
		"action": "write",
		"resource": {"classification": "confidential", "region": "us-east-1"},
	}
}

test_editor_delete_denied if {
	not and_or_logic.allow with input as {
		"user": {"role": "editor", "verified": true},
		"action": "delete",
		"resource": {"classification": "internal", "region": "us-east-1"},
	}
}

# --- Rule C: auditor ---

test_auditor_audit_allowed if {
	and_or_logic.allow with input as {
		"user": {"role": "auditor", "verified": true},
		"action": "audit",
		"resource": {"classification": "confidential", "region": "us-east-1"},
	}
}

test_auditor_write_denied if {
	not and_or_logic.allow with input as {
		"user": {"role": "auditor", "verified": true},
		"action": "write",
		"resource": {"classification": "internal", "region": "us-east-1"},
	}
}

# --- Rule D: public read ---

test_verified_user_read_public_allowed if {
	and_or_logic.allow with input as {
		"user": {"role": "viewer", "verified": true},
		"action": "read",
		"resource": {"classification": "public", "region": "us-east-1"},
	}
}

test_unverified_user_read_public_denied if {
	not and_or_logic.allow with input as {
		"user": {"role": "viewer", "verified": false},
		"action": "read",
		"resource": {"classification": "public", "region": "us-east-1"},
	}
}

test_verified_user_write_public_denied if {
	not and_or_logic.allow with input as {
		"user": {"role": "viewer", "verified": true},
		"action": "write",
		"resource": {"classification": "public", "region": "us-east-1"},
	}
}

# --- default ---

test_unknown_role_denied if {
	not and_or_logic.allow with input as {
		"user": {"role": "guest", "verified": true},
		"action": "read",
		"resource": {"classification": "public", "region": "us-east-1"},
	}
}
