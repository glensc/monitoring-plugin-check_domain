#!/bin/sh
# Nagios plugin for checking a domain name expiration date
#
# Copyright (c) 2005 Tomàs Núñez Lirola <tnunez@criptos.com>,
# 2009-2014 Elan Ruusamäe <glen@pld-linux.org>
#
# Licensed under GPL v2 License
# URL: http://git.pld-linux.org/?p=packages/nagios-plugin-check_domain.git;a=summary

PROGRAM=${0##*/}
PROGPATH=${0%/*}
. $PROGPATH/utils.sh

# Default values (days):
critical=7
warning=30

# Parse arguments
args=$(getopt -o hd:w:c:P: --long help,domain:,warning:,critical:,path: -u -n $PROGRAM -- "$@")
if [ $? != 0 ]; then
	echo >&2 "$PROGRAM: Could not parse arguments"
	echo "Usage: $PROGRAM -h | -d <domain> [-c <critical>] [-w <warning>]"
	exit 1
fi
set -- $args

die() {
	local rc=$1
	local msg="$2"
	echo "$msg"
	exit $rc
}

fullusage() {
	cat <<EOF
check_domain - v1.2.7
Copyright (c) 2005 Tomàs Núñez Lirola <tnunez@criptos.com>, 2009-2014 Elan Ruusamäe <glen@pld-linux.org>
under GPL License

This plugin checks the expiration date of a domain name.

Usage: $PROGRAM -h | -d <domain> [-c <critical>] [-w <warning>]
NOTE: -d must be specified

Options:
-h
     Print detailed help
-d
     Domain name to check
-w
     Response time to result in warning status (days)
-c
     Response time to result in critical status (days)

This plugin will use whois service to get the expiration date for the domain name.
Example:
     $PROGRAM -d domain.tld -w 30 -c 10

EOF
}

# convert long month name to month number (Month Of Year)
month2moy() {
	awk -vmonth="$1" 'BEGIN {
		split("January February March April May June July August September October November December", months, " ");
		for (i in months) {
			Month[months[i]] = i;
		}
		print Month[month];
	}'
}

# convert short month name to month number (Month Of Year)
mon2moy() {
	awk -vmonth="$1" 'BEGIN {
		split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec", months, " ");
		for (i in months) {
			Month[months[i]] = i;
		}
		print Month[month];
	}'
}

while :; do
	case "$1" in
		-c|--critical) critical=$2; shift 2;;
		-w|--warning)  warning=$2; shift 2;;
		-d|--domain)   domain=$2; shift 2;;
		-P|--path)     whoispath=$2; shift 2;;
		-h|--help)     fullusage; exit;;
		--) shift; break;;
		*)  die $STATE_UNKNOWN "Internal error!";;
	esac
done

if [ -z $domain ]; then
	die $STATE_UNKNOWN "UNKNOWN - There is no domain name to check"
fi

# Looking for whois binary
if [ -z $whoispath ]; then
	type whois > /dev/null 2>&1 || die $STATE_UNKNOWN "UNKNOWN - Unable to find whois binary in your path. Is it installed? Please specify path."
	whois=whois
else
	[ -x "$whoispath/whois" ] || die $STATE_UNKNOWN "UNKNOWN - Unable to find whois binary, you specified an incorrect path"
	whois="$whoispath/whois"
fi

out=$($whois $domain)

[ -z "$out" ] && die $STATE_UNKNOWN "UNKNOWN - Domain $domain doesn't exist or no WHOIS server available."

# Calculate days until expiration
case "$domain" in
*.ru)
	# paid-till: 2013.11.01
	expiration=$(echo "$out" | sed -rne 's;paid-till:[^0-9]+([0-9]{4})\.([0-9]{1,2})\.([0-9]{2});\1-\2-\3;p')
	;;

*.ee)
	# expire: 16.11.2013
	expiration=$(echo "$out" | sed -rne 's;expire:[^0-9]+([0-9]{1,2})\.([0-9]{1,2})\.([0-9]{4});\3-\2-\1;p')
	;;

*.tv)
	# Expiration Date: 2017-01-26T10:14:11Z
	expiration=$(echo "$out" | sed -rne 's;Expiration Date:[^0-9]+([0-9]{4}-[0-9]{2}-[0-9]{2})T[0-9:Z]+;\1;p' | head -n1)
	;;
*.ca)
	# Expiry date: 2017/07/16
	expiration=$(echo "$out" | sed -rne 's;Expiry date:[^0-9]+([0-9]{4})/([0-9]{1,2})/([0-9]{2});\1-\2-\3;p')
	;;

*.ie)
	# renewal: 31-March-2016
	set -- $(echo "$out" | awk '/renewal:/{split($2, a, "-"); printf("%s %s %s\n", a[3], a[2], a[1])}')
	set -- "$1" "$(month2moy $2)" "$3"
	expiration="$1-$2-$3"
	;;

*.dk)
	# Expires: 2014-01-31
	expiration=$(echo "$out" | awk '/Expires:/ {print $2}')
	;;

*.ac.uk|*.gov.uk)
	# Renewal date:
	#   Monday 21st Sep 2015
	set -- $(echo "$out" | awk '/Renewal date:/{renewal = 1; next} {if (renewal) {print $0; exit}}')
	set -- "$4" "$(mon2moy $3)" $(echo "$2" | sed -re 's,[^0-9]+,,')
	expiration="$1-$2-$3"
	;;

*.uk)
	# Expiry date:  05-Dec-2014
	set -- $(echo "$out" | awk '/Expiry date:/{split($3, a, "-"); printf("%s %s %s\n", a[3], a[2], a[1])}')
	set -- "$1" "$(mon2moy $2)" "$3"
	expiration="$1-$2-$3"
	;;

*.is)
	# expires:      March  5 2014
	set -- $(echo "$out" | sed -E "s/\\s+/ /g" | awk '/expires:/{print($4, $2, $3)}')
	set -- "$1" "$(month2moy $2)" "$3"
	expiration="$1-$2-$3"
	;;

*.io)
	# Expiry : 2014-03-08
	expiration=$(echo "$out" | awk -F: '/Expir(ation|y)/{print $2}')
	;;

*)
	# Expiration Date: 21-sep-2018
	# Registry Expiry Date: 2015-08-03T04:00:00Z
	expiration=$(echo "$out" | awk -F: '/Expir(ation|y) Date:/{print substr($0, length($1) + 2); exit}')
	;;
esac

[ -z "$expiration" ] && die $STATE_UNKNOWN "UNKNOWN - Unable to figure out expiration date for $domain Domain."

expseconds=$(date +%s --date="$expiration")
expdate=$(date +'%Y-%m-%d' --date="$expiration")
nowseconds=$(date +%s)
diffseconds=$((expseconds-nowseconds))
expdays=$((diffseconds/86400))

# Trigger alarms if applicable
[ $expdays -lt 0 ] && die $STATE_CRITICAL "CRITICAL - Domain $domain expired on $expiration"
[ $expdays -lt $critical ] && die $STATE_CRITICAL "CRITICAL - Domain $domain will expire in $expdays days ($expdate)."
[ $expdays -lt $warning ] && die $STATE_WARNING "WARNING - Domain $domain will expire in $expdays days ($expdate)."

# No alarms? Ok, everything is right.
echo "OK - Domain $domain will expire in $expdays days ($expdate)."
exit $STATE_OK
