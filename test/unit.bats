#!/usr/bin/env bats

setup() {
	. ./test/lib/test-helper.sh
	source_exec jfddns-update-script.sh
}

@test "IPV4_SITES" {
	for SITE in $IPV4_SITES; do
		_get_external_ip "$SITE"
	done
}

@test "IPV6_SITES" {
	for SITE in $IPV6_SITES; do
		_get_external_ip "$SITE"
	done
}

@test "_check_ipv4 1.2.3.4" {
	run _check_ipv4 1.2.3.4
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = '1.2.3.4' ]
}

@test "_check_ipv4 lol" {
	run _check_ipv4 lol
	[ "$status" -eq 1 ]
	[ "${lines[0]}" = '' ]
}

@test "_get_external_ipv4" {
	IP=$(_get_external_ipv4)
	[ -n "$IP" ]
}
