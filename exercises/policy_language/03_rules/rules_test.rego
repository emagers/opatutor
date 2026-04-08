package policy_language.rules_test

import rego.v1

import data.policy_language.rules

test_max_retries if {
	rules.max_retries == 3
}

test_approved_regions_set if {
	result := rules.approved_regions with input as {
		"regions": ["us-east-1", "eu-west-1", "us-west-2", "ap-south-1"],
	}
	result == {"us-east-1", "us-west-2"}
}

test_approved_regions_empty if {
	result := rules.approved_regions with input as {"regions": ["eu-west-1", "ap-south-1"]}
	count(result) == 0
}
