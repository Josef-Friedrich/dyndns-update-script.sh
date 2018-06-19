#!/usr/bin/env bats

setup() {
	. ./test/lib/test-helper.sh
	mock_path test/bin
}

@test "./jfddns-update-script.sh" {
	run ./jfddns-update-script.sh
	[ "$status" -eq 17 ]
}

@test "./jfddns-update-script.sh lol" {
	run ./jfddns-update-script.sh lol
	[ "$status" -eq 0 ]
	[ "${lines[1]}" = "record_name: 'lol', ipv4: '1.2.3.4', ipv6: '200c:6b7e:49e8:0::1', ttl: ''" ]
	[ "${lines[2]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ipv6=200c:6b7e:49e8:0::1" ]
}

@test "./jfddns-update-script.sh -S 1 lol" {
	run ./jfddns-update-script.sh -S 1 lol
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "Delay the execution by 1 seconds." ]
	[ "${lines[2]}" = "record_name: 'lol', ipv4: '1.2.3.4', ipv6: '200c:6b7e:49e8:0::1', ttl: ''" ]
	[ "${lines[3]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ipv6=200c:6b7e:49e8:0::1" ]
}

@test "./jfddns-update-script.sh --sleep 1 lol" {
	run ./jfddns-update-script.sh --sleep=1 lol
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "Delay the execution by 1 seconds." ]
	[ "${lines[2]}" = "record_name: 'lol', ipv4: '1.2.3.4', ipv6: '200c:6b7e:49e8:0::1', ttl: ''" ]
	[ "${lines[3]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ipv6=200c:6b7e:49e8:0::1" ]
}

@test "./jfddns-update-script.sh -d eth0 lol" {
	run ./jfddns-update-script.sh -d eth0 lol
	[ "$status" -eq 0 ]
	[ "${lines[2]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ipv6=200c:1:2:c3::1" ]
}

@test "./jfddns-update-script.sh --device=eth0 lol" {
	run ./jfddns-update-script.sh --device=eth0 lol
	[ "$status" -eq 0 ]
	[ "${lines[2]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ipv6=200c:1:2:c3::1" ]
}

@test "./jfddns-update-script.sh -4 lol" {
	run ./jfddns-update-script.sh -4 lol
	[ "$status" -eq 0 ]
	[ "${lines[2]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4" ]
}

@test "./jfddns-update-script.sh --ipv4-only lol" {
	run ./jfddns-update-script.sh --ipv4-only lol
	[ "$status" -eq 0 ]
	[ "${lines[2]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4" ]
}

@test "./jfddns-update-script.sh -6 lol" {
	run ./jfddns-update-script.sh -6 lol
	[ "$status" -eq 0 ]
	[ "${lines[2]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv6=200c:6b7e:49e8:0::1" ]
}

@test "./jfddns-update-script.sh --ipv6-only lol" {
	run ./jfddns-update-script.sh --ipv6-only lol
	[ "$status" -eq 0 ]
	[ "${lines[2]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv6=200c:6b7e:49e8:0::1" ]
}

@test "./jfddns-update-script.sh -6 -d eth0 lol" {
	run ./jfddns-update-script.sh -6 -d eth0 lol
	[ "$status" -eq 0 ]
	[ "${lines[2]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv6=200c:1:2:c3::1" ]
}

@test "./jfddns-update-script.sh --ipv6-only --device=eth0 lol" {
	run ./jfddns-update-script.sh --ipv6-only --device=eth0 lol
	[ "$status" -eq 0 ]
	[ "${lines[2]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv6=200c:1:2:c3::1" ]
}

@test "./jfddns-update-script.sh -4 -t 123 lol" {
	run ./jfddns-update-script.sh -4 -t 123 lol
	[ "$status" -eq 0 ]
	[ "${lines[2]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ttl=123" ]
}

@test "./jfddns-update-script.sh --ipv4-only --ttl=123 lol" {
	run ./jfddns-update-script.sh --ipv4-only --ttl=123 lol
	[ "$status" -eq 0 ]
	[ "${lines[2]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ttl=123" ]
}

@test "./jfddns-update-script.sh -v" {
	run ./jfddns-update-script.sh -v
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "1.0" ]
}

@test "./jfddns-update-script.sh --version" {
	run ./jfddns-update-script.sh --version
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "1.0" ]
}
