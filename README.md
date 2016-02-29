Nagios/Icinga Plugin: check\_domain
===================================

[![Build Status](https://travis-ci.org/glensc/nagios-plugin-check_domain.png?branch=master)](https://travis-ci.org/glensc/nagios-plugin-check_domain)

Nagios/Icinga plugin for checking a domain name expiration date

Usage:
```
$ ./check_domain.sh -d github.io
OK - Domain github.io will expire in 43 days (2014-03-08).
```

## Pull requests

1. Fork it.
2. Create your feature branch (`git checkout -b fixing-blah`).
3. Commit your changes (`git commit -am 'Fixed blah'`).
4. Run `./test.sh`, add new domain to check
5. Push to the branch (`git push origin fixing-blah`).
6. Create a new pull request.

Do not update changelog or attempt to change version.


## Installing whois

This plugin uses the "whois" command. It is usually installed by default, but if not, you can get it via your favourite package manager.

Debian/Ubuntu: 
```
# apt-get install whois
```

RHEL/CentOS:
```
# yum install jwhois
```


## Directory Listings

  * [Nagios Exchange](http://exchange.nagios.org/directory/Plugins/Internet-Domains-and-WHOIS/check_domain/details)
