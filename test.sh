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
phonedot.mobi
trashmail.se
"

whois=$(pwd)/whois.sh
for domain in ${*:-$domains}; do
	sh -$- ./check_domain.sh -d $domain -P $whois
done
