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
mail.ru
panel.li:whois.name.com
phonedot.mobi
trashmail.se
trashmail.im
kyounoshikaku.jp
sakura.ne.jp
nic.it
"

whois=$(pwd)/whois.sh
sh=${SH:-/bin/sh}
for domain in ${*:-$domains}; do
	server=${domain##*:}
	domain=${domain%%:*}
	server=${server#$domain}
	$sh -$- ./check_domain.sh -d $domain ${server:+-s $server} -P $whois
done

exit 0
