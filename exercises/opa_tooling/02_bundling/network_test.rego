package opa_tooling.network_test

import rego.v1

import data.opa_tooling.network

test_internal_ip_port_443_allowed if {
	network.allow with input as {"destination": {"ip": "10.1.2.3", "port": 443}}
}

test_internal_ip_port_8080_allowed if {
	network.allow with input as {"destination": {"ip": "192.168.1.50", "port": 8080}}
}

test_external_ip_denied if {
	not network.allow with input as {"destination": {"ip": "8.8.8.8", "port": 443}}
}

test_internal_ip_blocked_port_denied if {
	not network.allow with input as {"destination": {"ip": "10.0.0.1", "port": 22}}
}

test_internal_ip_port_80_allowed if {
	network.allow with input as {"destination": {"ip": "192.168.10.1", "port": 80}}
}
