package policy_language.keywords_test

import rego.v1

import data.policy_language.keywords

# --- allow ---

test_admin_is_allowed if {
	keywords.allow with input as {"user": {"role": "admin", "mfa_enabled": true}}
}

test_editor_is_denied if {
	not keywords.allow with input as {"user": {"role": "editor", "mfa_enabled": true}}
}

test_viewer_is_denied if {
	not keywords.allow with input as {"user": {"role": "viewer", "mfa_enabled": false}}
}

test_empty_input_uses_default if {
	not keywords.allow with input as {}
}

test_unknown_role_is_denied if {
	not keywords.allow with input as {"user": {"role": "superadmin", "mfa_enabled": true}}
}

# --- mfa_required ---

test_mfa_required_when_disabled if {
	keywords.mfa_required with input as {"user": {"role": "viewer", "mfa_enabled": false}}
}

test_mfa_not_required_when_enabled if {
	not keywords.mfa_required with input as {"user": {"role": "admin", "mfa_enabled": true}}
}

test_mfa_required_for_admin_without_mfa if {
	keywords.mfa_required with input as {"user": {"role": "admin", "mfa_enabled": false}}
}
