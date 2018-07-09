#!/usr/bin/env bats

setup() {
	. ./test/lib/test-helper.sh
	source_exec dyndns-update-script.sh
}

# -4, --ipv4-only

@test "_getopts -4" {
	_getopts -4
	[ "$OPT_IPV4" -eq 1 ]
}

@test "_getopts --ipv4-only" {
	_getopts --ipv4-only
	[ "$OPT_IPV4" -eq 1 ]
}

@test "_getopts --ipv4-only=123" {
	run _getopts --ipv4-only=123
	[ "$status" -eq 4 ]
}

# -6, --ipv6-only

@test "_getopts -6" {
	_getopts -6
	[ "$OPT_IPV6" -eq 1 ]
}

@test "_getopts --ipv6-only" {
	_getopts --ipv6-only
	[ "$OPT_IPV6" -eq 1 ]
}

@test "_getopts --ipv6-only=123" {
	run _getopts --ipv6-only=123
	[ "$status" -eq 4 ]
}

# -d, --device

@test "_getopts -d 123" {
	_getopts -d 123
	[ "$OPT_DEVICE" -eq 123 ]
}

@test "_getopts -d" {
	run _getopts -d
	[ "$status" -eq 3 ]
}

@test "_getopts --device=123" {
	_getopts --device=123
	[ "$OPT_DEVICE" -eq 123 ]
}

@test "_getopts --device" {
	run _getopts --device
	[ "$status" -eq 3 ]
}

# -h, --help

@test "_getopts -h" {
	run _getopts -h
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "dyndns-update-script.sh v$VERSION" ]
}

@test "_getopts --help" {
	run _getopts --help
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "dyndns-update-script.sh v$VERSION" ]
}

@test "_getopts --help=123" {
	run _getopts --help=123
	[ "$status" -eq 4 ]
}

# -s, --short-description

@test "_getopts -s" {
	run _getopts -s
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = 'A shell script to update DNS records using the dyndns HTTP web API.' ]
}

@test "_getopts --short-description" {
	run _getopts --short-description
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = 'A shell script to update DNS records using the dyndns HTTP web API.' ]
}

@test "_getopts --short-description=123" {
	run _getopts --short-description=123
	[ "$status" -eq 4 ]
}

# -S, --sleep

@test "_getopts -S 123" {
	_getopts -S 123
	[ "$OPT_SLEEP" -eq 123 ]
}

@test "_getopts -S" {
	run _getopts -S
	[ "$status" -eq 3 ]
}

@test "_getopts --sleep=123" {
	_getopts --sleep=123
	[ "$OPT_SLEEP" -eq 123 ]
}

@test "_getopts --sleep" {
	run _getopts --sleep
	[ "$status" -eq 3 ]
}

# -t, --ttl

@test "_getopts -t 123" {
	_getopts -t 123
	[ "$OPT_TTL" -eq 123 ]
}

@test "_getopts -t" {
	run _getopts -t
	[ "$status" -eq 3 ]
}

@test "_getopts --ttl=123" {
	_getopts --ttl=123
	[ "$OPT_TTL" -eq 123 ]
}

@test "_getopts --ttl" {
	run _getopts --ttl
	[ "$status" -eq 3 ]
}

# -v, --version

@test "_getopts -v" {
	run _getopts -v
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "$VERSION" ]
}

@test "_getopts --version" {
	run _getopts --version
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "$VERSION" ]
}

@test "_getopts --version=123" {
	run _getopts --version=123
	[ "$status" -eq 4 ]
}
