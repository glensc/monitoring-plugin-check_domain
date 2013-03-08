%define		plugin	check_domain
Summary:	Nagios plugin for checking a domain name expiration date
Name:		nagios-plugin-%{plugin}
Version:	1.2.3
Release:	1
License:	GPL
Group:		Networking
Source0:	%{plugin}
Source1:	%{plugin}.cfg
URL:		http://www.tomas.cat/blog/en/checking-domain-name-expiration-date-checkdomain
Requires:	whois
BuildArch:	noarch
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%define		_sysconfdir	/etc/nagios/plugins
%define		plugindir	%{_prefix}/lib/nagios/plugins

%description
Nagios pluging for checking a domain name expiration date.

%prep
%setup -qcT
install -p %{SOURCE0} %{plugin}

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT{%{_sysconfdir},%{plugindir}}
install -p %{plugin} $RPM_BUILD_ROOT%{plugindir}/%{plugin}
sed -e 's,@plugindir@,%{plugindir},' %{SOURCE1} > $RPM_BUILD_ROOT%{_sysconfdir}/%{plugin}.cfg

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%config(noreplace) %verify(not md5 mtime size) %{_sysconfdir}/%{plugin}.cfg
%attr(755,root,root) %{plugindir}/%{plugin}
