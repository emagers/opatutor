package policy_language.negation_test

import rego.v1

import data.policy_language.negation

# --- is_blocked_ip ---

test_blocked_ip_true if {
	negation.is_blocked_ip with input as {"ip": "5.6.7.8", "country": "US", "score": 10}
}

test_blocked_ip_false if {
	not negation.is_blocked_ip with input as {"ip": "1.2.3.4", "country": "US", "score": 10}
}

# --- is_sanctioned_country ---

test_sanctioned_country_true if {
	negation.is_sanctioned_country with input as {"ip": "1.2.3.4", "country": "CN", "score": 10}
}

test_sanctioned_country_false if {
	not negation.is_sanctioned_country with input as {"ip": "1.2.3.4", "country": "DE", "score": 10}
}

# --- allow ---

test_allow_clean_request if {
	negation.allow with input as {"ip": "1.2.3.4", "country": "US", "score": 10}
}

test_deny_blocked_ip if {
	not negation.allow with input as {"ip": "5.6.7.8", "country": "US", "score": 10}
}

test_deny_sanctioned_country if {
	not negation.allow with input as {"ip": "1.2.3.4", "country": "KP", "score": 10}
}

test_deny_blocked_ip_and_sanctioned if {
	not negation.allow with input as {"ip": "10.0.0.1", "country": "CN", "score": 10}
}

# --- risk_decision ---

test_risk_decision_deny if {
	result := negation.risk_decision with input as {"ip": "1.2.3.4", "country": "US", "score": 85}
	result == "deny"
}

test_risk_decision_deny_boundary if {
	result := negation.risk_decision with input as {"ip": "1.2.3.4", "country": "US", "score": 81}
	result == "deny"
}

test_risk_decision_review if {
	result := negation.risk_decision with input as {"ip": "1.2.3.4", "country": "US", "score": 60}
	result == "review"
}

test_risk_decision_review_boundary if {
	result := negation.risk_decision with input as {"ip": "1.2.3.4", "country": "US", "score": 51}
	result == "review"
}

test_risk_decision_allow if {
	result := negation.risk_decision with input as {"ip": "1.2.3.4", "country": "US", "score": 30}
	result == "allow"
}

test_risk_decision_allow_boundary if {
	result := negation.risk_decision with input as {"ip": "1.2.3.4", "country": "US", "score": 50}
	result == "allow"
}
