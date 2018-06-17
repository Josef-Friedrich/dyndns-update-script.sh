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

@test "test http://v4.ident.me" {
	curl -fs http://v4.ident.me
}

@test "test http://ipv4.myexternalip.com/raw" {
	curl -fs http://ipv4.myexternalip.com/raw
}

@test "IPV6_SITES" {
	if ! ping6 -c 1 ipv6.google.com > /dev/null 2>&1 ; then
		skip
	fi
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

@test "_get_ipv4_external" {
	IP=$(_get_ipv4_external)
	[ -n "$IP" ]
}

@test "_check_ipv6 fe80::42:80ff:fe3b:860a" {
	run _check_ipv6 fe80::42:80ff:fe3b:860a
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = 'fe80::42:80ff:fe3b:860a' ]
}

@test "_check_ipv6 lol" {
	run _check_ipv6 lol
	[ "$status" -eq 1 ]
	[ "${lines[0]}" = '' ]
}

@test "_get_ipv6_internal" {
	OPT_DEVICE='XXX'
	run _get_ipv6_internal
	[ "$status" -eq 0 ]

	mock_path test/bin
	IPV6="$(_get_ipv6_internal)"
	[ "$IPV6" = '200c:1:2:c3::1' ]
}

@test "_get_ipv6_internal: no device" {
	run _get_ipv6_internal
	[ "$status" -eq 9 ]
	[ "${lines[0]}" = "No device given!" ]
}
