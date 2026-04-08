package policy_language.builtins_strings_test

import rego.v1

import data.policy_language.builtins_strings

test_http_methods_get if {
	result := builtins_strings.http_methods with input as {"methods": ["GET", "get", "POST", "GetAll", "put"]}
	result == {"GET", "get", "GetAll"}
}

test_http_methods_no_match if {
	result := builtins_strings.http_methods with input as {"methods": ["POST", "PUT", "DELETE"]}
	count(result) == 0
}

test_service_label if {
	result := builtins_strings.service_label with input as {"name": "auth", "env": "prod"}
	result == "svc-auth-prod"
}

test_normalized_name if {
	result := builtins_strings.normalized_name with input as {"name": "MyService"}
	result == "myservice"
}
