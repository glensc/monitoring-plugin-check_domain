Nagios/Icinga Plugin: check\_domain
===================================

[![Build Status](https://travis-ci.org/glensc/monitoring-plugin-check_domain.svg?branch=master)](https://travis-ci.org/glensc/monitoring-plugin-check_domain)

Nagios/Icinga plugin for checking a domain name expiration date

### Usage

```
$ ./check_domain.sh -d github.io
OK - Domain github.io will expire in 43 days (2014-03-08).
```

### Caching

This tool excels at monitoring a small number of domains, but because of whois rate limiting, it becomes infeasible to use for a large number of domains. For this to work around, there's support for caching positive lookups for defined time period. A failed lookup will cause the domain cache file to be removed so it should be as responsive as a normal check when the critical/warning threshold is reached.

An example to configure to cache positive lookups for one day:
  * `--cache-dir /var/cache/check_domain --cache-age 1`

The cache dir must exist and must be writable for user running the checks.

## Pull requests

1. Fork it.
2. Create your feature branch (`git checkout -b fixing-blah`).
3. Commit your changes (`git commit -am 'Fixed blah'`).
4. Run `./test.sh domain.tld` to test the domain
5. Add the example domain name to [domains](domains) for CI to test them, commit it
6. Push to the branch (`git push origin fixing-blah`).
7. Create a new pull request.

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
