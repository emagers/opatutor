package policy_language.rules_test

import rego.v1

import data.policy_language.rules

# --- max_retries ---

test_max_retries if {
	rules.max_retries == 3
}

# --- approved_regions ---

test_approved_regions_us_only if {
	result := rules.approved_regions with input as {
		"regions": ["us-east-1", "eu-west-1", "us-west-2", "ap-south-1"],
	}
	result == {"us-east-1", "us-west-2"}
}

test_approved_regions_empty_when_none_match if {
	result := rules.approved_regions with input as {"regions": ["eu-west-1", "ap-south-1"]}
	count(result) == 0
}

test_approved_regions_all_us if {
	result := rules.approved_regions with input as {"regions": ["us-east-1", "us-west-2", "us-central-1"]}
	count(result) == 3
}

test_approved_regions_excludes_partial_prefix if {
	result := rules.approved_regions with input as {"regions": ["useast", "us-gov-west-1"]}
	result == {"us-gov-west-1"}
}

# --- replica_counts ---

test_replica_counts_map if {
	result := rules.replica_counts with input as {
		"services": [
			{"name": "api", "replicas": 2},
			{"name": "db", "replicas": 5},
		],
	}
	result == {"api": 2, "db": 5}
}

test_replica_counts_single if {
	result := rules.replica_counts with input as {
		"services": [{"name": "web", "replicas": 3}],
	}
	result["web"] == 3
}

test_replica_counts_empty if {
	result := rules.replica_counts with input as {"services": []}
	result == {}
}
