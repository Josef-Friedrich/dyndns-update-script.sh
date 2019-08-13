#!/usr/bin/env bats

setup() {
	. ./test/lib/test-helper.sh
	mock_path test/bin
}

@test "./dyndns-update-script.sh" {
	run ./dyndns-update-script.sh
	[ "${lines[0]}" = "Specify a record name!" ]
	[ "$status" -eq 17 ]
}


# 0: IPV4: Query 'http://v4.ident.me' for an ipv4 address.
# 1: IPV4: Got '1.2.3.4' from 'http://v4.ident.me'.
# 2: IPV6: Query 'http://v6.ident.me' for an ipv6 address.
# 3: IPV6: Query 'http://v6.icanhazip.com' for an ipv6 address.
# 4: IPV6: Got '200c:6b7e:49e8:0::1' from 'http://v6.icanhazip.com'.
# 5: SCRIPT_VALUES: dyndns_domain: 'dyndns.example.com', zone_name: 'sub.example.com', secret: '123'
# 6: PARAMETER: record_name: 'lol', ipv4: '1.2.3.4', ipv6: '200c:6b7e:49e8:0::1', ttl: ''
# 7: Try to update the DNS server using this url: 'https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ipv6=200c:6b7e:49e8:0::1'.
# 8: url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ipv6=200c:6b7e:49e8:0::1

# echo "0: ${lines[0]}" > $HOME/debug
# echo "1: ${lines[1]}" >> $HOME/debug
# echo "2: ${lines[2]}" >> $HOME/debug
# echo "3: ${lines[3]}" >> $HOME/debug
# echo "4: ${lines[4]}" >> $HOME/debug
# echo "5: ${lines[5]}" >> $HOME/debug
# echo "6: ${lines[6]}" >> $HOME/debug
# echo "7: ${lines[7]}" >> $HOME/debug
# echo "8: ${lines[8]}" >> $HOME/debug
# echo "9: ${lines[9]}" >> $HOME/debug
# echo "10: ${lines[10]}" >> $HOME/debug

@test "./dyndns-update-script.sh lol" {
	run ./dyndns-update-script.sh lol
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "IPV4: Query external site 'http://v4.ident.me' for an ipv4 address." ]
	[ "${lines[1]}" = "IPV4: Got '1.2.3.4' from 'http://v4.ident.me'." ]
	[ "${lines[2]}" = "IPV6: Query external site 'http://v6.ident.me' for an ipv6 address." ]
	[ "${lines[3]}" = "IPV6: Query external site 'http://v6.icanhazip.com' for an ipv6 address." ]
	[ "${lines[4]}" = "IPV6: Got '200c:6b7e:49e8:0::1' from 'http://v6.icanhazip.com'." ]
	[ "${lines[5]}" = "SCRIPT_VALUES: dyndns_domain: 'dyndns.example.com', zone_name: 'sub.example.com', secret: '123'" ]
	[ "${lines[6]}" = "PARAMETER: record_name: 'lol', ipv4: '1.2.3.4', ipv6: '200c:6b7e:49e8:0::1', ttl: ''" ]
	[ "${lines[7]}" = "Try to update the DNS server using this url: 'https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ipv6=200c:6b7e:49e8:0::1'." ]
	[ "${lines[8]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ipv6=200c:6b7e:49e8:0::1" ]
}

@test "./dyndns-update-script.sh -S 1 lol" {
	run ./dyndns-update-script.sh -S 1 lol
	[ "$status" -eq 0 ]
	[ "${lines[5]}" = "Delay the execution by 1 seconds." ]
	[ "${lines[7]}" = "PARAMETER: record_name: 'lol', ipv4: '1.2.3.4', ipv6: '200c:6b7e:49e8:0::1', ttl: ''" ]
	[ "${lines[9]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ipv6=200c:6b7e:49e8:0::1" ]
}

@test "./dyndns-update-script.sh --sleep 1 lol" {
	run ./dyndns-update-script.sh --sleep=1 lol
	[ "$status" -eq 0 ]
	[ "${lines[5]}" = "Delay the execution by 1 seconds." ]
	[ "${lines[7]}" = "PARAMETER: record_name: 'lol', ipv4: '1.2.3.4', ipv6: '200c:6b7e:49e8:0::1', ttl: ''" ]
	[ "${lines[9]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ipv6=200c:6b7e:49e8:0::1" ]
}

@test "./dyndns-update-script.sh -d eth0 lol" {
	run ./dyndns-update-script.sh -d eth0 lol
	[ "$status" -eq 0 ]
	[ "${lines[7]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ipv6=200c:1:2:c3::1" ]
}

@test "./dyndns-update-script.sh --device=eth0 lol" {
	run ./dyndns-update-script.sh --device=eth0 lol
	[ "$status" -eq 0 ]
	[ "${lines[7]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ipv6=200c:1:2:c3::1" ]
}

@test "./dyndns-update-script.sh -4 lol" {
	run ./dyndns-update-script.sh -4 lol
	[ "$status" -eq 0 ]
	[ "${lines[5]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4" ]
}

@test "./dyndns-update-script.sh --ipv4-only lol" {
	run ./dyndns-update-script.sh --ipv4-only lol
	[ "$status" -eq 0 ]
	[ "${lines[5]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4" ]
}

@test "./dyndns-update-script.sh -6 lol" {
	run ./dyndns-update-script.sh -6 lol
	[ "$status" -eq 0 ]
	[ "${lines[6]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv6=200c:6b7e:49e8:0::1" ]
}

@test "./dyndns-update-script.sh --ipv6-only lol" {
	run ./dyndns-update-script.sh --ipv6-only lol
	[ "$status" -eq 0 ]
	[ "${lines[6]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv6=200c:6b7e:49e8:0::1" ]
}

@test "./dyndns-update-script.sh -6 -d eth0 lol" {
	run ./dyndns-update-script.sh -6 -d eth0 lol
	[ "$status" -eq 0 ]
	[ "${lines[5]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv6=200c:1:2:c3::1" ]
}

@test "./dyndns-update-script.sh --ipv6-only --device=eth0 lol" {
	run ./dyndns-update-script.sh --ipv6-only --device=eth0 lol
	[ "$status" -eq 0 ]
	[ "${lines[5]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv6=200c:1:2:c3::1" ]
}

@test "./dyndns-update-script.sh -4 -t 123 lol" {
	run ./dyndns-update-script.sh -4 -t 123 lol
	[ "$status" -eq 0 ]
	[ "${lines[5]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ttl=123" ]
}

@test "./dyndns-update-script.sh --ipv4-only --ttl=123 lol" {
	run ./dyndns-update-script.sh --ipv4-only --ttl=123 lol
	[ "$status" -eq 0 ]
	[ "${lines[5]}" = "url=https://dyndns.example.com/update-by-query?zone_name=sub.example.com&secret=123&record_name=lol&ipv4=1.2.3.4&ttl=123" ]
}

@test "./dyndns-update-script.sh -p -d eth0 lol" {
	run ./dyndns-update-script.sh -p -d eth0 lol
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "PREFIX: 2003:00e9:53ce:9100" ]
}

@test "./dyndns-update-script.sh -v" {
	source_exec dyndns-update-script.sh
	run ./dyndns-update-script.sh -v
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "$VERSION" ]
}

@test "./dyndns-update-script.sh --version" {
	source_exec dyndns-update-script.sh
	run ./dyndns-update-script.sh --version
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "$VERSION" ]
}
