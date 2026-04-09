package policy_language.builtins_arrays_test

import rego.v1

import data.policy_language.builtins_arrays

# --- request_count ---

test_request_count if {
	result := builtins_arrays.request_count with input as {"requests": ["a", "b", "c", "d"]}
	result == 4
}

test_request_count_empty if {
	result := builtins_arrays.request_count with input as {"requests": []}
	result == 0
}

test_request_count_one if {
	result := builtins_arrays.request_count with input as {"requests": ["x"]}
	result == 1
}

# --- sorted_scores ---

test_sorted_scores if {
	result := builtins_arrays.sorted_scores with input as {"scores": [42, 7, 99, 3, 55]}
	result == [3, 7, 42, 55, 99]
}

test_sorted_scores_already_sorted if {
	result := builtins_arrays.sorted_scores with input as {"scores": [1, 2, 3]}
	result == [1, 2, 3]
}

test_sorted_scores_reverse if {
	result := builtins_arrays.sorted_scores with input as {"scores": [5, 4, 3, 2, 1]}
	result == [1, 2, 3, 4, 5]
}

# --- top_three ---

test_top_three if {
	result := builtins_arrays.top_three with input as {"items": ["alpha", "beta", "gamma", "delta", "epsilon"]}
	result == ["alpha", "beta", "gamma"]
}

test_top_three_exact_three if {
	result := builtins_arrays.top_three with input as {"items": ["a", "b", "c"]}
	result == ["a", "b", "c"]
}

# --- max_duration ---

test_max_duration if {
	result := builtins_arrays.max_duration with input as {"durations": [120, 45, 300, 80]}
	result == 300
}

test_max_duration_single if {
	result := builtins_arrays.max_duration with input as {"durations": [42]}
	result == 42
}
