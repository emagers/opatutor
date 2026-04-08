package policy_language.every_some_test

import rego.v1

import data.policy_language.every_some

# --- all_tls_enabled ---

test_all_tls_enabled_true if {
	every_some.all_tls_enabled with input as {
		"servers": [
			{"id": "a", "ports": [443], "tags": ["prod"], "tls": true},
			{"id": "b", "ports": [8443], "tags": ["staging"], "tls": true},
		],
	}
}

test_all_tls_enabled_false_when_one_missing if {
	not every_some.all_tls_enabled with input as {
		"servers": [
			{"id": "a", "ports": [443], "tags": ["prod"], "tls": true},
			{"id": "b", "ports": [80], "tags": ["prod"], "tls": false},
		],
	}
}

test_all_tls_enabled_empty_list if {
	every_some.all_tls_enabled with input as {"servers": []}
}

# --- servers_with_prod_tag ---

test_servers_with_prod_tag if {
	result := every_some.servers_with_prod_tag with input as {
		"servers": [
			{"id": "web-1", "ports": [443], "tags": ["prod", "frontend"], "tls": true},
			{"id": "web-2", "ports": [80], "tags": ["staging"], "tls": false},
			{"id": "api-1", "ports": [8080], "tags": ["prod", "api"], "tls": true},
		],
	}
	result == {"web-1", "api-1"}
}

test_servers_with_prod_tag_none if {
	result := every_some.servers_with_prod_tag with input as {
		"servers": [
			{"id": "dev-1", "ports": [3000], "tags": ["dev"], "tls": false},
		],
	}
	count(result) == 0
}

# --- has_privileged_port ---

test_has_privileged_port_true if {
	every_some.has_privileged_port with input as {
		"servers": [
			{"id": "web-1", "ports": [443, 80], "tags": [], "tls": true},
		],
	}
}

test_has_privileged_port_false if {
	not every_some.has_privileged_port with input as {
		"servers": [
			{"id": "app-1", "ports": [8080, 8443], "tags": [], "tls": true},
			{"id": "app-2", "ports": [3000], "tags": [], "tls": false},
		],
	}
}

test_has_privileged_port_boundary if {
	every_some.has_privileged_port with input as {
		"servers": [{"id": "x", "ports": [1023], "tags": [], "tls": true}],
	}
}
