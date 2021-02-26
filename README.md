[![Build Status](https://travis-ci.org/Josef-Friedrich/dyndns-update-script.sh.svg?branch=master)](https://travis-ci.org/Josef-Friedrich/dyndns-update-script.sh)

# dyndns-update-script.sh


## Summary / Short description

> A shell script to update DNS records using the dyndns HTTP web API.

## Usage

```
dyndns-update-script.sh v1.1

Usage: dyndns-update-script.sh [-46dhsStv] <record-name>

A shell script to update DNS records using the dyndns HTTP web API.

This script is a update script for dyndns
(https://github.com/Josef-Friedrich/dyndns).

Options:
	-4, --ipv4-only
	  Update only the ipv4 / A record.
	-6, --ipv6-only
	  Update only the ipv6 / AAAA record.
	-d, --device
	  The interface / device to look for an external IP address, e. g. “eth0”
	-h, --help
	  Show this help message.
	-p, --prefix-only
	  Update only the ipv6 prefix.
	-s, --short-description
	  Show a short description / summary.
	-S, --sleep <seconds>
	  Sleep some seconds before execution. If you have configured several
	  calls via a cronjob you can use this option to avoid overloading the
	  dyndns server.
	-t, --ttl <seconds>
	  Set the Time to Live entry for the updated record; e. g. “300”
	  for 5 minutes
	-v, --version
	  Show the version number of this script.

```

## Project pages

* https://github.com/Josef-Friedrich/dyndns-update-script.sh

## Testing

```
make test
```

