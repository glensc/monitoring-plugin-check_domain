#!/bin/sh
set -e
# whois wrapper. uses saved outputs
t=data/$(echo "$*" | sed -e 's/[^a-z0-9.-]/_/gi')

if [ ! -e "$t" ]; then
	install -d data
	whois "$@" > $t
	rc=$?
fi

cat $t
exit $rc
