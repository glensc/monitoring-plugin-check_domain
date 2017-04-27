#!/bin/sh
dir=$(dirname "$0")
whois=$dir/whois.sh
sh=${SH:-/bin/sh}

for domain in ${*:-$(grep -Ev '^#' "$dir/domains")}; do
	server=${domain##*:}
	domain=${domain%%:*}
	server=${server#$domain}
	echo "-> $domain"
	$sh -$- ./check_domain.sh -d $domain ${server:+-s $server} -P $whois
	echo "<- $domain"
done

exit 0
