#!/bin/sh
domains="
aceonlinestore.com
amazon.ca
amazon.co.uk
amazon.ie
autoproff.gl
autoproff.ir
autoproff.pl
autoproff.pt
autoproff.si
bbk.ac.uk
cnn.com
delfi.ee
delfi.tv
dk-hostmaster.dk
drop.io
getsynced.co
gimp.org
google.com
google.com.br
google.sk
greatestate.com
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
