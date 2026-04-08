package usecases.data_filtering_test

import rego.v1

import data.usecases.data_filtering

# alice owns doc-1 (private) and doc-2 (public); doc-4 is also public.
test_alice_readable_docs if {
	result := data_filtering.readable_docs with input as {"user": "alice"}
	result == {"doc-1", "doc-2", "doc-4"}
}

# bob owns doc-3 (private) and doc-4 (public); doc-2 is also public.
test_bob_readable_docs if {
	result := data_filtering.readable_docs with input as {"user": "bob"}
	result == {"doc-2", "doc-3", "doc-4"}
}

# carol owns doc-5 (private); doc-2 and doc-4 are public.
test_carol_readable_docs if {
	result := data_filtering.readable_docs with input as {"user": "carol"}
	result == {"doc-2", "doc-4", "doc-5"}
}

# A user who owns nothing still sees the two public documents.
test_unknown_user_sees_only_public if {
	result := data_filtering.readable_docs with input as {"user": "nobody"}
	result == {"doc-2", "doc-4"}
}

# summary should reflect the readable count for the requesting user.
test_summary_for_alice if {
	result := data_filtering.summary with input as {"user": "alice"}
	result == 3
}

test_summary_for_unknown_user if {
	result := data_filtering.summary with input as {"user": "nobody"}
	result == 2
}
