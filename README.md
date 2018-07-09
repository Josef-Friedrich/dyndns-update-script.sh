[![Build Status](https://travis-ci.org/Josef-Friedrich/dyndns-update-script.sh.svg?branch=master)](https://travis-ci.org/Josef-Friedrich/dyndns-update-script.sh)

# dyndns-update-script.sh


## Summary / Short description

> A shell script to update DNS records using the dyndns HTTP web API.

## Usage

```
Usage: dyndns-update-script.sh [-46dhrt] <record-name>

A shell script to update DNS records using the dyndns HTTP web API.

https://github.com/Josef-Friedrich/dyndns

Options:
	-4, --ipv4-only
	  Update the ipv4 / A record only.
	-6, --ipv6-only
	  Update the ipv6 / AAAA record only.
	-d, --device
	  The interface (device to look for an IP address), e. g. “eth0”
	-h, --help
	  Show this help message.
	-t, --ttl
	  Time to live for updated record; default 3600s., e. g. “300”


```

## Project pages

* https://github.com/Josef-Friedrich/dyndns-update-script.sh

## Testing

```
make test
```

