#!/usr/bin/env bats

setup() {
	. ./test/lib/test-helper.sh
	mock_path test/bin
}

@test "./jfddns-update-script.sh" {
	run ./jfddns-update-script.sh
	[ "$status" -eq 17 ]
}
