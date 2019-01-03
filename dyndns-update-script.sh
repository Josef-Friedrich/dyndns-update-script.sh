#! /bin/sh

VALUE_DYNDNS_DOMAIN='dyndns.example.com'
VALUE_SECRET='123'
VALUE_ZONE_NAME='sub.example.com'

# MIT License
#
# Copyright (c) 2018 Josef Friedrich <josef@friedrich.rocks>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

FIRST_RELEASE=2018-06-16
VERSION=1.1
PROJECT_PAGES="https://github.com/Josef-Friedrich/dyndns-update-script.sh"
SHORT_DESCRIPTION='A shell script to update DNS records using the dyndns HTTP web API.'

NAME="dyndns-update-script.sh"
USAGE="$NAME v$VERSION

Usage: $NAME [-46dhsStv] <record-name>

$SHORT_DESCRIPTION

This script is a update script for dyndns
(https://github.com/Josef-Friedrich/dyndns).

Options:
	-4, --ipv4-only
	  Update the ipv4 / A record only.
	-6, --ipv6-only
	  Update the ipv6 / AAAA record only.
	-d, --device
	  The interface (device to look for an IP address), e. g. “eth0”
	-h, --help
	  Show this help message.
	-s, --short-description
	  Show a short description / summary.
	-S, --sleep
	  Sleep in seconds before execution.
	-t, --ttl
	  Time to live for updated record; e. g. “300”
	-v, --version
	  Show the version number of this script.
"

# https://github.com/phoemur/ipgetter/blob/master/ipgetter.py

IPV4_SITES="http://v4.ident.me
http://v4.icanhazip.com"

IPV6_SITES="http://v6.ident.me
http://v6.icanhazip.com"

# See https://stackoverflow.com/a/28466267

# Exit codes
# Invalid option: 2
# Missing argument: 3
# No argument allowed: 4
_getopts() {
	while getopts ':46d:hsS:t:v-:' OPT ; do
		case $OPT in
			4) OPT_IPV4=1 ;;
			6) OPT_IPV6=1 ;;
			d) OPT_DEVICE="$OPTARG" ;;
			h) echo "$USAGE" ; exit 0 ;;
			t) OPT_TTL="$OPTARG" ;;
			s) echo "$SHORT_DESCRIPTION" ; exit 0 ;;
			S) OPT_SLEEP="$OPTARG" ;;
			v) echo "$VERSION" ; exit 0 ;;
			\?) echo "Invalid option “-$OPTARG”!" >&2 ; exit 2 ;;
			:) echo "Option “-$OPTARG” requires an argument!" >&2 ; exit 3 ;;

			-)
				LONG_OPTARG="${OPTARG#*=}"

				case $OPTARG in
					ipv4-only) OPT_IPV4=1 ;;
					ipv6-only) OPT_IPV6=1 ;;
					device=?*) OPT_DEVICE="$LONG_OPTARG" ;;
					help) echo "$USAGE" ; exit 0 ;;
					short-description) echo "$SHORT_DESCRIPTION" ; exit 0 ;;
					sleep=?*) OPT_SLEEP="$LONG_OPTARG" ;;
					ttl=?*) OPT_TTL="$LONG_OPTARG" ;;
					version) echo "$VERSION" ; exit 0 ;;

					device*|sleep*|ttl*)
						echo "Option “--$OPTARG” requires an argument!" >&2
						exit 3
						;;

					ipv4-only*|ipv6-only*|help*|short-description*|version*)
						echo "No argument allowed for the option “--$OPTARG”!" >&2
						exit 4
						;;

					'') break ;; # "--" terminates argument processing
					*) echo "Invalid option “--$OPTARG”!" >&2 ; exit 2 ;;

				esac
				;;

		esac
	done
	GETOPTS_SHIFT=$((OPTIND - 1))
}

_get_external_ip() {
	curl -s -f "$1"
}

### ipv4 ###############################################################

_check_ipv4() {
	echo "$1" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
}

# _get_ipv4_internal() {
# 	if [ -z "$OPT_DEVICE" ]; then
# 		echo "No device given!" >&2
# 		exit 9
# 	fi
# 	ip -4 addr show dev "$OPT_DEVICE" | \
# 		grep inet | \
# 		grep -v " 192.168." | \
# 		sed -e 's/.*inet \([.0-9]*\).*/\1/'
# }

