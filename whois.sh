#!/bin/sh
set -e
# whois wrapper. uses saved outputs
t=data/whois_$(echo "$*" | sed -e 's/[^a-z0-9.-]/_/gi').txt

if [ ! -e "$t" ]; then
	install -d data
	whois "$@" > $t
	rc=$?
fi

cat $t
exit $rc
