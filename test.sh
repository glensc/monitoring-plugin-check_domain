#!/bin/sh
domains="
mail.ru
delfi.ee
delfi.tv
amazon.ca
amazon.ie
amazon.co.uk
dk-hostmaster.dk
bbk.ac.uk
cnn.com
gimp.org
isnic.is
drop.io
"

whois=$(pwd)/whois.sh
for domain in ${*:-$domains}; do
	sh -$- ./check_domain.sh -d $domain -P $whois
done
