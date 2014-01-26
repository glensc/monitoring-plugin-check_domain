#!/bin/sh
set -e
# whois wrapper. uses saved outputs
t=data/$(echo "$*" | tr '[^A-Z0-9.]' '-')

if [ ! -e "$t" ]; then
	whois "$@" > $t
	rc=$?
fi

cat $t
exit $rc
