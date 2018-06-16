#!/usr/bin/env bats

setup() {
	. ./test/lib/test-helper.sh
	mock_path test/bin
}

@test "./jfddns-update-script.sh" {
	run ./jfddns-update-script.sh
	[ "$status" -eq 17 ]
}

@test "./jfddns-update-script.sh -4 lol" {
	run ./jfddns-update-script.sh -4 lol
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "url=https://dyndns.example.com/update-by-query?zone_name=subdomain.example.com&secret=12345678&record_name=lol&ipv4=1.2.3.4" ]
}

@test "./jfddns-update-script.sh -6 lol" {
	run ./jfddns-update-script.sh -6 lol
	[ "$status" -eq 23 ]
	[ "${lines[0]}" = "-6 needs a device (-d)" ]
}

@test "./jfddns-update-script.sh -6 -d eth0 lol" {
	run ./jfddns-update-script.sh -6 -d eth0 lol
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "url=https://dyndns.example.com/update-by-query?zone_name=subdomain.example.com&secret=12345678&record_name=lol&ipv6=200c:ef45:4c06:3300:b832:fe2d:bb21:60bd" ]
}