_get_ipv4_external() {
	local IP
	for SITE in $IPV4_SITES; do
		echo "IPV4: Query external site '$SITE' for an ipv4 address." 1>&2
		IP="$(_get_external_ip "$SITE")"
		IP="$(_check_ipv4 "$IP")"
		if [ -n "$IP" ]; then
			echo "IPV4: Got '$IP' from '$SITE'." 1>&2
			break
		fi
	done
	echo "$IP"
}

### ipv6 ###############################################################

# https://gist.github.com/syzdek/6086792
# https://stackoverflow.com/a/17871737
_check_ipv6() {
	echo "$1" | grep -E '(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))'
}

_get_ipv6_internal() {
	local IP
	if [ -z "$OPT_DEVICE" ] ; then
		echo "No device given!" >&2
		exit 9
	fi
	echo "IPV6: Query device '$OPT_DEVICE' for an ipv6 address." 1>&2

	IP=$(ip -6 addr list scope global "$OPT_DEVICE" | \
		grep -v " fd" | \
		sed -n 's/.*inet6 \([0-9a-f:]\+\).*/\1/p' | head -n 1)
	IP="$(_check_ipv6 "$IP")"
	if [ -n "$IP" ]; then
		echo "IPV6: Got '$IP' from device '$OPT_DEVICE'." 1>&2
		echo "$IP"
	fi
}

_get_ipv6_external() {
	local IP
	for SITE in $IPV6_SITES; do
		echo "IPV6: Query external site '$SITE' for an ipv6 address." 1>&2
		IP="$(_get_external_ip "$SITE")"
		IP="$(_check_ipv6 "$IP")"
		if [ -n "$IP" ]; then
			echo "IPV6: Got '$IP' from '$SITE'." 1>&2
			break
		fi
	done
	echo "$IP"
}

## This SEPARATOR is required for test purposes. Please don’t remove! ##

_getopts $@
shift $GETOPTS_SHIFT
OPT_RECORD_NAME="$1"
VALUE_RECORD_NAME="$OPT_RECORD_NAME"

if [ -z "$OPT_RECORD_NAME" ]; then
	echo "Specify a record name!" >&2
	echo "$USAGE" >&2
	exit 17
fi

if [ -z "$OPT_IPV4" ] && [ -z "$OPT_IPV6" ]; then
	OPT_IPV4=1
	OPT_IPV6=1
fi

if [ -n "$OPT_IPV4" ]; then
	VALUE_IPV4="$(_get_ipv4_external)"
	VALUE_IPV4="$(_check_ipv4 "$VALUE_IPV4")"
	if [ -n "$VALUE_IPV4" ]; then
		QUERY_IPV4="&ipv4=$VALUE_IPV4"
	fi
fi

if [ -n "$OPT_IPV6" ]; then
	if [ -n "$OPT_DEVICE" ]; then
		VALUE_IPV6="$(_get_ipv6_internal)"
	fi
	if [ -z "$VALUE_IPV6" ]; then
		VALUE_IPV6="$(_get_ipv6_external)"
	fi
	if [ -n "$VALUE_IPV6" ]; then
		QUERY_IPV6="&ipv6=$VALUE_IPV6"
	fi
fi

if [ -n "$OPT_TTL" ]; then
	VALUE_TTL="$OPT_TTL"
	QUERY_TTL="&ttl=$VALUE_TTL"
fi

BASE_URL="https://${VALUE_DYNDNS_DOMAIN}/update-by-query"
URL="$BASE_URL?zone_name=${VALUE_ZONE_NAME}&secret=${VALUE_SECRET}"

QUERY_RECORD_NAME="&record_name=$VALUE_RECORD_NAME"

if [ -n "$OPT_SLEEP" ]; then
	echo "Delay the execution by $OPT_SLEEP seconds."
	sleep $OPT_SLEEP
fi

echo "SCRIPT_VALUES: dyndns_domain: '${VALUE_DYNDNS_DOMAIN}', zone_name: '${VALUE_ZONE_NAME}', secret: '${VALUE_SECRET}'"
echo "PARAMETER: record_name: '${VALUE_RECORD_NAME}', ipv4: '${VALUE_IPV4}', ipv6: '${VALUE_IPV6}', ttl: '${VALUE_TTL}'"

URL="${URL}${QUERY_RECORD_NAME}${QUERY_IPV4}${QUERY_IPV6}${QUERY_TTL}"

echo "Try to update the DNS server using this url: '$URL'."
echo url="${URL}" | curl -s -k -K -

if ! [ "$?" -eq 0 ]; then
	echo "ERROR: curl exit with an non zero return code." >&2
fi
