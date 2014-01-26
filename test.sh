#!/bin/sh
if [ ! -e utils.sh ]; then
	cat > utils.sh <<-EOF
	STATE_OK=0
	STATE_WARNING=1
	STATE_CRITICAL=2
	STATE_UNKNOWN=3
	STATE_DEPENDENT=4
	EOF
fi


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
github.io
"

whois=$(pwd)/whois.sh
for domain in ${*:-$domains}; do
	sh -$- ./check_domain.sh -d $domain -P $whois
done
