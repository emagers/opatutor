package policy_language.builtins_strings_test

import rego.v1

import data.policy_language.builtins_strings

# --- http_methods ---

test_http_methods_get if {
	result := builtins_strings.http_methods with input as {"methods": ["GET", "get", "POST", "GetAll", "put"]}
	result == {"GET", "get", "GetAll"}
}

test_http_methods_no_match if {
	result := builtins_strings.http_methods with input as {"methods": ["POST", "PUT", "DELETE"]}
	count(result) == 0
}

test_http_methods_only_get if {
	result := builtins_strings.http_methods with input as {"methods": ["GET"]}
	result == {"GET"}
}

# --- service_label ---

test_service_label if {
	result := builtins_strings.service_label with input as {"name": "auth", "env": "prod"}
	result == "svc-auth-prod"
}

test_service_label_dev if {
	result := builtins_strings.service_label with input as {"name": "payments", "env": "dev"}
	result == "svc-payments-dev"
}

# --- normalized_name ---

test_normalized_name_mixed_case if {
	result := builtins_strings.normalized_name with input as {"name": "MyService"}
	result == "myservice"
}

test_normalized_name_already_lower if {
	result := builtins_strings.normalized_name with input as {"name": "api"}
	result == "api"
}

test_normalized_name_all_upper if {
	result := builtins_strings.normalized_name with input as {"name": "GATEWAY"}
	result == "gateway"
}

# --- clean_hostname ---

test_clean_hostname_trims_spaces if {
	result := builtins_strings.clean_hostname with input as {"hostname": "  web-01.example.com  "}
	result == "web-01.example.com"
}

test_clean_hostname_no_spaces if {
	result := builtins_strings.clean_hostname with input as {"hostname": "db.internal"}
	result == "db.internal"
}
