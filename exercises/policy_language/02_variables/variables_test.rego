package policy_language.variables_test

import rego.v1

import data.policy_language.variables

# --- risky_ports ---

test_risky_ports_mixed if {
	result := variables.risky_ports with input as {"ports": [80, 443, 8080, 22, 3306]}
	result == {80, 443, 22}
}

test_risky_ports_none if {
	result := variables.risky_ports with input as {"ports": [8080, 8443, 3000]}
	count(result) == 0
}

test_risky_ports_all if {
	result := variables.risky_ports with input as {"ports": [21, 22, 80]}
	count(result) == 3
}

test_risky_ports_boundary if {
	result := variables.risky_ports with input as {"ports": [1023, 1024, 1025]}
	result == {1023}
}

# --- destructive_users ---

test_destructive_users if {
	result := variables.destructive_users with input as {
		"requests": [
			{"method": "DELETE", "path": "/api/users", "user": "alice"},
			{"method": "GET", "path": "/health", "user": "bob"},
			{"method": "DELETE", "path": "/api/data", "user": "carol"},
		],
	}
	result == {"alice", "carol"}
}

test_no_destructive_users if {
	result := variables.destructive_users with input as {
		"requests": [
			{"method": "GET", "path": "/health", "user": "bob"},
			{"method": "POST", "path": "/api/items", "user": "dave"},
		],
	}
	count(result) == 0
}

test_same_user_multiple_deletes if {
	result := variables.destructive_users with input as {
		"requests": [
			{"method": "DELETE", "path": "/a", "user": "alice"},
			{"method": "DELETE", "path": "/b", "user": "alice"},
		],
	}
	result == {"alice"}
}
