package policy_language.negation_test

import rego.v1

import data.policy_language.negation

# shared test data
test_data := {
	"blocklist": ["5.6.7.8", "10.0.0.1"],
	"sanctioned_countries": ["CN", "KP"],
}

# --- is_blocked_ip ---

test_blocked_ip_true if {
	negation.is_blocked_ip with input as {"ip": "5.6.7.8", "country": "US", "score": 10}
		with data as test_data
}

test_blocked_ip_false if {
	not negation.is_blocked_ip with input as {"ip": "1.2.3.4", "country": "US", "score": 10}
		with data as test_data
}

# --- is_sanctioned_country ---

test_sanctioned_country_true if {
	negation.is_sanctioned_country with input as {"ip": "1.2.3.4", "country": "CN", "score": 10}
		with data as test_data
}

test_sanctioned_country_false if {
	not negation.is_sanctioned_country with input as {"ip": "1.2.3.4", "country": "DE", "score": 10}
		with data as test_data
}

# --- allow ---

test_allow_clean_request if {
	negation.allow with input as {"ip": "1.2.3.4", "country": "US", "score": 10}
		with data as test_data
}

test_deny_blocked_ip if {
	not negation.allow with input as {"ip": "5.6.7.8", "country": "US", "score": 10}
		with data as test_data
}

test_deny_sanctioned_country if {
	not negation.allow with input as {"ip": "1.2.3.4", "country": "KP", "score": 10}
		with data as test_data
}

test_deny_blocked_ip_and_sanctioned if {
	not negation.allow with input as {"ip": "10.0.0.1", "country": "CN", "score": 10}
		with data as test_data
}

# --- risk_decision ---

test_risk_decision_deny if {
	result := negation.risk_decision with input as {"ip": "1.2.3.4", "country": "US", "score": 85}
		with data as test_data
	result == "deny"
}

test_risk_decision_deny_boundary if {
	result := negation.risk_decision with input as {"ip": "1.2.3.4", "country": "US", "score": 81}
		with data as test_data
	result == "deny"
}

test_risk_decision_review if {
	result := negation.risk_decision with input as {"ip": "1.2.3.4", "country": "US", "score": 60}
		with data as test_data
	result == "review"
}

test_risk_decision_review_boundary if {
	result := negation.risk_decision with input as {"ip": "1.2.3.4", "country": "US", "score": 51}
		with data as test_data
	result == "review"
}

test_risk_decision_allow if {
	result := negation.risk_decision with input as {"ip": "1.2.3.4", "country": "US", "score": 30}
		with data as test_data
	result == "allow"
}

test_risk_decision_allow_boundary if {
	result := negation.risk_decision with input as {"ip": "1.2.3.4", "country": "US", "score": 50}
		with data as test_data
	result == "allow"
}
