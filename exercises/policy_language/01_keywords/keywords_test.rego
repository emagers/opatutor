package policy_language.keywords_test

import rego.v1

import data.policy_language.keywords

test_admin_is_allowed if {
	keywords.allow with input as {"role": "admin"}
}

test_user_is_denied if {
	not keywords.allow with input as {"role": "user"}
}

test_guest_is_denied if {
	not keywords.allow with input as {"role": "guest"}
}

test_default_is_false if {
	not keywords.allow with input as {}
}
