package policy_language.variables_test

import rego.v1

import data.policy_language.variables

test_risky_ports_below_1024 if {
	result := variables.risky_ports with input as {"ports": [80, 443, 8080, 22, 3306]}
	result == {80, 443, 22}
}

test_no_risky_ports if {
	result := variables.risky_ports with input as {"ports": [8080, 8443, 3000]}
	count(result) == 0
}

test_all_risky_ports if {
	result := variables.risky_ports with input as {"ports": [21, 22, 80]}
	count(result) == 3
}
