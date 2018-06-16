#! /bin/sh

JFDDNS_DOMAIN='dyndns.example.com'
SECRET='12345678'
ZONE='subdomain.example.com'


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
VERSION=1.0
PROJECT_PAGES="https://github.com/Josef-Friedrich/jfddns-update-script.sh"
SHORT_DESCRIPTION='A shell script to update DNS records using the jfddns HTTP web API.'

NAME="jfddns-update-script.sh"
USAGE="$NAME v$VERSION

Usage: $NAME [-46dhrt] <record-name>

$SHORT_DESCRIPTION

https://github.com/Josef-Friedrich/jfddns

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

"

# https://github.com/phoemur/ipgetter/blob/master/ipgetter.py

IPV4_SITES="http://v4.ident.me
http://ipv4.myexternalip.com/raw"

IPV6_SITES="http://v6.ident.me
http://ipv6.myexternalip.com/raw"

# See https://stackoverflow.com/a/28466267

# Exit codes
# Invalid option: 2
# Missing argument: 3
# No argument allowed: 4
_getopts() {
	while getopts ':46d:hst:v-:' OPT ; do
		case $OPT in
			4) OPT_IPV4=1 ;;
			6) OPT_IPV6=1 ;;
			d) OPT_DEVICE="$OPTARG" ;;
			h) echo "$USAGE" ; exit 0 ;;
			t) OPT_TTL="$OPTARG" ;;
			s) echo "$SHORT_DESCRIPTION" ; exit 0 ;;
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
					ttl=?*) OPT_TTL="$LONG_OPTARG" ;;
					version) echo "$VERSION" ; exit 0 ;;

					device*|ttl*)
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
	curl -fs "$1"
}

########################################################################

# _get_ipv4() {
# 	if [ -z "$OPT_DEVICE" ] ; then
# 		echo "No device given!" >&2
# 		exit 9
# 	fi
# 	ip -4 addr show dev $OPT_DEVICE | \
# 		grep inet | \
# 		sed -e 's/.*inet \([.0-9]*\).*/\1/'
# }

_check_ipv4() {
	echo "$1" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
}

_get_external_ipv4() {
	local IP
	for SITE in $IPV4_SITES; do
		IP="$(_get_external_ip "$SITE")"
		IP="$(_check_ipv4 "$IP")"
		echo "$IP" > $HOME/debug
		if [ -n "$IP" ]; then
			break
		fi
	done
	echo "$IP"
}

########################################################################

_check_ipv6() {
	echo "$1" | grep -E '(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))'
}

_get_ipv6() {
	if [ -z "$OPT_DEVICE" ] ; then
		echo "No device given!" >&2
		exit 9
	fi
	ip -6 addr list scope global $OPT_DEVICE | \
		grep -v " fd" | \
		sed -n 's/.*inet6 \([0-9a-f:]\+\).*/\1/p' | head -n 1
}

# _get_external_ipv6() {
# 	/usr/bin/curl -fs http://v6.ident.me
# }

########################################################################


## This SEPARATOR is required for test purposes. Please don’t remove! ##


_getopts $@
shift $GETOPTS_SHIFT
OPT_RECORD="$1"


if [ -z "$OPT_RECORD" ]; then
	echo "$USAGE"
	exit 17
fi

if [ -z "$OPT_IPV4" ] && [ -z "$OPT_IPV6" ]; then
	OPT_IPV4=1
	OPT_IPV6=1
fi

if [ -n "$OPT_IPV6" ] && [ -z "$OPT_DEVICE" ]; then
	echo "-6 needs a device (-d)"
	exit 1
fi

if [ -n "$OPT_IPV4" ]; then
	QUERY_IPV4="&ipv4=$(_get_external_ipv4)"
fi

if [ -n "$OPT_IPV6" ]; then
	QUERY_IPV6="&ipv6=$(_get_ipv6)"
fi

BASE_URL='https://${JFDDNS_DOMAIN}/update-by-query'
URL="$BASE_URL?zone_name=$ZONE&secret=$SECRET"

QUERY_RECORD="&record_name=$OPT_RECORD"

echo url="${URL}${QUERY_RECORD}${QUERY_IPV4}${QUERY_IPV6}" | curl -k -K -
