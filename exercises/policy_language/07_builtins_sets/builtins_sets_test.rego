package policy_language.builtins_sets_test

import rego.v1

import data.policy_language.builtins_sets

# --- missing_scopes ---

test_missing_scopes_some_missing if {
	result := builtins_sets.missing_scopes with input as {"scopes": {"read"}}
	result == {"write", "admin"}
}

test_missing_scopes_none_missing if {
	result := builtins_sets.missing_scopes with input as {"scopes": {"read", "write", "admin"}}
	count(result) == 0
}

test_missing_scopes_all_missing if {
	result := builtins_sets.missing_scopes with input as {"scopes": set()}
	result == {"read", "write", "admin"}
}

# --- common_tags ---

test_common_tags if {
	result := builtins_sets.common_tags with input as {
		"tags_a": {"web", "prod", "api"},
		"tags_b": {"prod", "api", "db"},
	}
	result == {"prod", "api"}
}

test_common_tags_no_overlap if {
	result := builtins_sets.common_tags with input as {
		"tags_a": {"web"},
		"tags_b": {"db"},
	}
	count(result) == 0
}

test_common_tags_identical if {
	result := builtins_sets.common_tags with input as {
		"tags_a": {"a", "b"},
		"tags_b": {"a", "b"},
	}
	result == {"a", "b"}
}

# --- privileged_and_active ---

test_privileged_and_active if {
	result := builtins_sets.privileged_and_active with input as {
		"users": [
			{"name": "alice", "role": "admin", "active": true},
			{"name": "bob", "role": "admin", "active": false},
			{"name": "carol", "role": "viewer", "active": true},
		],
	}
	result == {"alice"}
}

test_privileged_and_active_none if {
	result := builtins_sets.privileged_and_active with input as {
		"users": [
			{"name": "dave", "role": "editor", "active": true},
			{"name": "eve", "role": "admin", "active": false},
		],
	}
	count(result) == 0
}

test_privileged_and_active_multiple if {
	result := builtins_sets.privileged_and_active with input as {
		"users": [
			{"name": "alice", "role": "admin", "active": true},
			{"name": "frank", "role": "admin", "active": true},
		],
	}
	result == {"alice", "frank"}
}
