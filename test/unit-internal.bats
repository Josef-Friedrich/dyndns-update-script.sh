#!/usr/bin/env bats

setup() {
	. ./test/lib/test-helper.sh
  mock_path test/bin
	source_exec dyndns-update-script.sh
}

@test "_format_ipv6_prefix" {
  local PREFIX
	PREFIX="$(_format_ipv6_prefix 200300e953ce9100)"
	[ "$PREFIX" = '2003:00e9:53ce:9100' ]
}

@test "_get_ipv6_prefix_internal" {
  local PREFIX
  OPT_DEVICE=eth0
	PREFIX="$(_get_ipv6_prefix_internal)"
	[ "$PREFIX" = '2003:00e9:53ce:9100' ]
}