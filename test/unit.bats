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
