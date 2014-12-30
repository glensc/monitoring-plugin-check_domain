#!/bin/sh
domains="
amazon.ca
amazon.co.uk
amazon.ie
bbk.ac.uk
cnn.com
delfi.ee
delfi.tv
dk-hostmaster.dk
drop.io
getsynced.co
gimp.org
google.com
google.sk
isnic.is
kyounoshikaku.jp
mail.ru
nic.it
panel.li:whois.name.com
phonedot.mobi
sakura.ne.jp
trashmail.im
trashmail.se
"

whois=$(pwd)/whois.sh
sh=${SH:-/bin/sh}
for domain in ${*:-$domains}; do
	server=${domain##*:}
	domain=${domain%%:*}
	server=${server#$domain}
	echo "-> $domain"
	$sh -$- ./check_domain.sh -d $domain ${server:+-s $server} -P $whois
	echo "<- $domain"
done

exit 0
