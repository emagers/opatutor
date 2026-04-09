package policy_language.comprehensions_test

import rego.v1

import data.policy_language.comprehensions

# --- active_scores ---

test_active_scores if {
	result := comprehensions.active_scores with input as {
		"users": [
			{"id": "u1", "name": "Alice", "score": 82, "active": true},
			{"id": "u2", "name": "Bob", "score": 45, "active": false},
			{"id": "u3", "name": "Carol", "score": 91, "active": true},
		],
	}
	# set comparison: both scores present, Bob excluded
	count(result) == 2
	82 in result
	91 in result
}

test_active_scores_none_active if {
	result := comprehensions.active_scores with input as {
		"users": [
			{"id": "u1", "name": "Alice", "score": 82, "active": false},
		],
	}
	count(result) == 0
}

# --- active_names ---

test_active_names if {
	result := comprehensions.active_names with input as {
		"users": [
			{"id": "u1", "name": "Alice", "score": 82, "active": true},
			{"id": "u2", "name": "Bob", "score": 45, "active": false},
			{"id": "u3", "name": "Carol", "score": 91, "active": true},
		],
	}
	result == {"Alice", "Carol"}
}

test_active_names_empty if {
	result := comprehensions.active_names with input as {
		"users": [{"id": "u1", "name": "Dave", "score": 10, "active": false}],
	}
	count(result) == 0
}

# --- score_by_id ---

test_score_by_id if {
	result := comprehensions.score_by_id with input as {
		"users": [
			{"id": "u1", "name": "Alice", "score": 82, "active": true},
			{"id": "u2", "name": "Bob", "score": 45, "active": false},
			{"id": "u3", "name": "Carol", "score": 91, "active": true},
		],
	}
	result == {"u1": 82, "u3": 91}
}

test_score_by_id_empty if {
	result := comprehensions.score_by_id with input as {
		"users": [{"id": "u1", "name": "Alice", "score": 50, "active": false}],
	}
	result == {}
}
