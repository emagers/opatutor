package opa_tooling.network_test

import rego.v1

import data.opa_tooling.network

# Mock data (mirrors data.json — using `with` ensures tests work in all
# contexts: CLI, VSCode test runner, etc.)
mock_allowed_cidrs := ["10.0.0.0/8", "192.168.0.0/16"]

mock_allowed_ports := [80, 443, 8080, 8443]

test_internal_ip_port_443_allowed if {
	network.allow with input as {"destination": {"ip": "10.1.2.3", "port": 443}}
		with data.allowed_cidrs as mock_allowed_cidrs
		with data.allowed_ports as mock_allowed_ports
}

test_internal_ip_port_8080_allowed if {
	network.allow with input as {"destination": {"ip": "192.168.1.50", "port": 8080}}
		with data.allowed_cidrs as mock_allowed_cidrs
		with data.allowed_ports as mock_allowed_ports
}

test_external_ip_denied if {
	not network.allow with input as {"destination": {"ip": "8.8.8.8", "port": 443}}
		with data.allowed_cidrs as mock_allowed_cidrs
		with data.allowed_ports as mock_allowed_ports
}

test_internal_ip_blocked_port_denied if {
	not network.allow with input as {"destination": {"ip": "10.0.0.1", "port": 22}}
		with data.allowed_cidrs as mock_allowed_cidrs
		with data.allowed_ports as mock_allowed_ports
}

test_internal_ip_port_80_allowed if {
	network.allow with input as {"destination": {"ip": "192.168.10.1", "port": 80}}
		with data.allowed_cidrs as mock_allowed_cidrs
		with data.allowed_ports as mock_allowed_ports
}
