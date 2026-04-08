package policy_language.builtins_arrays_test

import rego.v1

import data.policy_language.builtins_arrays

test_request_count if {
	result := builtins_arrays.request_count with input as {"requests": ["a", "b", "c", "d"]}
	result == 4
}

test_request_count_empty if {
	result := builtins_arrays.request_count with input as {"requests": []}
	result == 0
}

test_sorted_scores if {
	result := builtins_arrays.sorted_scores with input as {"scores": [42, 7, 99, 3, 55]}
	result == [3, 7, 42, 55, 99]
}

test_top_three if {
	result := builtins_arrays.top_three with input as {"items": ["alpha", "beta", "gamma", "delta", "epsilon"]}
	result == ["alpha", "beta", "gamma"]
}
