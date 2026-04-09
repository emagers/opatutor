package policy_language.functions_test

import rego.v1

import data.policy_language.functions

# --- classify ---

test_classify_high if {
	functions.classify(92) == "high"
}

test_classify_high_boundary if {
	functions.classify(80) == "high"
}

test_classify_medium if {
	functions.classify(65) == "medium"
}

test_classify_medium_boundary if {
	functions.classify(50) == "medium"
}

test_classify_low if {
	functions.classify(30) == "low"
}

test_classify_low_boundary if {
	functions.classify(0) == "low"
}

# --- score_labels ---

test_score_labels if {
	result := functions.score_labels with input as {"scores": [92, 55, 30, 80]}
	result == ["high", "medium", "low", "high"]
}

test_score_labels_empty if {
	result := functions.score_labels with input as {"scores": []}
	result == []
}

test_score_labels_all_low if {
	result := functions.score_labels with input as {"scores": [10, 20, 49]}
	result == ["low", "low", "low"]
}

# --- is_safe_request ---

test_is_safe_get if {
	functions.is_safe_request({"method": "GET", "path": "/health"})
}

test_is_safe_delete_not_safe if {
	not functions.is_safe_request({"method": "DELETE", "path": "/api/users"})
}

test_is_safe_post_not_safe if {
	not functions.is_safe_request({"method": "POST", "path": "/api/items"})
}

# --- safe_paths ---

test_safe_paths if {
	result := functions.safe_paths with input as {
		"requests": [
			{"method": "GET", "path": "/api/users"},
			{"method": "DELETE", "path": "/api/users"},
			{"method": "GET", "path": "/health"},
		],
	}
	result == {"/api/users", "/health"}
}

test_safe_paths_none if {
	result := functions.safe_paths with input as {
		"requests": [
			{"method": "POST", "path": "/a"},
			{"method": "PUT", "path": "/b"},
		],
	}
	count(result) == 0
}
